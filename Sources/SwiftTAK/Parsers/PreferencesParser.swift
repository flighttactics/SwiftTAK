//
//  PreferencesParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public enum TAKDataPackageFileType {
    case USER_CERT
    case SERVER_CERT
}

public struct TAKCertificatePreference {
    public var certificateType: TAKDataPackageFileType
    public var certificateFilePath: String
    public var certificatePassword: String
    
    public var certificateFileName: String {
        get {
            return certificateFilePath
                .replacingOccurrences(of: "\\", with: "/")
                .components(separatedBy: "/")
                .last ?? ""
        }
    }
}

/// One ATAK `cot_streams` connection (`connectString0` / `description0` / `enabled0`, etc.).
public struct TAKServerConnectionPreference: Sendable {
    public var index: String
    public var description: String
    public var connectString: String
    public var enabled: Bool

    public init(index: String, description: String, connectString: String, enabled: Bool = true) {
        self.index = index
        self.description = description
        self.connectString = connectString
        self.enabled = enabled
    }

    public var host: String {
        let parts = connectString.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        return parts.first ?? ""
    }

    public var port: String {
        let parts = connectString.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        return parts.count > 1 ? parts[1] : "8089"
    }

    public var protocolName: String {
        let parts = connectString.split(separator: ":", omittingEmptySubsequences: false).map(String.init)
        return parts.count > 2 ? parts[2] : "ssl"
    }
}

public struct TAKPreferences {
    public var userCertificateFile = ""
    public var userCertificatePassword = ""
    public var serverCertificateFile = ""
    public var serverDescription = ""
    public var serverConnectionString = ""
    public var serverEnabled = true
    public var serverCertificates: [String: TAKCertificatePreference] = [:]
    public var entries: [String: String] = [:]
    
    public var serverCertificatePassword: String {
        get {
            return serverCertificates.values.first?.certificatePassword ?? ""
        }
    }
    
    public func getKeyIndexFromAttribute(entryType: String, key: String) -> String {
        let DEFAULT_KEY: String = "default"
        
        // The preference file can have the key name as either
        // caLocation/caPassword or indexed (caLocation0/caPassword0, caLocation1/caPassword1, etc)
        // This gets the index or the "default" key if one doesn't exist
        let keyIndex = key.replacingOccurrences(of: entryType, with: "")
        
        guard(!keyIndex.isEmpty) else { return DEFAULT_KEY }
        return keyIndex
    }
    
    public mutating func addServerCertificateWithKey(certPath: String, key: String) {
        let keyIndex = getKeyIndexFromAttribute(entryType: "caLocation", key: key)
        
        let existingCert = serverCertificates[keyIndex]
        
        if(existingCert == nil) {
            serverCertificates[keyIndex] = TAKCertificatePreference(certificateType: .SERVER_CERT, certificateFilePath: certPath, certificatePassword: "")
        } else {
            serverCertificates[keyIndex]!.certificateFilePath = certPath
        }
    }
    
    public mutating func addServerCertificatePasswordWithKey(password: String, key: String) {
        let keyIndex = getKeyIndexFromAttribute(entryType: "caPassword", key: key)
        let existingCert = serverCertificates[keyIndex]
        
        
        if(existingCert == nil) {
            serverCertificates[keyIndex] = TAKCertificatePreference(certificateType: .SERVER_CERT, certificateFilePath: "", certificatePassword: password)
        } else {
            serverCertificates[keyIndex]!.certificatePassword = password
        }
    }
    
    public func userCertificateFileName() -> String {
        let normalized = userCertificateFile.replacingOccurrences(of: "\\", with: "/")
        let splitFile = normalized.components(separatedBy: "/")
        return splitFile[splitFile.count-1]
    }
    
    // Deprecated - will return only the first server certificate
    public func serverCertificateFileName() -> String {
        TAKLogger.info("[PreferencesParser]: DEPRECATION WARNING: serverCertificateFileName is deprecated. Please inspect the serverCertificates instead")
        return serverCertificates.values.first?.certificateFileName ?? ""
    }
    
    public func serverConnectionAddress() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile.count > 0 ? splitFile[0] : ""
    }
    
    public func serverConnectionPort() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile.count > 1 ? splitFile[1] : ""
    }
    
    public func serverConnectionProtocol() -> String {
        let splitFile = serverConnectionString.components(separatedBy: ":")
        return splitFile.count > 2 ? splitFile[2] : ""
    }

    /// Groups `connectString{N}` / `description{N}` / `enabled{N}` into connection records.
    public func cotStreamConnections() -> [TAKServerConnectionPreference] {
        var indices = Set<String>()
        for key in entries.keys {
            if key == "connectString" {
                indices.insert("0")
            } else if key.hasPrefix("connectString") {
                let suffix = String(key.dropFirst("connectString".count))
                if !suffix.isEmpty, suffix.allSatisfy(\.isNumber) {
                    indices.insert(suffix)
                }
            }
        }
        if indices.isEmpty, !serverConnectionString.isEmpty {
            return [
                TAKServerConnectionPreference(
                    index: "0",
                    description: serverDescription,
                    connectString: serverConnectionString,
                    enabled: serverEnabled
                )
            ]
        }

        return indices.sorted { (Int($0) ?? 0) < (Int($1) ?? 0) }.compactMap { index in
            let connectKey = index == "0" && entries["connectString0"] == nil
                ? "connectString"
                : "connectString\(index)"
            let connect = entries[connectKey] ?? (index == "0" ? serverConnectionString : "")
            guard !connect.isEmpty else { return nil }
            let descriptionKey = index == "0" && entries["description0"] == nil
                ? "description"
                : "description\(index)"
            // ATAK writes enabled0/enabled1; older packages may use bare `enabled` for stream 0.
            let enabledKey = "enabled\(index)"
            let description = entries[descriptionKey]
                ?? (index == "0" ? serverDescription : "")
            let enabledValue = entries[enabledKey]
                ?? (index == "0" ? (entries["enabled"] ?? (serverEnabled ? "true" : "false")) : "true")
            let enabled = enabledValue.lowercased() != "false"
            return TAKServerConnectionPreference(
                index: index,
                description: description.isEmpty ? connect : description,
                connectString: connect,
                enabled: enabled
            )
        }
    }

    public mutating func merge(from other: TAKPreferences) {
        if !other.userCertificateFile.isEmpty {
            userCertificateFile = other.userCertificateFile
        }
        if !other.userCertificatePassword.isEmpty {
            userCertificatePassword = other.userCertificatePassword
        }
        if !other.serverCertificateFile.isEmpty {
            serverCertificateFile = other.serverCertificateFile
        }
        if !other.serverDescription.isEmpty {
            serverDescription = other.serverDescription
        }
        if !other.serverConnectionString.isEmpty {
            serverConnectionString = other.serverConnectionString
        }
        serverEnabled = other.serverEnabled

        for (key, cert) in other.serverCertificates {
            if var existing = serverCertificates[key] {
                if existing.certificateFilePath.isEmpty {
                    existing.certificateFilePath = cert.certificateFilePath
                }
                if existing.certificatePassword.isEmpty {
                    existing.certificatePassword = cert.certificatePassword
                }
                serverCertificates[key] = existing
            } else {
                serverCertificates[key] = cert
            }
        }

        for (key, value) in other.entries where !value.isEmpty {
            entries[key] = value
        }
    }
}

public class PreferencesParser: NSObject, XMLParserDelegate {
    public var preferences: TAKPreferences = TAKPreferences()
    
    private var textBuffer: String = ""
    private var currentAttr: String = ""
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "entry") {
            let value = textBuffer
            if !currentAttr.isEmpty {
                preferences.entries[currentAttr] = value
            }

            switch currentAttr {
            case "description0", "description":
                preferences.serverDescription = value
            case "connectString0", "connectString":
                preferences.serverConnectionString = value
            case "enabled0", "enabled":
                preferences.serverEnabled = value.lowercased() != "false"
            case "clientPassword":
                preferences.userCertificatePassword = value
            case "certificateLocation":
                preferences.userCertificateFile = value
            case "caLocation":
                preferences.addServerCertificateWithKey(certPath: value, key: currentAttr)
            case "caPassword":
                preferences.addServerCertificatePasswordWithKey(password: value, key: currentAttr)
            default:
                if(currentAttr.starts(with: "caLocation")) {
                    preferences.addServerCertificateWithKey(certPath: value, key: currentAttr)
                } else if(currentAttr.starts(with: "caPassword")) {
                    preferences.addServerCertificatePasswordWithKey(password: value, key: currentAttr)
                } else if currentAttr.hasPrefix("connectString"),
                          preferences.serverConnectionString.isEmpty {
                    preferences.serverConnectionString = value
                } else if currentAttr.hasPrefix("description"),
                          preferences.serverDescription.isEmpty {
                    preferences.serverDescription = value
                }
            }

            currentAttr = ""
            textBuffer = ""
        }
    }
    
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if(elementName == "entry") {
            for (attr_key, attr_val) in attributeDict {
                if(attr_key == "key") {
                    currentAttr = attr_val
                    textBuffer = ""
                }
            }
        }
        
    }
}

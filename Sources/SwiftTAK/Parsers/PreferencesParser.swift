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
            return certificateFilePath.components(separatedBy: "/").last ?? ""
        }
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
        let splitFile = userCertificateFile.components(separatedBy: "/")
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
            switch currentAttr {
            case "description0", "description":
                preferences.serverDescription = textBuffer
            case "connectString0", "connectString":
                preferences.serverConnectionString = textBuffer
            case "clientPassword":
                preferences.userCertificatePassword = textBuffer
            case "certificateLocation":
                preferences.userCertificateFile = textBuffer
            case "caLocation":
                preferences.addServerCertificateWithKey(certPath: textBuffer, key: currentAttr)
            case "caPassword":
                preferences.addServerCertificatePasswordWithKey(password: textBuffer, key: currentAttr)
            default:
                if(currentAttr.starts(with: "caLocation")) {
                    preferences.addServerCertificateWithKey(certPath: textBuffer, key: currentAttr)
                } else if(currentAttr.starts(with: "caPassword")) {
                    preferences.addServerCertificatePasswordWithKey(password: textBuffer, key: currentAttr)
                } else {
                    currentAttr = ""
                    textBuffer = ""
                }
            }
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

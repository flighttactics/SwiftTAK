//
//  PreferencesParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public struct TAKPreferences {
    public var userCertificateFile = ""
    public var userCertificatePassword = ""
    public var serverCertificateFile = ""
    public var serverCertificatePassword = ""
    public var serverDescription = ""
    public var serverConnectionString = ""
    public var serverEnabled = true
    
    public func userCertificateFileName() -> String {
        let splitFile = userCertificateFile.components(separatedBy: "/")
        TAKLogger.debug(String(describing: splitFile))
        return splitFile[splitFile.count-1]
    }
    
    public func serverCertificateFileName() -> String {
        let splitFile = serverCertificateFile.components(separatedBy: "/")
        TAKLogger.debug(String(describing: splitFile))
        return splitFile[splitFile.count-1]
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
            case("description0"):
                preferences.serverDescription = textBuffer
            case("connectString0"):
                preferences.serverConnectionString = textBuffer
            case("caLocation"):
                preferences.serverCertificateFile = textBuffer
            case("caPassword"):
                preferences.serverCertificatePassword = textBuffer
            case("clientPassword"):
                preferences.userCertificatePassword = textBuffer
            case("certificateLocation"):
                preferences.userCertificateFile = textBuffer
                    
            default:
                currentAttr = ""
                textBuffer = ""
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

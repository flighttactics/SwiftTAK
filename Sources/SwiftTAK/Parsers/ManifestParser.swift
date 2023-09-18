//
//  ManifestParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

class ManifestParser: NSObject, XMLParserDelegate {
    var fileNames = [String]()
    
    func prefsFile() -> String {
        return fileNames.first(where: { $0.contains(".pref")}) ?? ""
    }
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if(elementName == "Content") {
            for (attr_key, attr_val) in attributeDict {
                if(attr_key == "zipEntry") {
                    let splitFile = attr_val.components(separatedBy: "\\")
                    let file = splitFile[splitFile.count-1]
                    TAKLogger.debug("[ManifestParser]: Adding file \(file)")
                    fileNames.append(file)
                }
            }
        }
        
    }
}

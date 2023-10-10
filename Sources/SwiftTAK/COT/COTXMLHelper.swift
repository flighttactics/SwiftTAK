//
//  COTXMLHelper.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public class COTXMLHelper {
    public static func generateXML(nodeName: String, attributes: [String:String], message: String, includeEmptyAttributes: Bool = false) -> String {
        let root = XMLElement(name: nodeName, stringValue: message)
        for attrPair in attributes {
            if(attrPair.value.isEmpty && !includeEmptyAttributes) {
                continue
            }
            root.addAttribute(XMLNode.attribute(withName: attrPair.key, stringValue: attrPair.value))
        }
        
        return root.xmlString
    }
    
    public static func generateXML(nodeName: String, attributes: [String:String], childNodes: [COTNode], includeEmptyAttributes: Bool = false) -> String {
        let root = XMLElement(name: nodeName)
        for attrPair in attributes {
            if(attrPair.value.isEmpty && !includeEmptyAttributes) {
                continue
            }
            root.addAttribute(XMLNode.attribute(withName: attrPair.key, stringValue: attrPair.value))
        }

        for node in childNodes {
            do {
                let nodeXml = try XMLElement(xmlString: node.toXml())
                root.addChild(nodeXml)
            } catch {
                TAKLogger.error("Exception adding nodeXML to root from xml \(node.toXml())")
            }
        }
        
        return root.xmlString
    }
}

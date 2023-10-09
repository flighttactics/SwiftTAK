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
            root.addAttribute(XMLNode.attribute(withName: attrPair.key, stringValue: attrPair.value) as! XMLNode)
        }
        
        return root.xmlString
    }
    
    public static func generateXML(nodeName: String, attributes: [String:String], childNodes: [COTNode], includeEmptyAttributes: Bool = false) -> String {
        let root = XMLElement(name: nodeName)
        for attrPair in attributes {
            if(attrPair.value.isEmpty && !includeEmptyAttributes) {
                continue
            }
            root.addAttribute(XMLNode.attribute(withName: attrPair.key, stringValue: attrPair.value) as! XMLNode)
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

//func testXmlBlah() {
//    var root = XMLElement(name: "uid")
//    root.addAttribute(XMLNode.attribute(withName: "Droid", stringValue: "TESTER-1") as! XMLNode)
//    let doc = XMLDocument(rootElement: root)
//    TAKLogger.debug(root.xmlString)
//}

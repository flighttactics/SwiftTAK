//
//  XMLElement.swift
//  
//
//  Created by Cory Foy on 10/10/23.
//

import Foundation

class XMLElement : XMLNode {
    
    init(xmlString: String) throws {
        let nodeParser = XMLNode(key: "", value: "")
        let xmlParser = XMLParser(data: Data(xmlString.utf8))
        xmlParser.delegate = nodeParser
        xmlParser.parse()
        super.init(key: nodeParser.key, value: nodeParser.stringValue)
        self.attributes = nodeParser.attributes
        self.childNodes = nodeParser.childNodes
        self.xmlString = xmlString
    }
    
    init(name: String, stringValue: String) {
        super.init(key: name, value: stringValue)
        regenXmlString()
    }
    
    init(name: String) {
        super.init(key: name, value: "")
        regenXmlString()
    }
    
    func addAttribute(_ node: XMLNode) {
        attributes[node.key] = node.stringValue
        regenXmlString()
    }
    
    func addChild(_ node: XMLElement) {
        childNodes.append(node)
        regenXmlString()
    }
    
    func attribute(forName: String) -> XMLNode? {
        let attrVal = attributes[forName]
        if(attrVal == nil) {
            return nil
        }
        return XMLNode(key: forName, value: attrVal!)
    }
}

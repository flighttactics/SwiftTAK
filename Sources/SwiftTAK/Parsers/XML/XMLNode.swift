//
//  XMLNode.swift
//  
//
//  Created by Cory Foy on 10/10/23.
//

import Foundation

class XMLNode: NSObject, XMLParserDelegate {
    var key: String
    var stringValue: String
    var attributes: [String:String] = [:]
    var childNodes: [XMLElement] = []
    var xmlString = ""
    private var textBuffer: String = ""
    private var currentAttr: String = ""
    private var tempNodes: [String:XMLElement] = [:]
    
    public init(key: String, value: String) {
        self.key = key
        self.stringValue = value
    }
    
    public static func attribute(withName: String, stringValue: String) -> XMLNode {
        return XMLNode(key: withName, value: stringValue)
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        textBuffer += string
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let node = tempNodes[elementName]
        if(node != nil) {
            node!.stringValue = textBuffer
            if(key.isEmpty) {
                key = node!.key
                stringValue = node!.stringValue
                attributes = node!.attributes
            } else {
                childNodes.append(node!)
            }
            tempNodes.removeValue(forKey: elementName)
        }
        textBuffer = ""
    }
    
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        let node = XMLElement(name: elementName, stringValue: "")
        for (attr_key, attr_val) in attributeDict {
            node.attributes[attr_key] = attr_val
        }
        tempNodes[elementName] = node
    }
    
    func regenXmlString() {
        var tmpStr = ""
        tmpStr += "<\(key)"
        for attrPair in attributes {
            tmpStr += " \(attrPair.key)='\(attrPair.value)'"
        }
        tmpStr += ">"
        if(stringValue.isEmpty) {
            for node in childNodes {
                tmpStr += node.xmlString
            }
        } else {
            tmpStr += stringValue
        }
        tmpStr += "</\(key)>"
        xmlString = tmpStr
    }
}

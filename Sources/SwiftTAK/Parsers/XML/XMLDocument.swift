//
//  XMLDocument.swift
//  
//
//  Created by Cory Foy on 10/10/23.
//

import Foundation

class XMLDocument: Equatable {
    var rootNode: XMLNode
    
    init(xmlString: String) throws {
        let nodeParser = XMLNode(key: "", value: "")
        let xmlParser = XMLParser(data: Data(xmlString.utf8))
        xmlParser.delegate = nodeParser
        xmlParser.parse()
        rootNode = XMLNode(key: nodeParser.key, value: nodeParser.stringValue)
        rootNode.attributes = nodeParser.attributes
        rootNode.childNodes = nodeParser.childNodes
    }
    
    func nodes(forXPath: String) throws -> [XMLNode] {
        var results: [XMLNode] = []
        let isRecursive = forXPath.starts(with: "//")
        let components = forXPath.split(separator: "/")
        for component in components {
            let subcomponents = component.split(separator: "[")
            var nodeName = ""
            var attrName = ""
            var attrValue = ""

            if(subcomponents.count > 1) {
                nodeName = String(subcomponents.first!)
                var attrPart = String(subcomponents.last!)
                attrPart = attrPart.replacingOccurrences(of: "@", with: "")
                attrPart = attrPart.replacingOccurrences(of: "]", with: "")
                attrPart = attrPart.replacingOccurrences(of: "'", with: "")
                let attrComponents = attrPart.split(separator: "=")
                attrName = String(attrComponents.first!)
                attrValue = String(attrComponents.last!)
            } else {
                nodeName = String(component)
            }
            
            if(doesMatch(node: rootNode, nodeName: nodeName, attrName: attrName, attrValue: attrValue)) {
                results.append(rootNode)
            }
            
            if(isRecursive) {
                for node in rootNode.childNodes {
                    if(doesMatch(node: node, nodeName: nodeName, attrName: attrName, attrValue: attrValue)) {
                        results.append(node)
                    }
                }
            }
        }
        return results
    }
    
    private func doesMatch(node: XMLNode, nodeName: String, attrName: String = "", attrValue: String = "") -> Bool {
        var doesMatch = false
        doesMatch = node.key == nodeName
        if(doesMatch && !attrName.isEmpty) {
            doesMatch = node.attributes[attrName] == attrValue
        }
        return doesMatch
    }
    
    static func == (lhs: XMLDocument, rhs: XMLDocument) -> Bool {
        return lhs.rootNode.key == rhs.rootNode.key &&
        lhs.rootNode.stringValue == rhs.rootNode.stringValue &&
        lhs.rootNode.attributes == rhs.rootNode.attributes
    }
}

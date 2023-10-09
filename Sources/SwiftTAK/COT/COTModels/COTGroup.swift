//
//  COTGroup.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTGroup : COTNode {
    public init(name: String, role: String) {
        self.name = name
        self.role = role
    }
    
    public var name:String
    public var role:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["name"] = name
        attrs["role"] = role
        return COTXMLHelper.generateXML(nodeName: "__group", attributes: attrs, message: "")
    }
}

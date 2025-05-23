//
//  COTGroup.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTGroup : COTNode {
    public init(name: String, role: String, abbr: String = "", exrole: String = "") {
        self.name = name
        self.role = role
        self.abbr = abbr
        self.exrole = exrole
    }
    
    public var name: String
    public var role: String
    public var abbr: String // Used for extended roles as the abbreviation to show in the icon
    public var exrole: String // User for the extended role name
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["name"] = name
        attrs["role"] = role
        if(!abbr.isEmpty) {
            attrs["abbr"] = abbr
        }
        if(!exrole.isEmpty) {
            attrs["exrole"] = exrole
        }
        return COTXMLHelper.generateXML(nodeName: "__group", attributes: attrs, message: "")
    }
}

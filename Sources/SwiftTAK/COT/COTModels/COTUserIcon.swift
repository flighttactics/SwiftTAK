//
//  COTUserIcon.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/7/24.
//

import Foundation

public struct COTUserIcon : COTNode, Equatable {
    public var iconsetPath: String = ""
    
    public init(iconsetPath: String) {
        self.iconsetPath = iconsetPath
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["iconsetpath"] = iconsetPath
        return COTXMLHelper.generateXML(nodeName: "usericon", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTUserIcon, rhs: COTUserIcon) -> Bool {
        return lhs.iconsetPath == rhs.iconsetPath
    }
}

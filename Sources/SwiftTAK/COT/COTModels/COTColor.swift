//
//  COTColor.swift
//  TAKTracker
//
//  Created by Cory Foy on 7/7/24.
//

import Foundation

public struct COTColor : COTNode, Equatable {
    public var argb: Int = 0
    
    public init(argb: Int) {
        self.argb = argb
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        // Emit both: ATAK markers read `argb`, shapes/routes often read `value`.
        attrs["argb"] = argb.description
        attrs["value"] = argb.description
        return COTXMLHelper.generateXML(nodeName: "color", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTColor, rhs: COTColor) -> Bool {
        return lhs.argb == rhs.argb
    }
}

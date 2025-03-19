//
//  COTStrokeColor.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/23/24.
//

import Foundation

public struct COTStrokeColor : COTNode, Equatable {
    public var value: Int = 0
    
    public init(value: Int) {
        self.value = value
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["value"] = value.description
        return COTXMLHelper.generateXML(nodeName: "strokeColor", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTStrokeColor, rhs: COTStrokeColor) -> Bool {
        return lhs.value == rhs.value
    }
}

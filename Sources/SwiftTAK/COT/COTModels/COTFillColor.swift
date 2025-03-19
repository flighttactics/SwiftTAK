//
//  COTFillColor.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/23/24.
//

import Foundation

public struct COTFillColor : COTNode, Equatable {
    public var value: Int = 0
    
    public init(value: Int) {
        self.value = value
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["value"] = value.description
        return COTXMLHelper.generateXML(nodeName: "fillColor", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTFillColor, rhs: COTFillColor) -> Bool {
        return lhs.value == rhs.value
    }
}

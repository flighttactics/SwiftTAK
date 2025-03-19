//
//  COTStrokeWeight.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/23/24.
//

import Foundation

public struct COTStrokeWeight : COTNode, Equatable {
    public var value: Double = 0.0
    
    public init(value: Double) {
        self.value = value
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["value"] = value.description
        return COTXMLHelper.generateXML(nodeName: "strokeWeight", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTStrokeWeight, rhs: COTStrokeWeight) -> Bool {
        return lhs.value == rhs.value
    }
}

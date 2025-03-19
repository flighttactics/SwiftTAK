//
//  COTLabelsOn.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/23/24.
//

import Foundation

public struct COTLabelsOn : COTNode, Equatable {
    public var value: Bool = true
    
    public init(value: Bool) {
        self.value = value
    }
    
    public init(value: String) {
        self.value = (value == "true")
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["value"] = value.description
        return COTXMLHelper.generateXML(nodeName: "labels_on", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTLabelsOn, rhs: COTLabelsOn) -> Bool {
        return lhs.value == rhs.value
    }
}

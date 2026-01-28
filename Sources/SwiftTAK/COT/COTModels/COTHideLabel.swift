//
//  COTHideLabel.swift
//  SwiftTAK
//
//  Created by Cory Foy on 12/20/25.
//

import Foundation

public struct COTHideLabel : COTNode, Equatable {
    public init() {}
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        return COTXMLHelper.generateXML(nodeName: "hideLabel", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTHideLabel, rhs: COTHideLabel) -> Bool {
        return true
    }
}

//
//  COTServerDestination.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTServerDestination : COTNode {
    public init(destinations: String = "") {
        self.destinations = destinations
    }
    
    
    public var destinations: String = ""
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["destinations"] = destinations
        return COTXMLHelper.generateXML(nodeName: "__serverdestination", attributes: attrs, message: "")
    }
}

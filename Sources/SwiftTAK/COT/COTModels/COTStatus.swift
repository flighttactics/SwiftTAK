//
//  COTStatus.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTStatus : COTNode {
    public init(battery: String) {
        self.battery = battery
    }
    
    public var battery:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["battery"] = battery
        return COTXMLHelper.generateXML(nodeName: "status", attributes: attrs, message: "")
    }
}

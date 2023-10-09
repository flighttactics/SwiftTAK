//
//  COTUid.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTUid : COTNode {
    public init(callsign: String) {
        self.callsign = callsign
    }
    
    public var callsign:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["Droid"] = callsign
        return COTXMLHelper.generateXML(nodeName: "uid", attributes: attrs, message: "")
    }
}

//
//  COTEmergency.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTEmergency : COTNode {
    public init(cancel: Bool, type: EmergencyType, callsign: String) {
        self.cancel = cancel
        self.type = type
        self.callsign = callsign
    }
    
    public var cancel: Bool
    public var type: EmergencyType
    public var callsign: String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["cancel"] = cancel.description
        attrs["type"] = type.description
        return COTXMLHelper.generateXML(nodeName: "emergency", attributes: attrs, message: callsign)
    }
}

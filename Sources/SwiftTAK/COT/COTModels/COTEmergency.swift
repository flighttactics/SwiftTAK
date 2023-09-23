//
//  COTEmergency.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTEmergency : COTNode {
    public var cancel: Bool
    public var type: EmergencyType
    public var callsign: String
    
    public func toXml() -> String {
        return "<emergency " +
        "cancel='\(cancel.description)' " +
        "type='\(type)'>" +
        callsign +
        "</emergency>"
    }
}

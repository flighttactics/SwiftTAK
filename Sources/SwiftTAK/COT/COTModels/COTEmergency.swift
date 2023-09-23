//
//  COTEmergency.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTEmergency : COTNode {
    var cancel: Bool
    var type: EmergencyType
    var callsign: String
    
    func toXml() -> String {
        return "<emergency " +
        "cancel='\(cancel.description)' " +
        "type='\(type)'>" +
        callsign +
        "</emergency>"
    }
}

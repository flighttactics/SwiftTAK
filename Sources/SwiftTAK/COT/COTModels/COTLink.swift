//
//  COTLink.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTLink : COTNode {
    var parentCallsign: String = ""
    var productionTime: String = ""
    var relation: String
    var type: String
    var uid: String
    var callsign: String = ""
    var remarks: String = ""
    
    func toXml() -> String {
        return "<link " +
        "parent_callsign='\(parentCallsign)' " +
        "production_time='\(productionTime)' " +
        "relation='\(relation)' " +
        "type='\(type)' " +
        "uid='\(uid)' " +
        "callsign='\(callsign)' " +
        "remarks='\(remarks)'" +
        "></link>"
    }
}

//
//  COTLink.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTLink : COTNode {
    public init(parentCallsign: String = "", productionTime: String = "", relation: String, type: String, uid: String, callsign: String = "") {
        self.parentCallsign = parentCallsign
        self.productionTime = productionTime
        self.relation = relation
        self.type = type
        self.uid = uid
        self.callsign = callsign
    }
    
    public var parentCallsign: String = ""
    public var productionTime: String = ""
    public var relation: String
    public var type: String
    public var uid: String
    public var callsign: String = ""
    
    public func toXml() -> String {
        return "<link " +
        "parent_callsign='\(parentCallsign)' " +
        "production_time='\(productionTime)' " +
        "relation='\(relation)' " +
        "type='\(type)' " +
        "uid='\(uid)' " +
        "callsign='\(callsign)' " +
        "></link>"
    }
}

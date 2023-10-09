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
        var attrs: [String:String] = [:]
        attrs["parent_callsign"] = parentCallsign
        attrs["production_time"] = productionTime
        attrs["relation"] = relation
        attrs["type"] = type
        attrs["uid"] = uid
        attrs["callsign"] = callsign
        return COTXMLHelper.generateXML(nodeName: "link", attributes: attrs, message: "")
    }
}

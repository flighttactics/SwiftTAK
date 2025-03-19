//
//  COTLink.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTLink : COTNode, Equatable {
    
    public var parentCallsign: String = ""
    public var productionTime: String = ""
    public var relation: String = ""
    public var type: String = ""
    public var uid: String = ""
    public var callsign: String = ""
    public var remarks: String = ""
    public var point: String = ""
    
    public init(parentCallsign: String = "", productionTime: String = "", relation: String = "", type: String = "", uid: String = "", callsign: String = "", remarks: String = "", point: String = "") {
        self.parentCallsign = parentCallsign
        self.productionTime = productionTime
        self.relation = relation
        self.type = type
        self.uid = uid
        self.callsign = callsign
        self.remarks = remarks
        self.point = point
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["parent_callsign"] = parentCallsign
        attrs["production_time"] = productionTime
        attrs["relation"] = relation
        attrs["type"] = type
        attrs["uid"] = uid
        attrs["callsign"] = callsign
        attrs["remarks"] = remarks
        attrs["point"] = point
        return COTXMLHelper.generateXML(nodeName: "link", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTLink, rhs: COTLink) -> Bool {
        return
            lhs.uid == rhs.uid &&
            lhs.relation == rhs.relation &&
            lhs.type == rhs.type &&
            lhs.callsign == rhs.callsign &&
            lhs.productionTime == rhs.productionTime &&
            lhs.parentCallsign == rhs.parentCallsign &&
            lhs.remarks == rhs.remarks &&
            lhs.point == rhs.point
    }
}

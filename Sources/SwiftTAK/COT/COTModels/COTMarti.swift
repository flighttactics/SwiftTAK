//
//  COTMarti.swift
//  SwiftTAK
//
//  Created by Cory Foy on 6/5/25.
//

public struct COTMarti: COTNode, Equatable {
    public var uid: String?
    public var callsign: String?
    public var mission: String?
    
    public init(uid: String) {
        self.uid = uid
        self.callsign = nil
        self.mission = nil
    }
    
    public init(callsign: String) {
        self.callsign = callsign
        self.uid = nil
        self.mission = nil
    }
    
    public init(mission: String) {
        self.mission = mission
        self.uid = nil
        self.callsign = nil
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        if let uid = uid {
            attrs["uid"] = uid
        }
        if let callsign = callsign {
            attrs["callsign"] = callsign
        }
        if let mission = mission {
            attrs["mission"] = mission
        }
        let dest = COTXMLHelper.generateXML(nodeName: "dest", attributes: attrs, message: "")
        return COTXMLHelper.generateXML(nodeName: "marti", attributes: [:], message: dest)
    }
    
    public static func == (lhs: COTMarti, rhs: COTMarti) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.callsign == rhs.callsign &&
        lhs.mission == rhs.mission
    }
}

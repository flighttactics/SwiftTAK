//
//  COTCreator.swift
//  SwiftTAK
//
//  Created by Cory Foy on 6/11/25.
//

import Foundation

public struct COTCreator : COTNode, Equatable {
    
    // <creator uid=\"ANDROID-07b42ddf9728082d\" callsign=\"FT-CFOY-S23\" time=\"2025-06-09T12:40:07.103Z\" type=\"a-f-G-U-C\"/>
    
    public init(uid: String, callsign: String, type: String, time: Date) {
        self.uid = uid
        self.callsign = callsign
        self.type = type
        self.time = time
    }
    
    public var uid: String = ""
    public var callsign: String = ""
    public var type: String
    public var time: Date
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["uid"] = uid
        attrs["callsign"] = callsign
        attrs["type"] = type
        attrs["time"] = ISO8601DateFormatter().string(from: time)
        return COTXMLHelper.generateXML(nodeName: "creator", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTCreator, rhs: COTCreator) -> Bool {
        return
            lhs.uid == rhs.uid &&
            lhs.callsign == rhs.callsign &&
            lhs.type == rhs.type &&
            lhs.time == rhs.time
    }
}

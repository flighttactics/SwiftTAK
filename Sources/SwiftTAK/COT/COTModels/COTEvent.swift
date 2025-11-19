//
//  COTEvent.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

// Note: There are other things that could be in the type field
// see https://github.com/deptofdefense/AndroidTacticalAssaultKit-CIV/blob/22d11cba15dd5cfe385c0d0790670bc7e9ab7df4/atak/ATAK/app/src/main/java/com/atakmap/android/cot/CotMapAdapter.java#L263
// we handle those by defaulting to CUSTOM but be aware if you're
// doing your own processing
public enum COTEventType: String {
    case ATOM = "a"
    case BIT = "b"
    case TASKING = "t"
    case CAPABILITY = "c"
    // Note: The MITRE guide defines reservation *and* reply
    // as both 'r' prefixes. However, the Types guide in the
    // ATAK project defines 'r' as Reservation/Restriction/References
    // and 'y' as Reply, so that's what we'll use here
    case RESERVATION = "r"
    case REPLY = "y"
    // The ATAK project also shows examples with a 'u' prefix
    // We'll just consider these as custom
    // These are things like polygons and routes
    case CUSTOM = "u"
}

public struct COTEvent : COTNode, Equatable {
    public init(version: String, uid: String, type: String, how: String, time: Date, start: Date, stale: Date, childNodes: [COTNode] = []) {
        self.version = version
        self.uid = uid
        self.type = type
        self.how = how
        self.time = time
        self.start = start
        self.stale = stale
        self.childNodes = childNodes
    }
    
    public var version:String
    public var uid:String
    public var type:String
    public var how:String
    public var time:Date
    public var start:Date
    public var stale:Date
    public var childNodes: [COTNode] = []
    public var cotPoint: COTPoint? {
        return childNodes.first(where: { $0 is COTPoint }) as? COTPoint
    }
    
    public var cotDetail: COTDetail? {
        return childNodes.first(where: { $0 is COTDetail }) as? COTDetail
    }
    
    public var eventType: COTEventType {
        COTEventType(rawValue: String(type.first ?? "u")) ?? COTEventType.CUSTOM
    }
    
    public var isAlert: Bool {
        if let cotEmergency = cotDetail?.cotEmergency {
            return !cotEmergency.cancel
        }
        return false
    }
    
    public var hasAttachments: Bool {
        return cotDetail?.cotAttachmentList != nil
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["version"] = version
        attrs["uid"] = uid
        attrs["type"] = type
        attrs["how"] = how
        attrs["time"] = ISO8601DateFormatter().string(from: time)
        attrs["start"] = ISO8601DateFormatter().string(from: start)
        attrs["stale"] = ISO8601DateFormatter().string(from: stale)
        
        return COTXMLHelper.generateXML(
            nodeName: "event",
            attributes: attrs,
            childNodes: childNodes)
    }
    
    public static func == (lhs: COTEvent, rhs: COTEvent) -> Bool {
        return
            lhs.uid == rhs.uid &&
            lhs.type == rhs.type &&
            lhs.how == rhs.how &&
            lhs.time == rhs.time &&
            lhs.start == rhs.start &&
            lhs.stale == rhs.stale
    }
}

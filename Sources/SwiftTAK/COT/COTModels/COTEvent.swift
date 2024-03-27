//
//  COTEvent.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

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
        var point: COTPoint?
        childNodes.forEach {
           if($0 is COTPoint) {
               point = $0 as? COTPoint
            }
        }
        return point
    }
    
    public var cotDetail: COTDetail? {
        var detail: COTDetail?
        childNodes.forEach {
           if($0 is COTDetail) {
               detail = $0 as? COTDetail
            }
        }
        return detail
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

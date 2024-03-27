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
//        self.childNodeStorage = childNodes
        
//        childNodeStorage.forEach {
//            if($0 is COTDetail) {
//                cotDetail = $0 as? COTDetail
//            } else if($0 is COTPoint) {
//                cotPoint = $0 as? COTPoint
//            }
//        }
    }
    
    public var version:String
    public var uid:String
    public var type:String
    public var how:String
    public var time:Date
    public var start:Date
    public var stale:Date
    public var childNodes: [COTNode] = []
//    var childNodeStorage: [COTNode] = []
//    public var childNodes:[COTNode] { return childNodeStorage }
//    public var cotPoint: COTPoint?
//    public var cotDetail: COTDetail?
//    
//    public func addChildNode(node: COTNode) {
//        childNodeStorage.append(node)
//        if(node is COTDetail) {
//            self.cotDetail = $0 as? COTDetail
//        } else if(node is COTPoint) {
//            self.cotPoint = $0 as? COTPoint
//        }
//    }
    
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

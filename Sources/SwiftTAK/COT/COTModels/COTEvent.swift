//
//  COTEvent.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTEvent : COTNode {
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
    public var childNodes:[COTNode] = []
    
    public var detail: COTDetail? {
        get { return childNodes.first(where: { $0 as? COTDetail != nil }) as? COTDetail }
    }
    
    public var point: COTPoint? {
        get { return childNodes.first(where: { $0 as? COTPoint != nil }) as? COTPoint }
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
}

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
    
    public func toXml() -> String {
        return "<event " +
        "version='\(version)' " +
        "uid='\(uid)' " +
        "type='\(type)' " +
        "how='\(how)' " +
        "time='\(ISO8601DateFormatter().string(from: time))' " +
        "start='\(ISO8601DateFormatter().string(from: start))' " +
        "stale='\(ISO8601DateFormatter().string(from: stale))'" +
        ">" +
        childNodes.map { $0.toXml() }.joined() +
        "</event>"
    }
}

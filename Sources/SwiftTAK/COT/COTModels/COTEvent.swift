//
//  COTEvent.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTEvent : COTNode {
    var version:String
    var uid:String
    var type:String
    var how:String
    var time:Date
    var start:Date
    var stale:Date
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
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

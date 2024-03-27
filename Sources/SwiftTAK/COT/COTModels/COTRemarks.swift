//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode, Equatable {
    public init(source: String = "", timestamp: String = "", message: String = "") {
        self.source = source
        self.timestamp = timestamp
        self.message = message
    }
    
    
    public var source: String = ""
    public var timestamp: String = ""
    public var message: String = ""
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["source"] = source
        attrs["timestamp"] = timestamp
        return COTXMLHelper.generateXML(nodeName: "remarks", attributes: attrs, message: message)
    }
    
    public static func == (lhs: COTRemarks, rhs: COTRemarks) -> Bool {
        return
            lhs.source == rhs.source &&
            lhs.timestamp == rhs.timestamp &&
            lhs.message == rhs.message
    }
}

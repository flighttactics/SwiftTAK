//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode, Equatable {
    public init(source: String = "", timestamp: String = "", message: String = "", to: String = "") {
        self.source = source
        self.timestamp = timestamp
        self.message = message
        self.to = to
    }
    
    
    public var source: String = ""
    public var timestamp: String = "" // time in the XSD
    public var message: String = "" // text value of the node
    public var to: String = ""
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["source"] = source
        attrs["timestamp"] = timestamp
        attrs["to"] = to
        return COTXMLHelper.generateXML(nodeName: "remarks", attributes: attrs, message: message)
    }
    
    public static func == (lhs: COTRemarks, rhs: COTRemarks) -> Bool {
        return
            lhs.source == rhs.source &&
            lhs.timestamp == rhs.timestamp &&
            lhs.message == rhs.message &&
            lhs.to == rhs.to
    }
}

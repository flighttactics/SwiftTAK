//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode, Equatable {
    public init(source: String = "", timestamp: Date? = nil, message: String = "", to: String = "") {
        self.source = source
        self.timestamp = timestamp
        self.message = message
        self.to = to
    }
    
    public var source: String
    public var timestamp: Date? // time in the XSD
    public var message: String // text value of the node
    public var to: String
    
    public func toXml() -> String {
        let ts = timestamp == nil ? "" : ISO8601DateFormatter().string(from: timestamp!)
        var attrs: [String:String] = [:]
        attrs["source"] = source
        attrs["timestamp"] = ts
        attrs["to"] = to
        return COTXMLHelper.generateXML(nodeName: "remarks", attributes: attrs, message: message)
    }
    
    public static func == (lhs: COTRemarks, rhs: COTRemarks) -> Bool {
        TAKLogger.debug("***LHS vs RHS")
        TAKLogger.debug(String(describing: lhs.timestamp))
        TAKLogger.debug(String(describing: rhs.timestamp))
        TAKLogger.debug("Are they the same? \(lhs.timestamp == rhs.timestamp)")
        return
            lhs.source == rhs.source &&
            lhs.timestamp == rhs.timestamp &&
            lhs.message == rhs.message &&
            lhs.to == rhs.to
    }
}

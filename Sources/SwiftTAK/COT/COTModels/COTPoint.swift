//
//  COTPoint.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTPoint : COTNode, Equatable {
    public init(lat: String, lon: String, hae: String, ce: String, le: String) {
        self.lat = lat
        self.lon = lon
        self.hae = hae
        self.ce = ce
        self.le = le
    }
    
    public static let DEFAULT_ERROR_VALUE = 9999999.0
    
    public var lat:String
    public var lon:String
    public var hae:String
    public var ce:String
    public var le:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["lat"] = lat
        attrs["lon"] = lon
        attrs["hae"] = hae
        attrs["ce"] = ce
        attrs["le"] = le
        return COTXMLHelper.generateXML(nodeName: "point", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTPoint, rhs: COTPoint) -> Bool {
        return
            lhs.lat == rhs.lat &&
            lhs.lon == rhs.lon &&
            lhs.hae == rhs.hae &&
            lhs.ce == rhs.ce &&
            lhs.le == rhs.le
    }
}

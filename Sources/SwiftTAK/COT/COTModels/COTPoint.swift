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
        return true
    }
}

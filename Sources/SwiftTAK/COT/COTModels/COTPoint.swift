//
//  COTPoint.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTPoint : COTNode {
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
        return "<point " +
        "lat='\(lat)' " +
        "lon='\(lon)' " +
        "hae='\(hae)' " +
        "ce='\(ce)' " +
        "le='\(le)'" +
        "></point>"
    }
}

//
//  COTPoint.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTPoint : COTNode {
    var lat:String
    var lon:String
    var hae:String
    var ce:String
    var le:String
    
    func toXml() -> String {
        return "<point " +
        "lat='\(lat)' " +
        "lon='\(lon)' " +
        "hae='\(hae)' " +
        "ce='\(ce)' " +
        "le='\(le)'" +
        "></point>"
    }
}

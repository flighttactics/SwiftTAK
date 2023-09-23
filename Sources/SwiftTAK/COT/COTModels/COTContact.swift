//
//  COTContact.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTContact : COTNode {
    public var endpoint:String = "*:-1:stcp"
    public var phone:String = ""
    public var callsign:String
    
    public func toXml() -> String {
        return "<contact " +
        "endpoint='\(endpoint)' " +
        "phone='\(phone)' " +
        "callsign='\(callsign)'" +
        "></contact>"
    }
}

//
//  COTContact.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTContact : COTNode, Equatable {
    
    public static let DEFAULT_ENDPOINT: String = "*:-1:stcp"
    
    public init(endpoint: String = COTContact.DEFAULT_ENDPOINT, phone: String = "", callsign: String) {
        self.endpoint = endpoint
        self.phone = phone
        self.callsign = callsign
    }
    
    public var endpoint:String = COTContact.DEFAULT_ENDPOINT
    public var phone:String = ""
    public var callsign:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["endpoint"] = endpoint
        attrs["phone"] = phone
        attrs["callsign"] = callsign
        return COTXMLHelper.generateXML(nodeName: "contact", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTContact, rhs: COTContact) -> Bool {
        return
            lhs.endpoint == rhs.endpoint &&
            lhs.phone == rhs.phone &&
            lhs.callsign == rhs.callsign
    }
}

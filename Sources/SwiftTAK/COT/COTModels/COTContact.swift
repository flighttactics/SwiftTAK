//
//  COTContact.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTContact : COTNode {
    public init(endpoint: String = "*:-1:stcp", phone: String = "", callsign: String) {
        self.endpoint = endpoint
        self.phone = phone
        self.callsign = callsign
    }
    
    public var endpoint:String = "*:-1:stcp"
    public var phone:String = ""
    public var callsign:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["endpoint"] = endpoint
        attrs["phone"] = phone
        attrs["callsign"] = callsign
        return COTXMLHelper.generateXML(nodeName: "contact", attributes: attrs, message: "")
    }
}

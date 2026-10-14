//
//  COTContact.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTContact : COTNode, Equatable {
    
    public static let DEFAULT_ENDPOINT: String = "*:-1:stcp"
    
    /// `endpoint` is only for live contacts / SA. Markers and shapes should omit it
    /// (pass `""` or leave the default) so it is not serialized.
    public init(endpoint: String = "", phone: String = "", callsign: String) {
        self.endpoint = endpoint
        self.phone = phone
        self.callsign = callsign
    }
    
    public var endpoint:String = ""
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

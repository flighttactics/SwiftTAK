//
//  COTChatGroup.swift
//  
//
//  Created by Cory Foy on 10/15/23.
//

import Foundation

public struct COTChatGroup : COTNode {
    var id: String = ""
    var uid0: String = ""
    var uid1: String = ""
    
    public init(id: String, uid0: String, uid1: String) {
        self.id = id
        self.uid0 = uid0
        self.uid1 = uid1
    }

    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["uid0"] = uid0
        attrs["uid1"] = uid1
        
        return COTXMLHelper.generateXML(
            nodeName: "chatgrp",
            attributes: attrs,
            message: "")
    }
}

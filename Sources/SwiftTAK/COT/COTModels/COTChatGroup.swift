//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import Foundation

public struct COTChatGroup : COTNode, Equatable {
    
    public static let DEFAULT_CHATROOM = "All Chat Rooms"
    
    public init(uid0: String, uid1: String = COTChatGroup.DEFAULT_CHATROOM, id: String = COTChatGroup.DEFAULT_CHATROOM) {
        self.uid0 = uid0
        self.uid1 = uid1
        self.id = id
    }
    
    public var id:String
    public var uid0:String
    public var uid1:String
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["uid0"] = uid0
        attrs["uid1"] = uid1
        return COTXMLHelper.generateXML(nodeName: "chatgrp", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTChatGroup, rhs: COTChatGroup) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.uid0 == rhs.uid0 &&
            lhs.uid1 == rhs.uid1
    }
}

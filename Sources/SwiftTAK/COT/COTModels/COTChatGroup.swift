//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import Foundation

public struct COTChatGroup : COTNode, Equatable {
    
    public static let DEFAULT_CHATROOM = "All Chat Rooms"
    
    public init(uid0: String, uid1: String = COTChatGroup.DEFAULT_CHATROOM, id: String = COTChatGroup.DEFAULT_CHATROOM, extraUids: [String] = []) {
        self.uid0 = uid0
        self.uid1 = uid1
        self.id = id
        self.extraUids = extraUids
    }

    public init(memberUids: [String], id: String = COTChatGroup.DEFAULT_CHATROOM) {
        self.uid0 = memberUids.first ?? ""
        self.uid1 = memberUids.count > 1 ? memberUids[1] : COTChatGroup.DEFAULT_CHATROOM
        self.id = id
        self.extraUids = Array(memberUids.dropFirst(2))
    }
    
    public var id:String
    public var uid0:String
    public var uid1:String
    public var extraUids: [String] = []

    public var memberUids: [String] {
        [uid0, uid1] + extraUids
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["uid0"] = uid0
        attrs["uid1"] = uid1
        for (offset, uid) in extraUids.enumerated() {
            attrs["uid\(offset + 2)"] = uid
        }
        return COTXMLHelper.generateXML(nodeName: "chatgrp", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTChatGroup, rhs: COTChatGroup) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.uid0 == rhs.uid0 &&
            lhs.uid1 == rhs.uid1 &&
            lhs.extraUids == rhs.extraUids
    }
}

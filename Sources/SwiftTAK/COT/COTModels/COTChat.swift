//
//  COTChat.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTChat : COTNode, Equatable {
    
    public static let DEFAULT_CHATROOM = "All Chat Rooms"
    
    public init(id: String = COTChat.DEFAULT_CHATROOM, chatroom: String = COTChat.DEFAULT_CHATROOM, groupOwner: String = "", parent: String = "", senderCallsign: String = "", messageID: String = UUID().uuidString, chatGroup: COTChatGroup? = nil) {
        self.id = id
        self.chatroom = chatroom
        self.groupOwner = groupOwner
        self.parent = parent
        self.senderCallsign = senderCallsign
        self.messageID = messageID
        self.cotChatGroup = chatGroup
    }
    
    public var id: String
    public var chatroom: String
    public var groupOwner: String
    public var parent: String
    public var senderCallsign: String
    public var messageID: String
    public var cotChatGroup: COTChatGroup?
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["chatroom"] = chatroom
        attrs["groupOwner"] = groupOwner
        attrs["parent"] = parent
        attrs["senderCallsign"] = senderCallsign
        attrs["messageID"] = messageID
        return COTXMLHelper.generateXML(nodeName: "__chat", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTChat, rhs: COTChat) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.chatroom == rhs.chatroom &&
            lhs.groupOwner == rhs.groupOwner &&
            lhs.parent == rhs.parent &&
            lhs.senderCallsign == rhs.senderCallsign &&
            lhs.messageID == rhs.messageID
    }
}

//
//  COTChat.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTChat : COTNode, Equatable {
    
    public static let DEFAULT_CHATROOM = "All Chat Rooms"
    
    public init(id: String = COTChat.DEFAULT_CHATROOM, chatroom: String = COTChat.DEFAULT_CHATROOM, groupOwner: String = "", parent: String = "", senderCallsign: String = "", messageID: String = UUID().uuidString, chatGroup: COTChatGroup? = nil, hierarchy: COTChatHierarchy? = nil, deleteChildren: [COTDeleteChild] = []) {
        self.id = id
        self.chatroom = chatroom
        self.groupOwner = groupOwner
        self.parent = parent
        self.senderCallsign = senderCallsign
        self.messageID = messageID
        self.cotChatGroup = chatGroup
        self.hierarchy = hierarchy
        self.deleteChildren = deleteChildren
    }
    
    public var id: String
    public var chatroom: String
    public var groupOwner: String
    public var parent: String
    public var senderCallsign: String
    public var messageID: String
    public var cotChatGroup: COTChatGroup?
    public var hierarchy: COTChatHierarchy?
    public var deleteChildren: [COTDeleteChild] = []
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["chatroom"] = chatroom
        attrs["groupOwner"] = groupOwner
        attrs["parent"] = parent
        attrs["senderCallsign"] = senderCallsign
        attrs["messageId"] = messageID
        var children: [COTNode] = []
        if let chatGroup = cotChatGroup {
            children.append(chatGroup)
        }
        if let hierarchy {
            children.append(hierarchy)
        }
        children.append(contentsOf: deleteChildren)
        if children.isEmpty {
            return COTXMLHelper.generateXML(nodeName: "__chat", attributes: attrs, message: "")
        }
        return COTXMLHelper.generateXML(
            nodeName: "__chat",
            attributes: attrs,
            childNodes: children
        )
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

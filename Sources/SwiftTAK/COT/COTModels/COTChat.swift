//
//  COTChat.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTChat : COTNode {
    public init(id: String = "All Chat Rooms", chatroom: String = "All Chat Rooms", groupOwner: String = "", parent: String = "", senderCallsign: String = "", messageID: String = UUID().uuidString) {
        self.id = id
        self.chatroom = chatroom
        self.groupOwner = groupOwner
        self.parent = parent
        self.senderCallsign = senderCallsign
        self.messageID = messageID
    }
    
    public var id:String = "All Chat Rooms"
    public var chatroom:String = "All Chat Rooms"
    public var groupOwner:String = ""
    public var parent:String = ""
    public var senderCallsign:String = ""
    public var messageID:String = UUID().uuidString
    public var childNodes: [COTNode] = []
    
    public var chatGroup: COTChatGroup? {
        get { return childNodes.first(where: { $0 as? COTChatGroup != nil }) as? COTChatGroup }
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["id"] = id
        attrs["chatroom"] = chatroom
        attrs["groupOwner"] = groupOwner
        attrs["parent"] = parent
        attrs["senderCallsign"] = senderCallsign
        attrs["messageID"] = messageID
        return COTXMLHelper.generateXML(nodeName: "__chat", attributes: attrs, childNodes: childNodes)
    }
}

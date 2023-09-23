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
    
    public func makeAttribute(attrName: String, attrVal: String) -> String {
        if(attrVal.isEmpty) { return "" }
        return "\(attrName)='\(attrVal)' "
    }
    
    public func toXml() -> String {
        return "<__chat " +
        makeAttribute(attrName: "id", attrVal: id) +
        makeAttribute(attrName: "chatroom", attrVal: chatroom) +
        makeAttribute(attrName: "groupOwner", attrVal: groupOwner) +
        makeAttribute(attrName: "parent", attrVal: parent) +
        makeAttribute(attrName: "senderCallsign", attrVal: senderCallsign) +
        makeAttribute(attrName: "messageID", attrVal: messageID) +
        ">" +
        "</__chat>"
    }
}

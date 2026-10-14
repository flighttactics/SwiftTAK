//
//  COTChatHierarchy.swift
//  SwiftTAK
//

import Foundation

public struct COTChatHierarchyGroup: COTNode, Equatable {
    public var uid: String
    public var name: String
    public var children: [COTChatHierarchyGroup]

    public init(uid: String, name: String, children: [COTChatHierarchyGroup] = []) {
        self.uid = uid
        self.name = name
        self.children = children
    }

    public func toXml() -> String {
        COTXMLHelper.generateXML(
            nodeName: "group",
            attributes: ["uid": uid, "name": name],
            childNodes: children
        )
    }
}

public struct COTChatHierarchy: COTNode, Equatable {
    public var root: COTChatHierarchyGroup

    public init(root: COTChatHierarchyGroup) {
        self.root = root
    }

    public func toXml() -> String {
        COTXMLHelper.generateXML(
            nodeName: "hierarchy",
            attributes: [:],
            childNodes: [root]
        )
    }

    public static func userGroup(id: String, name: String) -> COTChatHierarchy {
        COTChatHierarchy(
            root: COTChatHierarchyGroup(
                uid: TAKConstants.ROOT_CONTACT_GROUP,
                name: "Contacts",
                children: [
                    COTChatHierarchyGroup(
                        uid: TAKConstants.USER_GROUPS_PARENT,
                        name: "Groups",
                        children: [
                            COTChatHierarchyGroup(uid: id, name: name)
                        ]
                    )
                ]
            )
        )
    }
}

public struct COTDeleteChild: COTNode, Equatable {
    public var uid: String
    public var chatroom: String
    public var id: String

    public init(uid: String, chatroom: String = "", id: String = "") {
        self.uid = uid
        self.chatroom = chatroom
        self.id = id
    }

    public func toXml() -> String {
        var attrs: [String: String] = ["uid": uid]
        if !chatroom.isEmpty { attrs["chatroom"] = chatroom }
        if !id.isEmpty { attrs["id"] = id }
        return COTXMLHelper.generateXML(nodeName: "deleteChild", attributes: attrs, message: "")
    }
}

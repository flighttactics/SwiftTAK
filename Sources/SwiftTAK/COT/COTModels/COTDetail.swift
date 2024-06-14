//
//  COTDetail.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTDetail : COTNode, Equatable {
    public init(childNodes: [COTNode] = []) {
        self.childNodes = childNodes
    }
    
    public var childNodes:[COTNode] = []
    
    public var cotContact: COTContact? {
        return childNodes.first(where: { $0 is COTContact }) as? COTContact
    }
    public var cotRemarks: COTRemarks? {
        return childNodes.first(where: { $0 is COTRemarks }) as? COTRemarks
    }
    public var cotUid: COTUid? {
        return childNodes.first(where: { $0 is COTUid }) as? COTUid
    }
    public var cotChat: COTChat? {
        return childNodes.first(where: { $0 is COTChat }) as? COTChat
    }
    public var cotLink: COTLink? {
        return childNodes.first(where: { $0 is COTLink }) as? COTLink
    }
    public var cotServerDestination: COTServerDestination? {
        return childNodes.first(where: { $0 is COTServerDestination }) as? COTServerDestination
    }

    public func toXml() -> String {
        return COTXMLHelper.generateXML(
            nodeName: "detail",
            attributes: [:],
            childNodes: childNodes)
    }
    
    public static func == (lhs: COTDetail, rhs: COTDetail) -> Bool {
        return
            lhs.childNodes.count == rhs.childNodes.count
    }
}

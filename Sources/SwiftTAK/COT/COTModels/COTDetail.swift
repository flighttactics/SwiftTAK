//
//  COTDetail.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTDetail : COTNode {
    public init(childNodes: [COTNode] = []) {
        self.childNodes = childNodes
    }
    
    public var childNodes:[COTNode] = []
    
    public var chat: COTChat? {
        get { return childNodes.first(where: { $0 as? COTChat != nil }) as? COTChat }
    }
    
    public var link: COTLink? {
        get { return childNodes.first(where: { $0 as? COTLink != nil }) as? COTLink }
    }
    
    public var serverDestination: COTServerDestination? {
        get { return childNodes.first(where: { $0 as? COTServerDestination != nil }) as? COTServerDestination }
    }
    
    public var remarks: COTRemarks? {
        get { return childNodes.first(where: { $0 as? COTRemarks != nil }) as? COTRemarks }
    }

    public func toXml() -> String {
        return COTXMLHelper.generateXML(
            nodeName: "detail",
            attributes: [:],
            childNodes: childNodes)
    }
}

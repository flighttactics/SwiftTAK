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

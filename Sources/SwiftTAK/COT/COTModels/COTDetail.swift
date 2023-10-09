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

    public func toXml() -> String {
        return COTXMLHelper.generateXML(
            nodeName: "detail",
            attributes: [:],
            childNodes: childNodes)
    }
}

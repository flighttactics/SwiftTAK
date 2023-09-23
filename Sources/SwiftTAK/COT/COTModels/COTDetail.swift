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
        return "<detail>" +
        childNodes.map { $0.toXml() }.joined() +
        "</detail>"
    }
}

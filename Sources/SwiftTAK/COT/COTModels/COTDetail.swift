//
//  COTDetail.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTDetail : COTNode {
    public var childNodes:[COTNode] = []
    
    public func toXml() -> String {
        return "<detail>" +
        childNodes.map { $0.toXml() }.joined() +
        "</detail>"
    }
}

//
//  COTDetail.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTDetail : COTNode {
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
        return "<detail>" +
        childNodes.map { $0.toXml() }.joined() +
        "</detail>"
    }
}

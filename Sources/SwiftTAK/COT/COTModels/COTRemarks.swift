//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode {
    
    public var source: String = ""
    public var timestamp: String = ""
    public var message: String = ""
    
    public func toXml() -> String {
        let sourceAttr = source.isEmpty ? "" : "source='\(source)' "
        let timestampAttr = timestamp.isEmpty ? "" : "timestamp='\(timestamp)' "
        return "<remarks " +
        sourceAttr +
        timestampAttr + 
        ">" +
        message +
        "</remarks>"
    }
}

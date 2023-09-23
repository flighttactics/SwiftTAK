//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode {
    
    var source: String = ""
    var timestamp: String = ""
    var message: String = ""
    
    func toXml() -> String {
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

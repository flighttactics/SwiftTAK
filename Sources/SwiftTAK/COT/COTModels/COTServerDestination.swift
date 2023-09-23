//
//  COTServerDestination.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTServerDestination : COTNode {
    
    public var destinations: String = ""
    
    public func toXml() -> String {
        return "<__serverdestination " +
        "destinations='\(destinations)'" + 
        ">" +
        "</__serverdestination>"
    }
}

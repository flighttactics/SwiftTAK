//
//  COTStatus.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTStatus : COTNode {
    public var battery:String
    
    public func toXml() -> String {
        return "<status " +
        "battery='\(battery)'" +
        "></status>"
    }
}

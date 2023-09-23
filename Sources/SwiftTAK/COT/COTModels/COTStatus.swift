//
//  COTStatus.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTStatus : COTNode {
    var battery:String
    
    func toXml() -> String {
        return "<status " +
        "battery='\(battery)'" +
        "></status>"
    }
}

//
//  COTUid.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTUid : COTNode {
    var callsign:String
    
    func toXml() -> String {
        return "<uid " +
        "Droid='\(callsign)'" +
        "></uid>"
    }
}

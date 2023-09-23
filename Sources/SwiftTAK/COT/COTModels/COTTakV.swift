//
//  COTTakV.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTTakV : COTNode {
    var device:String
    var platform:String
    var os:String
    var version:String
    
    func toXml() -> String {
        return "<takv " +
        "device='\(device)' " +
        "platform='\(platform)' " +
        "os='\(os)' " +
        "version='\(version)'" +
        "></takv>"
    }
}

//
//  COTTakV.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTTakV : COTNode {
    public var device:String
    public var platform:String
    public var os:String
    public var version:String
    
    public func toXml() -> String {
        return "<takv " +
        "device='\(device)' " +
        "platform='\(platform)' " +
        "os='\(os)' " +
        "version='\(version)'" +
        "></takv>"
    }
}

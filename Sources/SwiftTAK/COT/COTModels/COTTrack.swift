//
//  COTTrack.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTTrack : COTNode {
    public var speed:String
    public var course:String
    
    public func toXml() -> String {
        return "<track " +
        "speed='\(speed)' " +
        "course='\(course)'" +
        "></track>"
    }
}

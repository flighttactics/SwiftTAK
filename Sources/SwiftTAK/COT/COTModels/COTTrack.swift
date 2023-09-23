//
//  COTTrack.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTTrack : COTNode {
    var speed:String
    var course:String
    
    func toXml() -> String {
        return "<track " +
        "speed='\(speed)' " +
        "course='\(course)'" +
        "></track>"
    }
}

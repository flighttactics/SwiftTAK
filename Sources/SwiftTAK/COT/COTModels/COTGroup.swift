//
//  COTGroup.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTGroup : COTNode {
    var name:String
    var role:String
    
    func toXml() -> String {
        return "<__group " +
        "name='\(name)' " +
        "role='\(role)'" +
        "></__group>"
    }
}

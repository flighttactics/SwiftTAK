//
//  COTGroup.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTGroup : COTNode {
    public init(name: String, role: String) {
        self.name = name
        self.role = role
    }
    
    public var name:String
    public var role:String
    
    public func toXml() -> String {
        return "<__group " +
        "name='\(name)' " +
        "role='\(role)'" +
        "></__group>"
    }
}

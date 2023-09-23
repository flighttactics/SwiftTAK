//
//  COTRemarks.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTRemarks : COTNode {
    
    func toXml() -> String {
        return "<remarks></remarks>"
    }
}

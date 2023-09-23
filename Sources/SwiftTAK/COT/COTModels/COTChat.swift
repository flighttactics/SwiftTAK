//
//  COTChat.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTChat : COTNode {
    var id:String = "All Chat Rooms"
    var chatroom:String = "All Chat Rooms"
    var messageID:String = UUID().uuidString
    
    func toXml() -> String {
        return "<__chat " +
        "id='\(id)' " +
        "chatroom='\(chatroom)'>" +
        "<chatgrp id='\(chatroom)' uid0='\(messageID)' uid1='\(id)'/>" +
        "</__chat>"
    }
}

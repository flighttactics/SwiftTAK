//
//  COTVideo.swift
//  
//
//  Created by Cory Foy on 10/9/23.
//

import Foundation

public struct COTVideo : COTNode, Equatable {
    public var baseUrl: String
    public var uid: String = ""
    public var connectionEntry: COTConnectionEntry? = nil
    public var url: String {
        if connectionEntry != nil {
            return connectionEntry!.url
        }
        return baseUrl
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["url"] = baseUrl
        attrs["uid"] = uid
        
        return COTXMLHelper.generateXML(nodeName: "__video", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTVideo, rhs: COTVideo) -> Bool {
        let entryExistanceSame = (lhs.connectionEntry == nil && lhs.connectionEntry == nil) || (lhs.connectionEntry != nil && rhs.connectionEntry != nil)

        var connectionEntrySame = entryExistanceSame
        
        if(entryExistanceSame && lhs.connectionEntry != nil) {
            connectionEntrySame = (lhs.connectionEntry == rhs.connectionEntry)
        }

        return lhs.baseUrl == rhs.baseUrl &&
            lhs.uid == rhs.uid &&
            connectionEntrySame
    }
}

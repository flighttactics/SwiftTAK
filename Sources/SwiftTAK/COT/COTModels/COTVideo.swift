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
    public var active: Bool? = nil
    public var alias: String? = nil
    public var classification: String? = nil
    public var thumbnail: String? = nil
    
    public var connectionEntry: COTConnectionEntry? = nil
    public var url: String {
        if !baseUrl.isEmpty {
            return baseUrl
        } else if let connectionEntry = connectionEntry {
            return connectionEntry.url
        } else {
            return ""
        }
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["url"] = baseUrl
        attrs["uid"] = uid
        if let active = active { attrs["active"] = active.description }
        if let alias = alias { attrs["alias"] = alias }
        if let classification = classification { attrs["classification"] = classification }
        if let thumbnail = thumbnail { attrs["thumbnail"] = thumbnail }
        
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
            lhs.active == rhs.active &&
            lhs.alias == rhs.alias &&
            lhs.classification == rhs.classification &&
            lhs.thumbnail == rhs.thumbnail &&
            connectionEntrySame
    }
}

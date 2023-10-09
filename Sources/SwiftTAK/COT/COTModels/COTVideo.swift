//
//  File.swift
//  
//
//  Created by Cory Foy on 10/9/23.
//

import Foundation

public struct COTVideo : COTNode {
    public var url: String
    public var uid: String = ""
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["url"] = url
        attrs["uid"] = uid
        
        return COTXMLHelper.generateXML(nodeName: "__video", attributes: attrs, message: "")
    }
}

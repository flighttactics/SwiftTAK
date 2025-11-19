//
//  COTAttachmentList.swift
//  SwiftTAK
//
//  Created by Cory Foy on 9/25/25.
//

import Foundation

//<attachment_list hashes="[&quot;16cb0524cfc341315cb136ed3aaef1e02bcced291316715c6d964881077dd23e&quot;]"/>
public struct COTAttachmentList : COTNode, Equatable {
    public var hashes: String = ""
    
    public init(hashes: String) {
        self.hashes = hashes
    }
    
    public var attachmentHashes: [String] {
        hashes.components(separatedBy: ",")
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["hashes"] = hashes.description
        return COTXMLHelper.generateXML(nodeName: "attachment_list", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTAttachmentList, rhs: COTAttachmentList) -> Bool {
        return lhs.hashes == rhs.hashes
    }
}

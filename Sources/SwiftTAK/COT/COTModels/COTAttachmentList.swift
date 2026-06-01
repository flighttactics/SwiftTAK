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
        self.hashes = cleanHashesList(hashes)
    }

    private func cleanHashesList(_ incomingHashes: String) -> String {
        var cleanedHashesList = incomingHashes
        cleanedHashesList = cleanedHashesList.replacingOccurrences(of: "[", with: "")
        cleanedHashesList = cleanedHashesList.replacingOccurrences(of: "]", with: "")
        cleanedHashesList = cleanedHashesList.replacingOccurrences(of: "\"", with: "")
        cleanedHashesList = cleanedHashesList.replacingOccurrences(of: "&quot;", with: "")
        return cleanedHashesList
    }

    public var attachmentHashes: [String] {
        hashes.components(separatedBy: ",")
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        // Note: This is how TAK server actually expects it to come across
        attrs["hashes"] = "[&quot;\(hashes)&quot;]"
        return COTXMLHelper.generateXML(nodeName: "attachment_list", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTAttachmentList, rhs: COTAttachmentList) -> Bool {
        return lhs.hashes == rhs.hashes
    }
}

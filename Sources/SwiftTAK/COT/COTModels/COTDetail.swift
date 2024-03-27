//
//  COTDetail.swift
//  
//
//  Created by Cory Foy on 9/22/23.
//

import Foundation

public struct COTDetail : COTNode, Equatable {
    public init(childNodes: [COTNode] = []) {
        self.childNodes = childNodes
    }
    
    public var childNodes:[COTNode] = []
    public var cotContact: COTContact? {
        var contact: COTContact?
        childNodes.forEach {
           if($0 is COTContact) {
               contact = $0 as? COTContact
            }
        }
        return contact
    }
    
    public var cotRemarks: COTRemarks? {
        var remarks: COTRemarks?
        childNodes.forEach {
           if($0 is COTRemarks) {
               remarks = $0 as? COTRemarks
            }
        }
        return remarks
    }
    
    public var cotUid: COTUid? {
        var uid: COTUid?
        childNodes.forEach {
           if($0 is COTUid) {
               uid = $0 as? COTUid
            }
        }
        return uid
    }

    public func toXml() -> String {
        return COTXMLHelper.generateXML(
            nodeName: "detail",
            attributes: [:],
            childNodes: childNodes)
    }
    
    public static func == (lhs: COTDetail, rhs: COTDetail) -> Bool {
        return
            lhs.childNodes.count == rhs.childNodes.count
    }
}

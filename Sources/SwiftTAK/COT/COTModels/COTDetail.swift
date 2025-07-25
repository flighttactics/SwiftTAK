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

    public var cotLinks: [COTLink]? {
        return childNodes.filter { $0 is COTLink } as? [COTLink]
    }
    
    public var cotContact: COTContact? {
        return childNodes.first(where: { $0 is COTContact }) as? COTContact
    }
    public var cotRemarks: COTRemarks? {
        return childNodes.first(where: { $0 is COTRemarks }) as? COTRemarks
    }
    public var cotUid: COTUid? {
        return childNodes.first(where: { $0 is COTUid }) as? COTUid
    }
    public var cotChat: COTChat? {
        return childNodes.first(where: { $0 is COTChat }) as? COTChat
    }
    public var cotServerDestination: COTServerDestination? {
        return childNodes.first(where: { $0 is COTServerDestination }) as? COTServerDestination
    }
    public var cotArchive: COTArchive? {
        return childNodes.first(where: { $0 is COTArchive }) as? COTArchive
    }
    public var cotUserIcon: COTUserIcon? {
        return childNodes.first(where: { $0 is COTUserIcon }) as? COTUserIcon
    }
    public var cotColor: COTColor? {
        return childNodes.first(where: { $0 is COTColor }) as? COTColor
    }
    public var cotVideo: COTVideo? {
        return childNodes.first(where: { $0 is COTVideo }) as? COTVideo
    }
    public var cotStrokeWeight: COTStrokeWeight? {
        return childNodes.first(where: { $0 is COTStrokeWeight }) as? COTStrokeWeight
    }
    public var cotStrokeColor: COTStrokeColor? {
        return childNodes.first(where: { $0 is COTStrokeColor }) as? COTStrokeColor
    }
    public var cotLabelsOn: COTLabelsOn? {
        return childNodes.first(where: { $0 is COTLabelsOn }) as? COTLabelsOn
    }
    public var cotFillColor: COTFillColor? {
        return childNodes.first(where: { $0 is COTFillColor }) as? COTFillColor
    }
    public var cotShape: COTShape? {
        return childNodes.first(where: { $0 is COTShape }) as? COTShape
    }
    public var cotGroup: COTGroup? {
        return childNodes.first(where: { $0 is COTGroup }) as? COTGroup
    }
    public var cotTrack: COTTrack? {
        return childNodes.first(where: { $0 is COTTrack }) as? COTTrack
    }
    public var cotStatus: COTStatus? {
        return childNodes.first(where: { $0 is COTStatus }) as? COTStatus
    }
    public var cotMarti: COTMarti? {
        return childNodes.first(where: { $0 is COTMarti }) as? COTMarti
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

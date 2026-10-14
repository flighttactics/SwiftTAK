//
//  COTAckResponse.swift
//  SwiftTAK
//

import Foundation

/// File-transfer acknowledgment payload for CoT type `b-f-t-a`.
public struct COTAckResponse: COTNode, Equatable {
    public var uid: String
    public var senderUid: String
    public var success: Bool
    public var tag: String
    public var reason: String
    public var sha256: String
    public var sizeInBytes: String

    public init(
        uid: String,
        senderUid: String,
        success: Bool,
        tag: String,
        reason: String = "",
        sha256: String,
        sizeInBytes: String
    ) {
        self.uid = uid
        self.senderUid = senderUid
        self.success = success
        self.tag = tag
        self.reason = reason
        self.sha256 = sha256
        self.sizeInBytes = sizeInBytes
    }

    public func toXml() -> String {
        var attrs: [String: String] = [:]
        attrs["uid"] = uid
        attrs["senderUid"] = senderUid
        attrs["success"] = success ? "true" : "false"
        attrs["tag"] = tag
        attrs["reason"] = reason
        attrs["sha256"] = sha256
        attrs["sizeInBytes"] = sizeInBytes
        return COTXMLHelper.generateXML(nodeName: "ackresponse", attributes: attrs, message: "")
    }

    public static func == (lhs: COTAckResponse, rhs: COTAckResponse) -> Bool {
        lhs.uid == rhs.uid
            && lhs.senderUid == rhs.senderUid
            && lhs.success == rhs.success
            && lhs.sha256 == rhs.sha256
    }
}

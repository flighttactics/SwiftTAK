//
//  COTAckRequest.swift
//  SwiftTAK
//

import Foundation

/// Request embedded in `b-f-t-r` asking the receiver to send a `b-f-t-a` ack.
public struct COTAckRequest: COTNode, Equatable {
    public var uid: String
    public var ackRequested: Bool
    public var tag: String

    public init(uid: String, ackRequested: Bool = true, tag: String) {
        self.uid = uid
        self.ackRequested = ackRequested
        self.tag = tag
    }

    public func toXml() -> String {
        var attrs: [String: String] = [:]
        attrs["uid"] = uid
        attrs["ackrequested"] = ackRequested ? "true" : "false"
        attrs["tag"] = tag
        return COTXMLHelper.generateXML(nodeName: "ackrequest", attributes: attrs, message: "")
    }

    public static func == (lhs: COTAckRequest, rhs: COTAckRequest) -> Bool {
        lhs.uid == rhs.uid && lhs.ackRequested == rhs.ackRequested && lhs.tag == rhs.tag
    }
}

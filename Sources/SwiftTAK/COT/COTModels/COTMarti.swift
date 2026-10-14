//
//  COTMarti.swift
//  SwiftTAK
//
//  Created by Cory Foy on 6/5/25.
//

public struct COTMartiDest: COTNode, Equatable {
    public var uid: String?
    public var callsign: String?
    public var mission: String?

    public init(uid: String? = nil, callsign: String? = nil, mission: String? = nil) {
        self.uid = uid
        self.callsign = callsign
        self.mission = mission
    }

    public func toXml() -> String {
        var attrs: [String: String] = [:]
        if let uid { attrs["uid"] = uid }
        if let callsign { attrs["callsign"] = callsign }
        if let mission { attrs["mission"] = mission }
        return COTXMLHelper.generateXML(nodeName: "dest", attributes: attrs, message: "")
    }
}

public struct COTMarti: COTNode, Equatable {
    public var destinations: [COTMartiDest]

    public var uid: String? { destinations.first?.uid }
    public var callsign: String? { destinations.first?.callsign }
    public var mission: String? { destinations.first?.mission }

    public init(uid: String) {
        self.destinations = [COTMartiDest(uid: uid)]
    }

    public init(callsign: String) {
        self.destinations = [COTMartiDest(callsign: callsign)]
    }

    public init(mission: String) {
        self.destinations = [COTMartiDest(mission: mission)]
    }

    public init(destinations: [COTMartiDest]) {
        self.destinations = destinations
    }

    public init(uids: [String]) {
        self.destinations = uids.map { COTMartiDest(uid: $0) }
    }

    public func toXml() -> String {
        COTXMLHelper.generateXML(nodeName: "marti", attributes: [:], childNodes: destinations)
    }

    public static func == (lhs: COTMarti, rhs: COTMarti) -> Bool {
        lhs.destinations == rhs.destinations
    }
}

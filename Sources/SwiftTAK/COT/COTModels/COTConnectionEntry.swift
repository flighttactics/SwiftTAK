//
//  File.swift
//  
//
//  Created by Cory Foy on 8/3/24.
//

import Foundation

/*
 <__video uid="30f3c0c5-11ec-455d-bf0b-d93f1ad14716" url="mtxprox.website.com:8554/live/cam/151-SE-4">
     <ConnectionEntry networkTimeout="12000" uid="30f3c0c5-11ec-455d-bf0b-d93f1ad14716"
         path="/live/cam/151-SE-4" protocol="rtsp" bufferTime="-1" address="mtxprox.website.com"
         port="8554" roverPort="-1" rtspReliable="0" ignoreEmbeddedKLV="false"
         alias="CAM-Y-Ext SE-NE" />
 </__video>
 */

public struct COTConnectionEntry : COTNode, Equatable {
    public var uid: String = ""
    public var alias: String
    public var connectionProtocol: String
    public var address: String
    public var port: Int
    public var path: String
    public var roverPort: Int
    public var rtspReliable: Int
    public var ignoreEmbeddedKLV: Bool
    public var networkTimeout: Int
    public var bufferTime: Int
    public var active: Bool = true
    public var bitrate: Int32? = nil
    public var classification: String? = nil
    public var fov: String? = nil
    public var heading: String? = nil
    public var height: Int32? = nil
    public var latitude: String? = nil
    public var longitude: String? = nil
    public var macAddress: String? = nil
    public var order: Int32? = nil
    public var range: String? = nil
    public var source: String? = nil
    public var thumbnail: String? = nil
    public var width: Int32? = nil
    /// SRT stream encryption passphrase (ATAK `ConnectionEntry.passphrase`).
    public var passphrase: String? = nil

    public init(
        uid: String = "",
        alias: String,
        connectionProtocol: String,
        address: String,
        port: Int,
        path: String,
        roverPort: Int,
        rtspReliable: Int,
        ignoreEmbeddedKLV: Bool,
        networkTimeout: Int,
        bufferTime: Int,
        active: Bool = true,
        bitrate: Int32? = nil,
        classification: String? = nil,
        fov: String? = nil,
        heading: String? = nil,
        height: Int32? = nil,
        latitude: String? = nil,
        longitude: String? = nil,
        macAddress: String? = nil,
        order: Int32? = nil,
        range: String? = nil,
        source: String? = nil,
        thumbnail: String? = nil,
        width: Int32? = nil,
        passphrase: String? = nil
    ) {
        self.uid = uid
        self.alias = alias
        self.connectionProtocol = connectionProtocol
        self.address = address
        self.port = port
        self.path = path
        self.roverPort = roverPort
        self.rtspReliable = rtspReliable
        self.ignoreEmbeddedKLV = ignoreEmbeddedKLV
        self.networkTimeout = networkTimeout
        self.bufferTime = bufferTime
        self.active = active
        self.bitrate = bitrate
        self.classification = classification
        self.fov = fov
        self.heading = heading
        self.height = height
        self.latitude = latitude
        self.longitude = longitude
        self.macAddress = macAddress
        self.order = order
        self.range = range
        self.source = source
        self.thumbnail = thumbnail
        self.width = width
        self.passphrase = passphrase
    }
    
    public var url: String {
        // Require a real scheme:// prefix. Credentialed hosts like
        // "user:pass@camera.example.com" parse as scheme "user" via URL(string:),
        // which previously returned the bare address and broke RTSP playback.
        if address.contains("://") {
            return address
        }
        return "\(connectionProtocol)://\(address):\(port)\(path)"
    }

    /// Hostname with any embedded `user:pass@` stripped (or host from an absolute address).
    public var host: String {
        if address.contains("://"),
           let url = URL(string: address),
           let host = url.host, !host.isEmpty {
            return host
        }
        if let at = address.lastIndex(of: "@") {
            return String(address[address.index(after: at)...])
        }
        return address
    }

    /// Credentials embedded in `address` as `user:pass@host` (ATAK sometimes does this).
    public var embeddedCredentials: (username: String, password: String?)? {
        if address.contains("://") {
            guard let url = URL(string: address) else { return nil }
            guard let user = url.user, !user.isEmpty else { return nil }
            return (user, url.password)
        }
        guard let at = address.lastIndex(of: "@") else { return nil }
        let credentials = String(address[..<at])
        guard !credentials.isEmpty else { return nil }
        if let colon = credentials.firstIndex(of: ":") {
            let username = String(credentials[..<colon])
            let password = String(credentials[credentials.index(after: colon)...])
            guard !username.isEmpty else { return nil }
            return (username, password)
        }
        return (credentials, nil)
    }

    /// Stream identity used to cross-check against `__video url`.
    var streamIdentity: COTVideo.StreamIdentity {
        COTVideo.StreamIdentity(
            host: host,
            port: port > 0 ? port : nil,
            path: path
        )
    }

    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["uid"] = uid
        attrs["alias"] = alias
        attrs["protocol"] = connectionProtocol
        attrs["address"] = address
        attrs["port"] = port.description
        attrs["path"] = path
        attrs["roverPort"] = roverPort.description
        attrs["rtspReliable"] = rtspReliable.description
        attrs["ignoreEmbeddedKLV"] = ignoreEmbeddedKLV.description
        attrs["networkTimeout"] = networkTimeout.description
        attrs["bufferTime"] = bufferTime.description
        attrs["active"] = active ? "true" : "false"
        if let passphrase, !passphrase.isEmpty {
            attrs["passphrase"] = passphrase
        }
        
        return COTXMLHelper.generateXML(nodeName: "ConnectionEntry", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTConnectionEntry, rhs: COTConnectionEntry) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.alias == rhs.alias &&
        lhs.connectionProtocol == rhs.connectionProtocol &&
        lhs.address == rhs.address &&
        lhs.port == rhs.port &&
        lhs.path == rhs.path &&
        lhs.roverPort == rhs.roverPort &&
        lhs.rtspReliable == rhs.rtspReliable &&
        lhs.ignoreEmbeddedKLV == rhs.ignoreEmbeddedKLV &&
        lhs.networkTimeout == rhs.networkTimeout &&
        lhs.bufferTime == rhs.bufferTime &&
        lhs.active == rhs.active &&
        lhs.passphrase == rhs.passphrase
    }
}


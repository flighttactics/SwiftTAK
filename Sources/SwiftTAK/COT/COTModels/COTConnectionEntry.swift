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
    
    public var url: String {
        return "\(connectionProtocol)://\(address):\(port)\(path)"
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
        lhs.bufferTime == rhs.bufferTime
    }
}


//
//  COTSensor.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/17/25.
//

import Foundation

public struct COTSensor : COTNode, Equatable {

    public init(
        azimuth: Double?,
        elevation: Double?,
        roll: Double?,
        fov: Double?,
        vfov: Double?,
        north: Double?,
        version: Double?,
        type: String?,
        model: String?,
        range: Double?,
    ) {
        self.azimuth = azimuth
        self.elevation = elevation
        self.roll = roll
        self.fov = fov
        self.vfov = vfov
        self.north = north
        self.version = version
        self.type = type
        self.model = model
        self.range = range
    }
    
    public var azimuth: Double?
    public var elevation: Double?
    public var roll: Double?
    public var fov: Double?
    public var vfov: Double?
    public var north: Double?
    public var version: Double?
    public var type: String?
    public var model: String?
    public var range: Double?
    
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        if let azimuth = azimuth { attrs["azimuth"] = azimuth.description }
        if let elevation = elevation { attrs["elevation"] = elevation.description }
        if let roll = roll { attrs["roll"] = roll.description }
        if let fov = fov { attrs["fov"] = fov.description }
        if let vfov = vfov { attrs["vfov"] = vfov.description }
        if let north = north { attrs["north"] = north.description }
        if let version = version { attrs["version"] = version.description }
        if let type = type { attrs["type"] = type }
        if let model = model { attrs["model"] = model }
        if let range = range { attrs["range"] = range.description }
        return COTXMLHelper.generateXML(nodeName: "sensor", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTSensor, rhs: COTSensor) -> Bool {
        return lhs.azimuth == rhs.azimuth &&
        lhs.elevation == rhs.elevation &&
        lhs.roll == rhs.roll &&
        lhs.fov == rhs.fov &&
        lhs.vfov == rhs.vfov &&
        lhs.north == rhs.north &&
        lhs.version == rhs.version &&
        lhs.type == rhs.type &&
        lhs.model == rhs.model &&
        lhs.range == rhs.range
    }
}

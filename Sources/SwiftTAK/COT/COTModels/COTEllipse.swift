//
//  COTEllipse.swift
//  SwiftTAK
//
//  Created by Cory Foy on 12/19/24.
//

import Foundation

public struct COTEllipse : COTNode, Equatable {
    public var major: Double = 0.0
    public var minor: Double = 0.0
    public var angle: Double = 0.0
    
    public init(major: Double, minor: Double, angle: Double) {
        self.major = major
        self.minor = minor
        self.angle = angle
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["major"] = major.description
        attrs["minor"] = minor.description
        attrs["angle"] = angle.description
        return COTXMLHelper.generateXML(nodeName: "ellipse", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTEllipse, rhs: COTEllipse) -> Bool {
        return lhs.major == rhs.major &&
                lhs.minor == rhs.minor &&
                lhs.angle == rhs.angle
    }
}

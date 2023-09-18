//
//  Models.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

protocol COTNode {
    func toXml() -> String
}

public struct COTEvent : COTNode {
    var version:String
    var uid:String
    var type:String
    var how:String
    var time:Date
    var start:Date
    var stale:Date
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
        return "<event " +
        "version='\(version)' " +
        "uid='\(uid)' " +
        "type='\(type)' " +
        "how='\(how)' " +
        "time='\(ISO8601DateFormatter().string(from: time))' " +
        "start='\(ISO8601DateFormatter().string(from: start))' " +
        "stale='\(ISO8601DateFormatter().string(from: stale))'" +
        ">" +
        childNodes.map { $0.toXml() }.joined() +
        "</event>"
    }
}

public struct COTPoint : COTNode {
    var lat:String
    var lon:String
    var hae:String
    var ce:String
    var le:String
    
    func toXml() -> String {
        return "<point " +
        "lat='\(lat)' " +
        "lon='\(lon)' " +
        "hae='\(hae)' " +
        "ce='\(ce)' " +
        "le='\(le)'" +
        "></point>"
    }
}

public struct COTDetail : COTNode {
    var childNodes:[COTNode] = []
    
    func toXml() -> String {
        return "<detail>" +
        childNodes.map { $0.toXml() }.joined() +
        "</detail>"
    }
}

public struct COTRemarks : COTNode {
    
    func toXml() -> String {
        return "<remarks></remarks>"
    }
}

public struct COTGroup : COTNode {
    var name:String
    var role:String
    
    func toXml() -> String {
        return "<__group " +
        "name='\(name)' " +
        "role='\(role)'" +
        "></__group>"
    }
}

public struct COTStatus : COTNode {
    var battery:String
    
    func toXml() -> String {
        return "<status " +
        "battery='\(battery)'" +
        "></status>"
    }
}

public struct COTTakV : COTNode {
    var device:String
    var platform:String
    var os:String
    var version:String
    
    func toXml() -> String {
        return "<takv " +
        "device='\(device)' " +
        "platform='\(platform)' " +
        "os='\(os)' " +
        "version='\(version)'" +
        "></takv>"
    }
}

public struct COTTrack : COTNode {
    var speed:String
    var course:String
    
    func toXml() -> String {
        return "<track " +
        "speed='\(speed)' " +
        "course='\(course)'" +
        "></track>"
    }
}

public struct COTContact : COTNode {
    var endpoint:String = "*:-1:stcp"
    var phone:String = ""
    var callsign:String
    
    func toXml() -> String {
        return "<contact " +
        "endpoint='\(endpoint)' " +
        "phone='\(phone)' " +
        "callsign='\(callsign)'" +
        "></contact>"
    }
}

public struct COTUid : COTNode {
    var callsign:String
    
    func toXml() -> String {
        return "<uid " +
        "Droid='\(callsign)'" +
        "></uid>"
    }
}

public class COTMessage: NSObject {
    
    static public let DEFAULT_COT_TYPE = "a-f-G-U-C"
    static public let DEFAULT_HOW = "m-g"
    static public let DEFAULT_ERROR_NUMBER = "999999.0"
    public let COT_EVENT_VERSION = "2.0"
    
    var staleTimeMinutes : Double
    var deviceID : String
    var phoneModel : String
    var appPlatform : String
    var phoneOS : String
    var appVersion : String
    
    public init(staleTimeMinutes: Double = 5.0,
         deviceID: String = UUID().uuidString,
                  phoneModel: String = "iPhone",
                  phoneOS: String = "iOS",
                  appPlatform: String = "SwiftTAK",
                  appVersion: String = "0.1") {
        self.staleTimeMinutes = staleTimeMinutes
        self.deviceID = deviceID
        self.phoneModel = phoneModel
        self.phoneOS = phoneOS
        self.appPlatform = appPlatform
        self.appVersion = appVersion
        super.init()
    }
    
    public func generateCOTXml(cotType: String = DEFAULT_COT_TYPE,
                               cotHow: String = DEFAULT_HOW,
                               heightAboveElipsoid: String = DEFAULT_ERROR_NUMBER,
                               circularError: String = DEFAULT_ERROR_NUMBER,
                               linearError: String = DEFAULT_ERROR_NUMBER,
                               latitude: String,
                               longitude: String,
                               callSign: String,
                               group: String,
                               role: String,
                               phoneBatteryStatus: String = "") -> String {
        let cotTimeout = staleTimeMinutes * 60.0
        let deviceID = deviceID
        
        var cotEvent = COTEvent(version: COT_EVENT_VERSION, uid: deviceID, type: cotType, how: cotHow, time: Date(), start: Date(), stale: Date().addingTimeInterval(cotTimeout))
        
        let cotPoint = COTPoint(lat: latitude, lon: longitude, hae: heightAboveElipsoid, ce: circularError, le: linearError)
        
        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTContact(callsign: callSign))
        cotDetail.childNodes.append(COTRemarks())
        cotDetail.childNodes.append(COTGroup(name: group, role: role))
        cotDetail.childNodes.append(COTUid(callsign: callSign))
        cotDetail.childNodes.append(COTTakV(device: phoneModel,
                                            platform: appPlatform,
                                            os: phoneOS,
                                            version: appVersion))
        if(!phoneBatteryStatus.isEmpty) {
            cotDetail.childNodes.append(COTStatus(battery: phoneBatteryStatus))
        }
        
        cotEvent.childNodes.append(cotPoint)
        cotEvent.childNodes.append(cotDetail)
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" + cotEvent.toXml()
    }
}

//
//  Models.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

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
    
    public func generateEmergencyCOTXml(cotType: String = DEFAULT_COT_TYPE, heightAboveElipsoid: String = DEFAULT_ERROR_NUMBER,
                                circularError: String = DEFAULT_ERROR_NUMBER,
                                linearError: String = DEFAULT_ERROR_NUMBER,
                                latitude: String,
                                longitude: String,
                                callSign: String,
                                emergencyType: EmergencyType,
                                isCancelled: Bool) -> String {
        let cotTimeout = 10.0
        let deviceID = deviceID
        let eventType = emergencyType.description
        
        var cotEvent = COTEvent(version: COT_EVENT_VERSION, uid: deviceID, type: eventType, how: "h-g-i-g-o", time: Date(), start: Date(), stale: Date().addingTimeInterval(cotTimeout))
        
        let cotPoint = COTPoint(lat: latitude, lon: longitude, hae: heightAboveElipsoid, ce: circularError, le: linearError)
        
        cotEvent.childNodes.append(cotPoint)
        
        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTLink(relation: "p-p", type: cotType, uid: deviceID))
        cotDetail.childNodes.append(COTContact(callsign: "\(callSign)-Alert"))
        cotDetail.childNodes.append(COTEmergency(cancel: isCancelled, type: emergencyType, callsign: callSign))
                                    
        cotEvent.childNodes.append(cotDetail)
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" + cotEvent.toXml()
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
    
    public func generateChatMessage(message: String, destinationUrl: String) -> String {
        let cotType = "b-t-f"
        let cotHow = "h-g-i-g-o"
        var cotEvent = COTEvent(version: COT_EVENT_VERSION, uid: deviceID, type: cotType, how: cotHow, time: Date(), start: Date(), stale: Date().addingTimeInterval(0))
        
        cotEvent.childNodes.append(COTPoint(lat: "0.0", lon: "0.0", hae: "9999999.0", ce: "9999999.0", le: "9999999.0"))

        var cotDetail = COTDetail()
        
        let messageID = UUID().uuidString
        
        let cotChat = COTChat(messageID: messageID)
        let cotLink = COTLink(relation: "p-p", type: "a-f-G-U-C", uid: messageID)
        let cotRemarks = COTRemarks(source: messageID, timestamp: Date().ISO8601Format(), message: message)
        let cotServerDestination = COTServerDestination(destinations: "\(destinationUrl):tcp:\(messageID)")
        
        cotDetail.childNodes.append(cotChat)
        cotDetail.childNodes.append(cotLink)
        cotDetail.childNodes.append(cotRemarks)
        cotDetail.childNodes.append(cotServerDestination)
        
        return "<?xml version=\"1.0\" standalone=\"yes\"?>" + cotEvent.toXml()
    }
}

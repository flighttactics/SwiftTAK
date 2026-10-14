//
//  Models.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public struct COTPositionInformation {
    public init(cotType: String = COTMessage.DEFAULT_COT_TYPE, cotHow: String = COTMessage.DEFAULT_HOW, heightAboveElipsoid: Double = COTPoint.DEFAULT_ERROR_VALUE, circularError: Double = COTPoint.DEFAULT_ERROR_VALUE, linearError: Double = COTPoint.DEFAULT_ERROR_VALUE, speed: Double = 0.0, course: Double = 0.0, latitude: Double = 0.0, longitude: Double = 0.0) {
        self.cotType = cotType
        self.cotHow = cotHow
        self.heightAboveElipsoid = heightAboveElipsoid
        self.circularError = circularError
        self.linearError = linearError
        self.speed = speed
        self.course = course
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var cotType: String = COTMessage.DEFAULT_COT_TYPE
    public var cotHow: String = COTMessage.DEFAULT_HOW
    public var heightAboveElipsoid: Double = COTPoint.DEFAULT_ERROR_VALUE
    public var circularError: Double = COTPoint.DEFAULT_ERROR_VALUE
    public var linearError: Double = COTPoint.DEFAULT_ERROR_VALUE
    public var speed: Double = 0.0
    public var course: Double = 0.0
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
}

public class COTMessage: NSObject {
    
    static public let XML_HEADER = "<?xml version=\"1.0\" standalone=\"yes\"?>"
    static public let DEFAULT_COT_TYPE = "a-f-G-U-C"
    static public let DEFAULT_CHAT_COT_TYPE = "b-t-f"
    static public let DEFAULT_HOW = HowType.MachineGPSDerived.rawValue
    static public let COT_EVENT_VERSION = "2.0"
    
    var staleTimeMinutes: Double
    var deviceID: String
    var phoneModel: String
    var appPlatform: String
    var phoneOS: String
    var appVersion: String
    var dateFormatter = ISO8601DateFormatter()
    
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
    
    public func generateEmergencyCOTXml(cotType: String = DEFAULT_COT_TYPE,
                                positionInfo: COTPositionInformation,
                                callSign: String,
                                emergencyType: EmergencyType,
                                isCancelled: Bool) -> String {
        let cotTimeout = 10.0
        let deviceID = deviceID
        let eventType = emergencyType.description
        let heightAboveElipsoid: String = positionInfo.heightAboveElipsoid.description
        let circularError: String = positionInfo.circularError.description
        let linearError: String = positionInfo.linearError.description
        let latitude: String = positionInfo.latitude.description
        let longitude: String = positionInfo.longitude.description
        
        var cotEvent = COTEvent(version: COTMessage.COT_EVENT_VERSION, uid: deviceID, type: eventType, how: HowType.HumanGIGO.rawValue, time: Date(), start: Date(), stale: Date().addingTimeInterval(cotTimeout * 60.0))
        
        let cotPoint = COTPoint(lat: latitude, lon: longitude, hae: heightAboveElipsoid, ce: circularError, le: linearError)
        
        cotEvent.childNodes.append(cotPoint)
        
        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTLink(relation: LinkType.ParentProducer.rawValue, type: cotType, uid: deviceID))
        cotDetail.childNodes.append(COTContact(callsign: "\(callSign)-Alert"))
        cotDetail.childNodes.append(COTEmergency(cancel: isCancelled, type: emergencyType, callsign: callSign))
                                    
        cotEvent.childNodes.append(cotDetail)
        
        return COTMessage.XML_HEADER + cotEvent.toXml()
    }
    
    public func generateCOTEvent(cotType: String = DEFAULT_COT_TYPE,
                                 cotHow: String = DEFAULT_HOW,
                                 positionInfo: COTPositionInformation,
                                 callSign: String,
                                 group: String,
                                 role: String,
                                 phone: String,
                                 remarks: String = "",
                                 phoneBatteryStatus: String = "") -> COTEvent {
        let cotTimeout = staleTimeMinutes * 60.0
        let heightAboveElipsoid: String = positionInfo.heightAboveElipsoid.description
        let circularError: String = positionInfo.circularError.description
        let linearError: String = positionInfo.linearError.description
        let latitude: String = positionInfo.latitude.description
        let longitude: String = positionInfo.longitude.description
        let speed: String = positionInfo.speed.description
        let course: String = positionInfo.course.description
        
        var cotEvent = COTEvent(version: COTMessage.COT_EVENT_VERSION, uid: deviceID, type: cotType, how: cotHow, time: Date(), start: Date(), stale: Date().addingTimeInterval(cotTimeout))
        
        let cotPoint = COTPoint(lat: latitude, lon: longitude, hae: heightAboveElipsoid, ce: circularError, le: linearError)
        
        var cotDetail = COTDetail()
        
        cotDetail.childNodes.append(COTContact(endpoint: COTContact.DEFAULT_ENDPOINT, phone: phone, callsign: callSign))
        cotDetail.childNodes.append(COTRemarks(message: remarks))
        cotDetail.childNodes.append(COTGroup(name: group, role: role))
        cotDetail.childNodes.append(COTUid(callsign: callSign))
        cotDetail.childNodes.append(COTTrack(speed: speed, course: course))
        cotDetail.childNodes.append(COTTakV(device: phoneModel,
                                            platform: appPlatform,
                                            os: phoneOS,
                                            version: appVersion))
        if(!phoneBatteryStatus.isEmpty) {
            cotDetail.childNodes.append(COTStatus(battery: phoneBatteryStatus))
        }
        
        cotEvent.childNodes.append(cotPoint)
        cotEvent.childNodes.append(cotDetail)
        return cotEvent
    }
    
    public func generateCOTXml(cotType: String = DEFAULT_COT_TYPE,
                               cotHow: String = DEFAULT_HOW,
                               positionInfo: COTPositionInformation,
                               callSign: String,
                               group: String,
                               role: String,
                               phone: String,
                               remarks: String = "",
                               phoneBatteryStatus: String = "") -> String {
        
        return COTMessage.XML_HEADER + generateCOTEvent(cotType: cotType, cotHow: cotHow, positionInfo: positionInfo, callSign: callSign, group: group, role: role, phone: phone, remarks: remarks, phoneBatteryStatus: phoneBatteryStatus).toXml()
    }
    
    public func generateChatMessage(message: String,
                                    sender: String,
                                    receiver: String = TAKConstants.DEFAULT_CHATROOM_NAME,
                                    destinationUrl: String,
                                    positionInfo: COTPositionInformation = COTPositionInformation()) -> String {
        generateChatMessage(
            message: message,
            senderCallsign: sender,
            conversationId: receiver,
            positionInfo: positionInfo
        )
    }

    public func generateChatMessage(
        message: String,
        senderCallsign: String,
        senderUid: String? = nil,
        conversationId: String = TAKConstants.DEFAULT_CHATROOM_NAME,
        chatroom: String? = nil,
        parent: String = TAKConstants.ROOT_CONTACT_GROUP,
        groupOwner: Bool = false,
        memberUids: [String]? = nil,
        messageID: String? = nil,
        senderCotType: String = COTMessage.DEFAULT_COT_TYPE,
        destUids: [String] = [],
        includeHierarchy: Bool = false,
        deleteChildUids: [String] = [],
        positionInfo: COTPositionInformation = COTPositionInformation()
    ) -> String {
        COTMessage.XML_HEADER + generateChatEvent(
            message: message,
            senderCallsign: senderCallsign,
            senderUid: senderUid,
            conversationId: conversationId,
            chatroom: chatroom,
            parent: parent,
            groupOwner: groupOwner,
            memberUids: memberUids,
            messageID: messageID,
            senderCotType: senderCotType,
            destUids: destUids,
            includeHierarchy: includeHierarchy,
            deleteChildUids: deleteChildUids,
            positionInfo: positionInfo
        ).toXml()
    }

    public func generateChatEvent(
        message: String,
        senderCallsign: String,
        senderUid: String? = nil,
        conversationId: String = TAKConstants.DEFAULT_CHATROOM_NAME,
        chatroom: String? = nil,
        parent: String = TAKConstants.ROOT_CONTACT_GROUP,
        groupOwner: Bool = false,
        memberUids: [String]? = nil,
        messageID: String? = nil,
        senderCotType: String = COTMessage.DEFAULT_COT_TYPE,
        destUids: [String] = [],
        includeHierarchy: Bool = false,
        deleteChildUids: [String] = [],
        positionInfo: COTPositionInformation = COTPositionInformation()
    ) -> COTEvent {
        let cotType = COTMessage.DEFAULT_CHAT_COT_TYPE
        let cotHow = HowType.HumanGIGO.rawValue
        let ONE_DAY = 60.0*60.0*24.0
        let eventTime = Date()
        let stale = Date().addingTimeInterval(ONE_DAY)
        let resolvedSenderUid = senderUid ?? deviceID
        let resolvedChatroom = chatroom ?? conversationId
        let resolvedMessageID = messageID ?? UUID().uuidString
        let resolvedMembers = memberUids ?? [resolvedSenderUid, conversationId]
        let eventUID = "GeoChat.\(resolvedSenderUid).\(conversationId).\(resolvedMessageID)"

        var cotEvent = COTEvent(version: COTMessage.COT_EVENT_VERSION, uid: eventUID, type: cotType, how: cotHow, time: eventTime, start: eventTime, stale: stale)

        cotEvent.childNodes.append(COTPoint(
            lat: positionInfo.latitude.description,
            lon: positionInfo.longitude.description,
            hae: positionInfo.heightAboveElipsoid.description,
            ce: positionInfo.circularError.description,
            le: positionInfo.linearError.description))

        var cotDetail = COTDetail()
        let remarksSource = "BAO.F.TAKAware.\(resolvedSenderUid)"
        let chatGroup = COTChatGroup(memberUids: resolvedMembers, id: conversationId)
        let cotChat = COTChat(
            id: conversationId,
            chatroom: resolvedChatroom,
            groupOwner: groupOwner ? "true" : "false",
            parent: parent,
            senderCallsign: senderCallsign,
            messageID: resolvedMessageID,
            chatGroup: chatGroup,
            hierarchy: includeHierarchy ? COTChatHierarchy.userGroup(id: conversationId, name: resolvedChatroom) : nil,
            deleteChildren: deleteChildUids.map { COTDeleteChild(uid: $0, chatroom: resolvedChatroom, id: conversationId) }
        )
        let cotLink = COTLink(relation: LinkType.ParentProducer.rawValue, type: senderCotType, uid: resolvedSenderUid)
        let cotRemarks = COTRemarks(
            source: remarksSource,
            timestamp: eventTime,
            message: message,
            to: conversationId
        )

        cotDetail.childNodes.append(cotChat)
        cotDetail.childNodes.append(cotLink)
        cotDetail.childNodes.append(cotRemarks)
        if !destUids.isEmpty {
            cotDetail.childNodes.append(COTMarti(uids: destUids))
        }
        cotEvent.childNodes.append(cotDetail)
        return cotEvent
    }
}

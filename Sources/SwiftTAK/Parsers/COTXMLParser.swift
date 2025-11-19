//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import Foundation
import SWXMLHash

public extension XMLAttribute? {
    func toS() -> String {
        return self?.text ?? ""
    }
    
    func toI() -> Int {
        let intString = self?.text ?? "0"
        return Int(intString) ?? 0
    }
    
    func toB() -> Bool {
        let boolString = self?.text ?? "false"
        switch(boolString) {
        case "1", "true":
            return true
        default:
            return false
        }
    }
}

public class COTXMLParser {
    
    let dateParser = COTDateParser()
    public var parsedXml: XMLIndexer? = nil
    
    public init() {
    }
    
    public func parse(_ cotxml: String) -> COTEvent? {
        let parsedCotXml = XMLHash.parse(cotxml)
        parsedXml = parsedCotXml
        
        guard var event = buildCOTEvent(cot: parsedCotXml) else {
            TAKLogger.debug("[COTXMLParser]: No CoT message was detected from the XML")
            TAKLogger.debug("[COTXMLParser]: \(cotxml)")
            return nil
        }
        
        if let cotPoint = buildCOTPoint(cot: parsedCotXml) {
            event.childNodes.append(cotPoint)
        }
        
        if let cotDetail = buildCOTDetail(cot: parsedCotXml) {
            event.childNodes.append(cotDetail)
        }
        
        return event
    }
    
    func buildCOTEvent(cot: XMLIndexer) -> COTEvent? {
        guard let cotEvent = cot["event"].element else {
            return nil
        }

        let eventAttributes = cotEvent.allAttributes
        
        return COTEvent(version: eventAttributes["version"]?.text ?? "",
                        uid: eventAttributes["uid"]?.text ?? "",
                        type: eventAttributes["type"]?.text ?? "",
                        how: eventAttributes["how"]?.text ?? "",
                        time: dateParser.parse(eventAttributes["time"]?.text ?? "") ?? Date(),
                        start: dateParser.parse(eventAttributes["start"]?.text ?? "") ?? Date(),
                        stale: dateParser.parse(eventAttributes["stale"]?.text ?? "") ?? Date())
    }
    
    func buildCOTPoint(cot: XMLIndexer) -> COTPoint? {
        if let cotPoint = cot["event"]["point"].element {
            let pointAttributes = cotPoint.allAttributes
            
           return COTPoint(
                lat: pointAttributes["lat"]?.text ?? "0.0",
                lon: pointAttributes["lon"]?.text ?? "0.0",
                hae: pointAttributes["hae"]?.text ?? COTPoint.DEFAULT_ERROR_VALUE.description,
                ce: pointAttributes["ce"]?.text ?? COTPoint.DEFAULT_ERROR_VALUE.description,
                le: pointAttributes["le"]?.text ?? COTPoint.DEFAULT_ERROR_VALUE.description)
        }
        return nil
    }
    
    func buildCOTDetail(cot: XMLIndexer) -> COTDetail? {
        if cot["event"]["detail"].element != nil {
            var detail = COTDetail()
            
            detail.childNodes.append(contentsOf: buildCOTLinks(cot: cot))
            
            if let cotContact = buildCOTContact(cot: cot) {
                detail.childNodes.append(cotContact)
            }
            
            if let cotRemarks = buildCOTRemarks(cot: cot) {
                detail.childNodes.append(cotRemarks)
            }
            
            if let cotUid = buildCOTUid(cot: cot) {
                detail.childNodes.append(cotUid)
            }
            
            if let cotChat = buildCOTChat(cot: cot) {
                detail.childNodes.append(cotChat)
            }
            
            if let cotServerDestination = buildCOTServerDestination(cot: cot) {
                detail.childNodes.append(cotServerDestination)
            }
            
            if let cotArchive = buildCOTArchive(cot: cot) {
                detail.childNodes.append(cotArchive)
            }
            
            if let cotUserIcon = buildCOTUserIcon(cot: cot) {
                detail.childNodes.append(cotUserIcon)
            }
            
            if let cotColor = buildCOTColor(cot: cot) {
                detail.childNodes.append(cotColor)
            }
            
            if let cotVideo = buildCOTVideo(cot: cot) {
                detail.childNodes.append(cotVideo)
            }
            
            if let cotFillColor = buildCOTFillColor(cot: cot) {
                detail.childNodes.append(cotFillColor)
            }
            
            if let cotLabelsOn = buildCOTLabelsOn(cot: cot) {
                detail.childNodes.append(cotLabelsOn)
            }
            
            if let cotStrokeColor = buildCOTStrokeColor(cot: cot) {
                detail.childNodes.append(cotStrokeColor)
            }
            
            if let cotStrokeWeight = buildCOTStrokeWeight(cot: cot) {
                detail.childNodes.append(cotStrokeWeight)
            }
            
            if let cotShape = buildCOTShape(cot: cot) {
                detail.childNodes.append(cotShape)
            }
            
            if let cotGroup = buildCOTGroup(cot: cot) {
                detail.childNodes.append(cotGroup)
            }
            
            if let cotTrack = buildCOTTrack(cot: cot) {
                detail.childNodes.append(cotTrack)
            }
            
            if let cotStatus = buildCOTStatus(cot: cot) {
                detail.childNodes.append(cotStatus)
            }
            
            if let cotEmergency = buildCOTEmergency(cot: cot) {
                detail.childNodes.append(cotEmergency)
            }
            
            if let cotAttachmentList = buildCOTAttachmentList(cot: cot) {
                detail.childNodes.append(cotAttachmentList)
            }
            
            if let cotSensor = buildCOTSensor(cot: cot) {
                detail.childNodes.append(cotSensor)
            }
            
            return detail
        }
        return nil
    }
    
    func buildCOTAttachmentList(cot: XMLIndexer) -> COTAttachmentList? {
        if let cotAttachmentList = cot["event"]["detail"]["attachment_list"].element {
            let groupAttrs = cotAttachmentList.allAttributes
            let hashes = groupAttrs["hashes"]?.text ?? ""
            if hashes.isEmpty {
                TAKLogger.debug("[COTXMLParser]: No hashes were found in the attachment list")
                return nil
            }
            return COTAttachmentList(hashes: hashes)
        }
        return nil
    }
    
    func buildCOTEmergency(cot: XMLIndexer) -> COTEmergency? {
        if let cotEmergency = cot["event"]["detail"]["emergency"].element {
            let groupAttrs = cotEmergency.allAttributes
            let cancelText = groupAttrs["cancel"]?.text ?? "false"
            let cancel = (cancelText == "true")
            let emergencyTypeText = groupAttrs["type"]?.text ?? "b-a-o-tbl"
            let emergencyType = EmergencyType(rawValue: emergencyTypeText) ?? EmergencyType.NineOneOne
            let callsign = cotEmergency.text
            return COTEmergency(cancel: cancel, type: emergencyType, callsign: callsign)
        }
        return nil
    }
    
    func buildCOTStatus(cot: XMLIndexer) -> COTStatus? {
        if let cotStatus = cot["event"]["detail"]["status"].element {
            let groupAttrs = cotStatus.allAttributes
            let battery = groupAttrs["battery"]?.text ?? "0.0"
            return COTStatus(battery: battery)
        }
        return nil
    }
    
    func buildCOTTrack(cot: XMLIndexer) -> COTTrack? {
        if let cotTrack = cot["event"]["detail"]["track"].element {
            let groupAttrs = cotTrack.allAttributes
            let speed = groupAttrs["speed"]?.text ?? ""
            let course = groupAttrs["course"]?.text ?? ""
            return COTTrack(speed: speed, course: course)
        }
        return nil
    }
    
    func buildCOTGroup(cot: XMLIndexer) -> COTGroup? {
        if let cotGroup = cot["event"]["detail"]["__group"].element {
            let groupAttrs = cotGroup.allAttributes
            let name = groupAttrs["name"]?.text ?? ""
            let role = groupAttrs["role"]?.text ?? ""
            return COTGroup(name: name, role: role)
        }
        return nil
    }
    
    func buildCOTShape(cot: XMLIndexer) -> COTShape? {
        if cot["event"]["detail"]["shape"].element != nil {
            var cotShape = COTShape()
            cotShape.childNodes.append(contentsOf: buildCOTEllipses(cot: cot))
            return cotShape
        }
        return nil
    }
    
    func buildCOTEllipses(cot: XMLIndexer) -> [COTEllipse] {
        let allEllipses = cot["event"]["detail"]["shape"].children.filter { $0.element?.name == "ellipse" }
        return allEllipses.compactMap { cotEllipse in
            guard let cotEllipseElement = cotEllipse.element else { return nil }
            let ellipseAttrs = cotEllipseElement.allAttributes
            let major = Double(ellipseAttrs["major"]?.text ?? "0.0") ?? 0.0
            let minor = Double(ellipseAttrs["minor"]?.text ?? "0.0") ?? 0.0
            let angle = Double(ellipseAttrs["angle"]?.text ?? "0.0") ?? 0.0
            return COTEllipse(
                major: major,
                minor: minor,
                angle: angle
            )
        }
    }
    
    func buildCOTFillColor(cot: XMLIndexer) -> COTFillColor? {
        if let cotFillColor = cot["event"]["detail"]["fillColor"].element {
            let colorAttrs = cotFillColor.allAttributes
            let valueString = colorAttrs["value"]?.text ?? ""
            guard let value = Int(valueString) else {
                return nil
            }
            return COTFillColor(
                value: value
            )
        }
        return nil
    }
    
    func buildCOTLabelsOn(cot: XMLIndexer) -> COTLabelsOn? {
        if let cotLabelsOn = cot["event"]["detail"]["labels_on"].element {
            let labelsAttrs = cotLabelsOn.allAttributes
            let valueString = labelsAttrs["value"]?.text ?? ""
            return COTLabelsOn(
                value: valueString == "true"
            )
        }
        return nil
    }
    
    func buildCOTStrokeColor(cot: XMLIndexer) -> COTStrokeColor? {
        if let cotStrokeColor = cot["event"]["detail"]["strokeColor"].element {
            let colorAttrs = cotStrokeColor.allAttributes
            let valueString = colorAttrs["value"]?.text ?? ""
            guard let value = Int(valueString) else {
                return nil
            }
            return COTStrokeColor(
                value: value
            )
        }
        return nil
    }
    
    func buildCOTStrokeWeight(cot: XMLIndexer) -> COTStrokeWeight? {
        if let cotStrokeWeight = cot["event"]["detail"]["strokeWeight"].element {
            let weightAttrs = cotStrokeWeight.allAttributes
            let valueString = weightAttrs["value"]?.text ?? ""
            guard let value = Double(valueString) else {
                return nil
            }
            return COTStrokeWeight(
                value: value
            )
        }
        return nil
    }
    
    func buildCOTVideo(cot: XMLIndexer) -> COTVideo? {
        let cotVideoNode = cot["event"]["detail"]["__video"]
        var connectionEntry: COTConnectionEntry? = nil
        if let cotVideo = cotVideoNode.element {
            if let cotConnectionEntry = cotVideoNode["ConnectionEntry"].element {
                let connectionAttrs = cotConnectionEntry.allAttributes
                connectionEntry = COTConnectionEntry(
                    uid: connectionAttrs["uid"].toS(),
                    alias: connectionAttrs["alias"].toS(),
                    connectionProtocol: connectionAttrs["protocol"].toS(),
                    address: connectionAttrs["address"].toS(),
                    port: connectionAttrs["port"].toI(),
                    path: connectionAttrs["path"].toS(),
                    roverPort: connectionAttrs["roverPort"].toI(),
                    rtspReliable: connectionAttrs["rtspReliable"].toI(),
                    ignoreEmbeddedKLV: connectionAttrs["ignoreEmbeddedKLV"].toB(),
                    networkTimeout: connectionAttrs["networkTimeout"].toI(),
                    bufferTime: connectionAttrs["bufferTime"].toI())
            }
            let attributes = cotVideo.allAttributes
            return COTVideo(
                baseUrl: attributes["url"]?.text ?? "",
                uid: attributes["uid"]?.text ?? "",
                connectionEntry: connectionEntry
            )
        }
        return nil
    }
    
    func buildCOTUserIcon(cot: XMLIndexer) -> COTUserIcon? {
        if let cotIcon = cot["event"]["detail"]["usericon"].element {
            let iconAttributes = cotIcon.allAttributes
            return COTUserIcon(
                iconsetPath: iconAttributes["iconsetpath"]?.text ?? ""
            )
        }
        return nil
    }
    
    func buildCOTColor(cot: XMLIndexer) -> COTColor? {
        if let cotIcon = cot["event"]["detail"]["color"].element {
            let colorAttributes = cotIcon.allAttributes
            let argbString = colorAttributes["argb"]?.text ?? ""
            guard let argb = Int(argbString) else {
                return nil
            }
            return COTColor(
                argb: argb
            )
        }
        return nil
    }
    
    func buildCOTArchive(cot: XMLIndexer) -> COTArchive? {
        if cot["event"]["detail"]["archive"].element != nil {
            return COTArchive()
        }
        return nil
    }
    
    func buildCOTContact(cot: XMLIndexer) -> COTContact? {
        if let cotContact = cot["event"]["detail"]["contact"].element {
            let contactAttributes = cotContact.allAttributes
            return COTContact(
                endpoint: contactAttributes["endpoint"]?.text ?? COTContact.DEFAULT_ENDPOINT,
                phone: contactAttributes["phone"]?.text ?? "",
                callsign: contactAttributes["callsign"]?.text ?? ""
            )
        }
        return nil
    }
    
    func buildCOTRemarks(cot: XMLIndexer) -> COTRemarks? {
        if let cotRemarks = cot["event"]["detail"]["remarks"].element {
            let remarksAttributes = cotRemarks.allAttributes
            return COTRemarks(
                source: remarksAttributes["source"]?.text ?? "",
                timestamp: dateParser.parse(remarksAttributes["time"]?.text ?? ""),
                message: cotRemarks.text,
                to: remarksAttributes["to"]?.text ?? ""
            )
        }
        return nil
    }
    
    func buildCOTUid(cot: XMLIndexer) -> COTUid? {
        if let cotUid = cot["event"]["detail"]["uid"].element {
            let uidAttributes = cotUid.allAttributes
            var callsign = ""
            if(uidAttributes["callsign"] != nil) {
                callsign = uidAttributes["callsign"]?.text ?? ""
            } else {
                callsign = cot["event"]["detail"]["uid"]["Droid"].element?.text ?? ""
            }
            return COTUid(
                callsign: callsign
            )
        }
        return nil
    }
    
    func buildCOTChat(cot: XMLIndexer) -> COTChat? {
        if let cotChat = cot["event"]["detail"]["__chat"].element {
            let chatAttributes = cotChat.allAttributes
            var chat = COTChat(
                id: chatAttributes["id"]?.text ?? COTChat.DEFAULT_CHATROOM,
                chatroom: chatAttributes["chatroom"]?.text ?? COTChat.DEFAULT_CHATROOM,
                groupOwner: chatAttributes["groupOwner"]?.text ?? "",
                parent: chatAttributes["parent"]?.text ?? "",
                senderCallsign: chatAttributes["senderCallsign"]?.text ?? "",
                messageID: chatAttributes["messageId"]?.text ?? UUID().uuidString
            )
            
            if let cotChatGroup = cot["event"]["detail"]["__chat"]["chatgrp"].element {
                let chatGroupAttributes = cotChatGroup.allAttributes
                let chatGroup = COTChatGroup(
                    uid0: chatGroupAttributes["uid0"]?.text ?? UUID().uuidString,
                    uid1: chatGroupAttributes["uid1"]?.text ?? COTChatGroup.DEFAULT_CHATROOM,
                    id: chatGroupAttributes["id"]?.text ?? COTChatGroup.DEFAULT_CHATROOM
                )
                chat.cotChatGroup = chatGroup
            }
            
            return chat
        }
        return nil
    }
    
    func buildCOTLinks(cot: XMLIndexer) -> [COTLink] {
        let cotLinks = cot["event"]["detail"]["link"].all
        var result: [COTLink] = []
        cotLinks.forEach { link in
            if let cotLink = link.element {
                let linkAttributes = cotLink.allAttributes
                let resultNode = COTLink(
                    parentCallsign: linkAttributes["parent_callsign"]?.text ?? "",
                    productionTime: linkAttributes["production_time"]?.text ?? "",
                    relation: linkAttributes["relation"]?.text ?? "",
                    type: linkAttributes["type"]?.text ?? "",
                    uid: linkAttributes["uid"]?.text ?? "",
                    callsign: linkAttributes["callsign"]?.text ?? "",
                    remarks: linkAttributes["remarks"]?.text ?? "",
                    point: linkAttributes["point"]?.text ?? "",
                    url: linkAttributes["url"]?.text ?? "",
                    mimeType: linkAttributes["mime"]?.text ?? ""
                )
                result.append(resultNode)
            }
        }
        return result
    }
    
    func buildCOTServerDestination(cot: XMLIndexer) -> COTServerDestination? {
        if let cotServerDestination = cot["event"]["detail"]["__serverdestination"].element {
            let destinationAttributes = cotServerDestination.allAttributes
            return COTServerDestination(
                destinations: destinationAttributes["destinations"]?.text ?? ""
            )
        }
        return nil
    }
    
    func buildCOTSensor(cot: XMLIndexer) -> COTSensor? {
        if let cotSensor = cot["event"]["detail"]["sensor"].element {
            let sensorAttributes = cotSensor.allAttributes
            return COTSensor(
                azimuth: Double(sensorAttributes["azimuth"]?.text ?? ""),
                elevation: Double(sensorAttributes["elevation"]?.text ?? ""),
                roll: Double(sensorAttributes["roll"]?.text ?? ""),
                fov: Double(sensorAttributes["fov"]?.text ?? ""),
                vfov: Double(sensorAttributes["vfov"]?.text ?? ""),
                north: Double(sensorAttributes["north"]?.text ?? ""),
                version: Double(sensorAttributes["version"]?.text ?? ""),
                type: sensorAttributes["type"]?.text,
                model: sensorAttributes["model"]?.text,
                range: Double(sensorAttributes["range"]?.text ?? ""))
        }
        return nil
    }
}

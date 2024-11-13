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
    
    public init() {
    }
    
    public func parse(_ cotxml: String) -> COTEvent? {
        let cot = XMLHash.parse(cotxml)
        
        guard var event = buildCOTEvent(cot: cot) else {
            TAKLogger.debug("[COTXMLParser]: No CoT message was detected from the XML")
            TAKLogger.debug("[COTXMLParser]: \(cotxml)")
            return nil
        }
        
        if let cotPoint = buildCOTPoint(cot: cot) {
            event.childNodes.append(cotPoint)
        }
        
        if let cotDetail = buildCOTDetail(cot: cot) {
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
            
            if let cotLink = buildCOTLink(cot: cot) {
                detail.childNodes.append(cotLink)
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
            
            return detail
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
    
    func buildCOTLink(cot: XMLIndexer) -> COTLink? {
        if let cotLink = cot["event"]["detail"]["link"].element {
            let linkAttributes = cotLink.allAttributes
            return COTLink(
                parentCallsign: linkAttributes["parent_callsign"]?.text ?? "",
                productionTime: linkAttributes["production_time"]?.text ?? "",
                relation: linkAttributes["relation"]?.text ?? "",
                type: linkAttributes["type"]?.text ?? "",
                uid: linkAttributes["uid"]?.text ?? UUID().uuidString,
                callsign: linkAttributes["callsign"]?.text ?? ""
            )
        }
        return nil
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
}

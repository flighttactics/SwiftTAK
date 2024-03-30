//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import Foundation
import SWXMLHash

class COTXMLParser {
    
    let dateFormatter = ISO8601DateFormatter()
    
    public init() {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
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
                        time: dateFormatter.date(from: eventAttributes["time"]?.text ?? "") ?? Date(),
                        start: dateFormatter.date(from: eventAttributes["start"]?.text ?? "") ?? Date(),
                        stale: dateFormatter.date(from: eventAttributes["stale"]?.text ?? "") ?? Date())
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
            
            return detail
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
                timestamp: remarksAttributes["time"]?.text ?? "",
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

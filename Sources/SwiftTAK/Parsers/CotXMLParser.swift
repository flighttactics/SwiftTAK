//
//  CotXMLParser.swift
//  SwiftTAK
//
//  Created by Cory Foy on 10/12/23.
//

import Foundation

class CotXMLParser: NSObject, XMLParserDelegate {
    var cotEvent: COTEvent?
    var cotPoint: COTPoint?
    var cotDetail: COTDetail?
    
    var cotChat: COTChat?
    var cotChatGroup: COTChatGroup?
    var cotLink: COTLink?
    var cotServerDestination: COTServerDestination?
    var cotRemarks: COTRemarks?

    var currentElementName: String = ""
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if(cotChatGroup != nil && cotChat != nil) {
            cotChat!.childNodes.append(cotChatGroup!)
        }
        
        if(cotDetail != nil) {
            if(cotChat != nil) { cotDetail!.childNodes.append(cotChat!) }
            if(cotLink != nil) { cotDetail!.childNodes.append(cotLink!) }
            if(cotServerDestination != nil) { cotDetail!.childNodes.append(cotServerDestination!) }
            if(cotRemarks != nil) { cotDetail!.childNodes.append(cotRemarks!) }
            cotEvent!.childNodes.append(cotDetail!)
        }
        
        if(cotPoint != nil) { cotEvent!.childNodes.append(cotPoint!) }
    }
    
    func parser(_ parser: XMLParser,
        foundCharacters string: String
    ) {
        if (string.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            if(currentElementName == "remarks" && cotRemarks != nil) {
                cotRemarks!.message = string
            }
        }
    }

    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        currentElementName = elementName
        switch(elementName) {
        case "event":
            buildCotEvent(attributes: attributeDict)
        case "point":
            buildCotPoint(attributes: attributeDict)
        case "detail":
            buildCotDetail(attributes: attributeDict)
        case "__chat":
            buildCotChat(attributes: attributeDict)
        case "chatgrp":
            buildCotChatGroup(attributes: attributeDict)
        case "link":
            buildCotLink(attributes: attributeDict)
        case "__serverdestination":
            buildCotServerDestination(attributes: attributeDict)
        case "remarks":
            buildCotRemarks(attributes: attributeDict)
        default:
            TAKLogger.debug("Unknown element found while parsing: \(elementName)")
        }
        
    }
    
    func buildCotChatGroup(attributes: [String:String]) {
        let id = attributes["id"] ?? ""
        let uid0 = attributes["uid0"] ?? ""
        let uid1 = attributes["uid1"] ?? ""

        cotChatGroup = COTChatGroup(id: id, uid0: uid0, uid1: uid1)
    }
    
    func buildCotLink(attributes: [String:String]) {
        let uid = attributes["uid"] ?? ""
        let type = attributes["type"] ?? ""
        let relation = attributes["relation"] ?? ""

        cotLink = COTLink(relation: relation, type: type, uid: uid)
    }
    
    func buildCotServerDestination(attributes: [String:String]) {
        let destinations = attributes["destinations"] ?? ""

        cotServerDestination = COTServerDestination(destinations: destinations)
    }
    
    func buildCotRemarks(attributes: [String:String]) {
        let source = attributes["source"] ?? ""
        let to = attributes["to"] ?? ""
        let time = attributes["time"] ?? ""
        let message = attributes["message"] ?? ""

        cotRemarks = COTRemarks(source: source, timestamp: time, message: message, to: to)
    }
    
    func buildCotChat(attributes: [String:String]) {
        let id = attributes["id"] ?? ""
        let chatroom = attributes["chatroom"] ?? ""
        let groupOwner = attributes["groupOwner"] ?? ""
        let parent = attributes["parent"] ?? ""
        let senderCallsign = attributes["senderCallsign"] ?? ""
        let messageID = attributes["messageId"] ?? ""
        cotChat = COTChat(id: id, chatroom: chatroom, groupOwner: groupOwner, parent: parent, senderCallsign: senderCallsign, messageID: messageID)
    }
    
    func buildCotDetail(attributes: [String:String]) {
        cotDetail = COTDetail()
    }
    
    func buildCotPoint(attributes: [String:String]) {        
        let lat = attributes["lat"] ?? "0.0"
        let lon = attributes["lon"] ?? "0.0"
        let hae = attributes["hae"] ?? "9999999.0"
        let ce = attributes["ce"] ?? "9999999.0"
        let le = attributes["le"] ?? "9999999.0"
        
        cotPoint = COTPoint(lat: lat, lon: lon, hae: hae, ce: ce, le: le)
    }
    
    func buildCotEvent(attributes: [String:String]) {
        let version = attributes["version"] ?? "2.0"
        let uid = attributes["uid"] ?? ""
        let type = attributes["type"] ?? ""
        let how = attributes["how"] ?? ""
        let timeStr = attributes["time"] ?? ""
        let startStr = attributes["start"] ?? ""
        let staleStr = attributes["stale"] ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        var time = Date()
        var start = Date()
        var stale = Date()
        
        if let dateObj = dateFormatter.date(from: timeStr){
            time = dateObj
        }
        
        if let dateObj = dateFormatter.date(from: startStr){
            start = dateObj
        }
        
        if let dateObj = dateFormatter.date(from: staleStr){
            stale = dateObj
        }
        
        cotEvent = COTEvent(version: version, uid: uid, type: type, how: how, time: time, start: start, stale: stale)
    }

    static func cotXmlToEvent(cotXml: String) -> COTEvent? {
        let xmlParser = XMLParser(data: Data(cotXml.utf8))
        let eventParser = CotXMLParser()
        xmlParser.delegate = eventParser
        xmlParser.parse()
        return eventParser.cotEvent
    }
}

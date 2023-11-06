//
//  CotXMLParserTests.swift
//  SwiftTAKTests
//
//  Created by Cory Foy on 10/12/23.
//

import Foundation
import XCTest

@testable import SwiftTAK

final class COTXMLParserTests: SwiftTAKTestCase {
    let chatMessageXml: String = """
<event version="2.0"
    uid="GeoChat.ANDROID-f33ec5af20765447.All Chat Rooms.f98d00f3-ac68-4c9c-9c4e-427e91ae800e"
    type="b-t-f" how="h-g-i-g-o" time="2023-10-12T17:24:58Z" start="2023-10-12T17:24:57Z"
    stale="2023-10-13T17:24:57Z" access="Undefined">
    <point lat="35.047" lon="-71.176" hae="199.568" ce="9.9" le="9999999.0" />
    <detail>
        <__chat parent="RootContactGroup" groupOwner="false"
            messageId="f98d00f3-ac68-4c9c-9c4e-427e91ae800e" chatroom="All Chat Rooms"
            id="All Chat Rooms" senderCallsign="TRACKER01">
            <chatgrp uid0="ANDROID-f33ec5af20765447" uid1="All Chat Rooms" id="All Chat Rooms" />
        </__chat>
        <link uid="ANDROID-f33ec5af20765447" type="a-f-G-U-C" relation="p-p" />
        <__serverdestination destinations="192.168.0.65:4242:tcp:ANDROID-f33ec5af20765447" />
        <remarks source="BAO.F.ATAK.ANDROID-f33ec5af20765447" to="All Chat Rooms"
            time="2023-10-12T17:24:57.848Z">at LCC</remarks>
    </detail>
</event>
"""
    
    let nonChatMessageXml: String = """
<?xml version="1.0" encoding="UTF-8"?>
<event version="2.0" uid="bd61b2b7-714d-ab96-2ced-2518b5cde2f6" type="a-f-G-U-C-I" how="h-e" time="2023-10-12T17:24:58Z" start="2023-10-12T17:24:57Z" stale="2023-10-13T17:24:57Z">
    <point lat="35.047" lon="-71.176" hae="199.568" ce="9.9" le="9999999.0" />
    <detail>
        <contact callsign="PAN HANDLE177" endpoint="*:-1:stcp"/>
        <__group name="Cyan" role="Team Member"/>
        <takv device="Safari - 17" platform="WebTAK" os="Macintosh - 10.157" version="4.9.0"/>
        <link relation="p-p" type="a-f-G-U-C-I" uid="bd61b2b7-714d-ab96-2ced-2518b5cde2f6"/>
        <_flow-tags_ TAK-Server-b64d651b53484d85bcc739ece301951b="2023-10-24T01:26:07Z"/>
    </detail>
</event>
"""
    
    func testChatMessagesAreMarkedAsChatMessages() {
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        XCTAssert(cotEvent.isChatMessage)
    }
    
    func testNonChatMessagesAreMarkedAsNonChatMessages() {
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: nonChatMessageXml)!
        XCTAssert(!cotEvent.isChatMessage)
    }
    
    func testParserBuildChatNodeProperly() {
        let expected = COTChat(id: "All Chat Rooms", chatroom: "All Chat Rooms", groupOwner: "false", parent: "RootContactGroup", senderCallsign: "TRACKER01", messageID: "f98d00f3-ac68-4c9c-9c4e-427e91ae800e")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail?.chat
        
        if(actual == nil) {
            XCTFail("Chat Node not created")
            return
        }
        
        XCTAssertEqual(expected.id, actual!.id)
        XCTAssertEqual(expected.chatroom, actual!.chatroom)
        XCTAssertEqual(expected.groupOwner, actual!.groupOwner)
        XCTAssertEqual(expected.parent, actual!.parent)
        XCTAssertEqual(expected.senderCallsign, actual!.senderCallsign)
        XCTAssertEqual(expected.messageID, actual!.messageID)
    }
    
    func testParserBuildChatGroupNodeProperly() {
        // <chatgrp uid0="ANDROID-f33ec5af20765447" uid1="All Chat Rooms" id="All Chat Rooms" />
        let expected = COTChatGroup(id: "All Chat Rooms", uid0: "ANDROID-f33ec5af20765447", uid1: "All Chat Rooms")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail?.chat?.chatGroup
        
        if(actual == nil) {
            XCTFail("ChatGroup Node not created")
            return
        }
        
        XCTAssertEqual(expected.id, actual!.id)
        XCTAssertEqual(expected.uid0, actual!.uid0)
        XCTAssertEqual(expected.uid1, actual!.uid1)
    }
    
    func testParserBuildsLinkProperly() {
        let expected = COTLink(relation: "p-p", type: "a-f-G-U-C", uid: "ANDROID-f33ec5af20765447")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail?.link
        
        if(actual == nil) {
            XCTFail("Link Node not created")
            return
        }
        
        XCTAssertEqual(expected.relation, actual!.relation)
        XCTAssertEqual(expected.type, actual!.type)
        XCTAssertEqual(expected.uid, actual!.uid)
    }
    
    func testParserBuildsServerDestinationProperly() {
        let expected = COTServerDestination(destinations: "192.168.0.65:4242:tcp:ANDROID-f33ec5af20765447")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail?.serverDestination
        
        if(actual == nil) {
            XCTFail("ServerDestination Node not created")
            return
        }
        
        XCTAssertEqual(expected.destinations, actual!.destinations)
    }
    
    func testParserBuildsRemarksProperly() {
        let expected = COTRemarks(source: "BAO.F.ATAK.ANDROID-f33ec5af20765447", timestamp: "2023-10-12T17:24:57.848Z", message: "at LCC", to: "All Chat Rooms")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail?.remarks
        
        if(actual == nil) {
            XCTFail("Remarks Node not created")
            return
        }

        XCTAssertEqual(expected.source, actual!.source)
        XCTAssertEqual(expected.timestamp, actual!.timestamp)
        XCTAssertEqual(expected.message, actual!.message)
        XCTAssertEqual(expected.to, actual!.to)
    }
    
    func testParserBuildsPointProperly() {
        let expected = COTPoint(lat: "35.047", lon: "-71.176", hae: "199.568", ce: "9.9", le: "9999999.0")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.point
        
        if(actual == nil) {
            XCTFail("Point Node not created")
            return
        }
        
        XCTAssertEqual(expected.lat, actual!.lat)
        XCTAssertEqual(expected.lon, actual!.lon)
        XCTAssertEqual(expected.hae, actual!.hae)
        XCTAssertEqual(expected.ce, actual!.ce)
        XCTAssertEqual(expected.le, actual!.le)
    }
    
    func testParserBuildsDetailProperly() {
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        let actual = cotEvent.detail
        
        if(actual == nil) {
            XCTFail("Detail Node not created")
            return
        }
    }
    
    func testParserBuildsEventAttrsProperly() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let eventTime = dateFormatter.date(from: "2023-10-12T17:24:58Z")!
        let startTime = dateFormatter.date(from: "2023-10-12T17:24:57Z")!
        let staleTime = dateFormatter.date(from: "2023-10-13T17:24:57Z")!
        let expected = COTEvent(version: "2.0", uid: "GeoChat.ANDROID-f33ec5af20765447.All Chat Rooms.f98d00f3-ac68-4c9c-9c4e-427e91ae800e", type: "b-t-f", how: "h-g-i-g-o", time: eventTime, start: startTime, stale: staleTime)
        let actual: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: chatMessageXml)!
        
        XCTAssertEqual(expected.version, actual.version)
        XCTAssertEqual(expected.uid, actual.uid)
        XCTAssertEqual(expected.type, actual.type)
        XCTAssertEqual(expected.how, actual.how)
        XCTAssertEqual(expected.time, actual.time)
        XCTAssertEqual(expected.start, actual.start)
        XCTAssertEqual(expected.stale, actual.stale)
    }
    
    
    // For Non Chat Messages
    func testParserBuildsPointProperlyForNonChatMessages() {
        let expected = COTPoint(lat: "35.047", lon: "-71.176", hae: "199.568", ce: "9.9", le: "9999999.0")
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: nonChatMessageXml)!
        let actual = cotEvent.point
        
        if(actual == nil) {
            XCTFail("Point Node not created")
            return
        }
        
        XCTAssertEqual(expected.lat, actual!.lat)
        XCTAssertEqual(expected.lon, actual!.lon)
        XCTAssertEqual(expected.hae, actual!.hae)
        XCTAssertEqual(expected.ce, actual!.ce)
        XCTAssertEqual(expected.le, actual!.le)
    }
    
    func testParserBuildsDetailProperlyForNonChatMessages() {
        let cotEvent: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: nonChatMessageXml)!
        let actual = cotEvent.detail
        
        if(actual == nil) {
            XCTFail("Detail Node not created")
            return
        }
    }
    
    func testParserBuildsEventAttrsProperlyForNonChatMessages() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let eventTime = dateFormatter.date(from: "2023-10-12T17:24:58Z")!
        let startTime = dateFormatter.date(from: "2023-10-12T17:24:57Z")!
        let staleTime = dateFormatter.date(from: "2023-10-13T17:24:57Z")!
        let expected = COTEvent(version: "2.0", uid: "bd61b2b7-714d-ab96-2ced-2518b5cde2f6", type: "a-f-G-U-C-I", how: "h-e", time: eventTime, start: startTime, stale: staleTime)
        let actual: COTEvent = COTXMLParser.cotXmlToEvent(cotXml: nonChatMessageXml)!
        
        XCTAssertEqual(expected.version, actual.version)
        XCTAssertEqual(expected.uid, actual.uid)
        XCTAssertEqual(expected.type, actual.type)
        XCTAssertEqual(expected.how, actual.how)
        XCTAssertEqual(expected.time, actual.time)
        XCTAssertEqual(expected.start, actual.start)
        XCTAssertEqual(expected.stale, actual.stale)
    }
}

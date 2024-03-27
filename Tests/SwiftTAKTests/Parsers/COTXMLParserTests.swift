//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import XCTest

@testable import SwiftTAK

class COTXMLParserTests: SwiftTAKTestCase {
    let CONTACT_EVENT: String = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <event version="2.0" uid="T1" type="a-f-G-E" how="m-g" time="2024-03-11T12:43:51.711Z"
        start="2024-03-11T12:23:13.000Z" stale="2024-03-11T13:23:13.000Z">
        <point lat="35.91195" lon="-79.07783" hae="30.0" ce="9999999.0" le="9999999.0" />
        <detail>
            <contact callsign="T1" />
            <remarks>CFRD: Tanker 1</remarks>
            <uid>
                <Droid>T1</Droid>
            </uid>
        </detail>
    </event>
    """
    
    let CHAT_EVENT: String = """
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <event version="2.0"
        uid="GeoChat.9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A.All Chat Rooms.E0777F3F-671A-4ACC-AE33-D7D996C52004"
        type="b-t-f" how="h-g-i-g-o" time="2024-03-18T01:40:56Z" start="2024-03-18T01:40:56Z"
        stale="2024-03-18T01:42:56Z">
        <point lat="36.04703336491824" lon="-79.17704832747502" hae="9999999.0" ce="9999999.0"
            le="9999999.0" />
        <detail>
            <__chat parent="RootContactGroup" groupOwner="false"
                messageId="E0777F3F-671A-4ACC-AE33-D7D996C52004" chatroom="All Chat Rooms"
                id="All Chat Rooms" senderCallsign="JEXAMPLE-IPHONE">
                <chatgrp uid0="9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A" uid1="All Chat Rooms"
                    id="All Chat Rooms" />
            </__chat>
            <link uid="9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A" type="a-f-G-E-V-C" relation="p-p" />
            <remarks source="BAO.F.ATAK.9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A" to="All Chat Rooms"
                time="2024-03-18T01:40:56Z">Help world </remarks>
            <__serverdestination
                destinations="192.168.0.79:4242:tcp:9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A" />
            <_flow-tags_ TAK-Server-dd4055d128d5416e826423948c66e412="2024-03-18T01:40:56Z" />
        </detail>
    </event>
"""
    
    let dateFormatter = ISO8601DateFormatter()
    let parser = COTXMLParser()
    
    override func setUp() async throws {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
    }
    
    func testProperlyCreatesCOTEventFromXML() {
        let expected_event = COTEvent(
            version: "2.0",
            uid: "T1",
            type: "a-f-G-E",
            how: "m-g",
            time: dateFormatter.date(from: "2024-03-11T12:43:51.711Z")!,
            start: dateFormatter.date(from: "2024-03-11T12:23:13.000Z")!,
            stale: dateFormatter.date(from: "2024-03-11T13:23:13.000Z")!
        )
        let actual_event = parser.parse(CONTACT_EVENT)
        XCTAssertEqual(expected_event, actual_event)
    }
    
    func testProperlyCreatesCOTPointFromXML() {
        let expected_point = COTPoint(
            lat: "35.91195",
            lon: "-79.07783",
            hae: "30.0",
            ce: "9999999.0",
            le: "9999999.0")
        let event = parser.parse(CONTACT_EVENT)
        let actual_point = event?.cotPoint
        XCTAssertEqual(expected_point, actual_point)
    }
    
    func testProperlyCreatesCOTDetailFromXML() {
        let expected_detail = COTDetail()
        let event = parser.parse(CONTACT_EVENT)
        let actual_detail = event?.cotDetail
        XCTAssertEqual(expected_detail, actual_detail)
    }
}

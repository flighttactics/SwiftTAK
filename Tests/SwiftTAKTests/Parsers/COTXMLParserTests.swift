//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import XCTest
import SWXMLHash

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
    <event version="2.0" uid="GeoChat.9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A.All Chat Rooms.E0777F3F-671A-4ACC-AE33-D7D996C52004" type="b-t-f" how="h-g-i-g-o" time="2024-03-18T01:40:56Z"
        start="2024-03-18T01:40:56Z" stale="2024-03-18T01:42:56Z">
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

    func testUnparsableStaleAttributeDoesNotDefaultToNow() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <event version="2.0" uid="T1" type="a-f-G-E" how="m-g" time="2024-03-11T12:43:51.711Z"
            start="2024-03-11T12:23:13.000Z" stale="not-a-date">
            <point lat="35.91195" lon="-79.07783" hae="30.0" ce="9999999.0" le="9999999.0" />
        </event>
        """
        let event = parser.parse(xml)
        XCTAssertEqual(event?.stale, COTDateParser.noExpirationStale)
    }

    func testMissingStaleAttributeDoesNotDefaultToNow() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <event version="2.0" uid="T1" type="a-f-G-E" how="m-g" time="2024-03-11T12:43:51.711Z"
            start="2024-03-11T12:23:13.000Z">
            <point lat="35.91195" lon="-79.07783" hae="30.0" ce="9999999.0" le="9999999.0" />
        </event>
        """
        let event = parser.parse(xml)
        XCTAssertEqual(event?.stale, COTDateParser.noExpirationStale)
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
        let event = parser.parse(CONTACT_EVENT)
        let actual_detail = event?.cotDetail
        XCTAssertNotNil(actual_detail)
    }
    
    func testProperlyCreatesCOTContactFromXML() {
        let expected_contact = COTContact(callsign: "T1")
        let event = parser.parse(CONTACT_EVENT)
        let detail = event?.cotDetail
        let actual_contact = detail?.cotContact
        XCTAssertEqual(expected_contact, actual_contact)
    }
    
    func testProperlyCreatesCOTRemarksFromXML() {
        let expected_remarks = COTRemarks(message: "CFRD: Tanker 1")
        let event = parser.parse(CONTACT_EVENT)
        let detail = event?.cotDetail
        let actual_remarks = detail?.cotRemarks
        XCTAssertEqual(expected_remarks, actual_remarks)
    }
    
    func testProperlyCreatesChatStyleCOTRemarksFromXML() {
        let expected_ts = ISO8601DateFormatter().date(from: "2024-03-18T01:40:56Z")
        let expected_remarks = COTRemarks(source: "BAO.F.ATAK.9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A", timestamp: expected_ts!, message: "Help world ", to: "All Chat Rooms")
        let event = parser.parse(CHAT_EVENT)
        let detail = event?.cotDetail
        let actual_remarks = detail?.cotRemarks
        XCTAssertEqual(expected_remarks, actual_remarks)
    }
    
    func testProperlyCreatesCOTUIDFromXML() {
        let expected_uid = COTUid(callsign: "T1")
        let event = parser.parse(CONTACT_EVENT)
        let detail = event?.cotDetail
        let actual_uid = detail?.cotUid
        XCTAssertEqual(expected_uid, actual_uid)
    }
    
    func testProperlyCreatesCOTChatFromXML() {
        let expected = COTChat(
            id: "All Chat Rooms",
            chatroom: "All Chat Rooms",
            groupOwner: "false",
            parent: "RootContactGroup",
            senderCallsign: "JEXAMPLE-IPHONE",
            messageID: "E0777F3F-671A-4ACC-AE33-D7D996C52004"
        )
        let event = parser.parse(CHAT_EVENT)
        let detail = event?.cotDetail
        let actual = detail?.cotChat
        XCTAssertEqual(expected, actual)
    }
    
    func testProperlyCreatesCOTChatGroupFromXML() {
        let expected = COTChatGroup(
            uid0: "9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A",
            uid1: "All Chat Rooms",
            id: "All Chat Rooms"
        )
        let event = parser.parse(CHAT_EVENT)
        let detail = event?.cotDetail
        let chat = detail?.cotChat
        let actual = chat?.cotChatGroup
        XCTAssertEqual(expected, actual)
    }

    func testParsesExtraChatGroupMemberUids() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <event version="2.0" uid="GeoChat.SENDER.Group.MSG" type="b-t-f" how="h-g-i-g-o" time="2024-03-18T01:40:56Z"
            start="2024-03-18T01:40:56Z" stale="2024-03-18T01:42:56Z">
            <point lat="0" lon="0" hae="0" ce="9999999.0" le="9999999.0" />
            <detail>
                <__chat parent="UserGroups" groupOwner="true" messageId="MSG" chatroom="Squad" id="GROUP-ID" senderCallsign="ALPHA">
                    <chatgrp uid0="SENDER" uid1="PEER-1" uid2="PEER-2" id="GROUP-ID" />
                </__chat>
                <remarks source="BAO.F.TAKAware.SENDER" to="GROUP-ID" time="2024-03-18T01:40:56Z">Hi</remarks>
            </detail>
        </event>
        """
        let event = parser.parse(xml)
        let chatGroup = event?.cotDetail?.cotChat?.cotChatGroup
        XCTAssertEqual(chatGroup?.extraUids, ["PEER-2"])
        XCTAssertEqual(chatGroup?.memberUids, ["SENDER", "PEER-1", "PEER-2"])
    }

    func testParsesMartiDestinations() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <event version="2.0" uid="GeoChat.SENDER.PEER.MSG" type="b-t-f" how="h-g-i-g-o" time="2024-03-18T01:40:56Z"
            start="2024-03-18T01:40:56Z" stale="2024-03-18T01:42:56Z">
            <point lat="0" lon="0" hae="0" ce="9999999.0" le="9999999.0" />
            <detail>
                <__chat parent="RootContactGroup" groupOwner="false" messageId="MSG" chatroom="BRAVO" id="PEER" senderCallsign="ALPHA">
                    <chatgrp uid0="SENDER" uid1="PEER" id="PEER" />
                </__chat>
                <marti><dest uid="PEER" /><dest uid="PEER-2" /></marti>
                <remarks source="BAO.F.TAKAware.SENDER" to="PEER" time="2024-03-18T01:40:56Z">Hi</remarks>
            </detail>
        </event>
        """
        let event = parser.parse(xml)
        XCTAssertEqual(event?.cotDetail?.cotMarti?.destinations.compactMap(\.uid), ["PEER", "PEER-2"])
    }

    func testParsesChatHierarchyAndDeleteChild() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <event version="2.0" uid="GeoChat.SENDER.GROUP-ID.MSG" type="b-t-f" how="h-g-i-g-o" time="2024-03-18T01:40:56Z"
            start="2024-03-18T01:40:56Z" stale="2024-03-18T01:42:56Z">
            <point lat="0" lon="0" hae="0" ce="9999999.0" le="9999999.0" />
            <detail>
                <__chat parent="UserGroups" groupOwner="true" messageId="MSG" chatroom="Squad" id="GROUP-ID" senderCallsign="ALPHA">
                    <chatgrp uid0="SENDER" uid1="PEER-1" id="GROUP-ID" />
                    <hierarchy>
                        <group uid="RootContactGroup" name="Contacts">
                            <group uid="UserGroups" name="Groups">
                                <group uid="GROUP-ID" name="Squad" />
                            </group>
                        </group>
                    </hierarchy>
                    <deleteChild uid="PEER-2" chatroom="Squad" id="GROUP-ID" />
                </__chat>
                <remarks source="BAO.F.TAKAware.SENDER" to="GROUP-ID" time="2024-03-18T01:40:56Z"></remarks>
            </detail>
        </event>
        """
        let event = parser.parse(xml)
        XCTAssertEqual(event?.cotDetail?.cotChat?.hierarchy?.root.uid, "RootContactGroup")
        XCTAssertEqual(event?.cotDetail?.cotChat?.deleteChildren.first?.uid, "PEER-2")
    }
    
    func testProperlyCreatesCOTServerDestinationFromXML() {
        // <__serverdestination destinations="192.168.0.79:4242:tcp:9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A" />
        let expected = COTServerDestination(destinations: "192.168.0.79:4242:tcp:9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A"
        )
        let event = parser.parse(CHAT_EVENT)
        let detail = event?.cotDetail
        let actual = detail?.cotServerDestination
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTArchiveFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><archive /></detail></event>
"""
        let expected = COTArchive()
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotArchive
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTUserIconFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><usericon iconsetpath="SOME_ID/vehicles/truck.png" /></detail></event>
"""
        let expected = COTUserIcon(iconsetPath: "SOME_ID/vehicles/truck.png")
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotUserIcon
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTColorFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><color argb="-42" /></detail></event>
"""
        let expected = COTColor(argb: -42)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotColor
        XCTAssertEqual(expected, actual)
    }

    func testCOTColorFromXMLValueAttribute() {
        // ATAK routes/shapes emit `<color value="..."/>` (not `argb`).
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><color value="-65536" /></detail></event>
"""
        let expected = COTColor(argb: -65536)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotColor
        XCTAssertEqual(expected, actual)
    }

    func testCOTColorFromXMLPrefersArgbWhenBothPresent() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><color argb="-65536" value="-1" /></detail></event>
"""
        let expected = COTColor(argb: -65536)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotColor
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTVideoFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><__video url="rtsp://localhost/myfeed" /></detail></event>
"""
        let expected = COTVideo(baseUrl: "rtsp://localhost/myfeed")
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotVideo
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTVideoConnectionInfoFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><__video url="localhost:8554/myfeed" uid="30f3c0c5-11ec-455d-bf0b-d93f1ad14716"><ConnectionEntry networkTimeout="12000" uid="30f3c0c5-11ec-455d-bf0b-d93f1ad14716" path="/myfeed" protocol="rtsp" bufferTime="-1" address="localhost" port="8554" roverPort="-1" rtspReliable="0" ignoreEmbeddedKLV="false" alias="My Cool Cam" /></video></detail></event>
"""
        let expectedConnectionEntry = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let expectedVideo = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: expectedConnectionEntry)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotVideo
        XCTAssertEqual(expectedVideo, actual)
    }
    
    func testArchiveNodeFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><archive></archive></detail></event>
"""
        let tree = XMLHash.parse(archiveXML)
        XCTAssertNotNil(tree["event"]["detail"]["archive"].element)
        XCTAssertNil(tree["event"]["detail"]["archive2"].element)
    }
    
    func testProperlyCreatesCOTLinksFromXML() {
        let expected = COTLink(
            relation: "p-p",
            type: "a-f-G-E-V-C",
            uid: "9AEDF55F-FB33-44FD-9BF9-3F51605ADF6A"
        )
        let event = parser.parse(CHAT_EVENT)
        let detail = event?.cotDetail
        let actual = detail?.cotLinks?.first
        XCTAssertEqual(expected, actual)
    }
    
    func testProperlyCreatesMultipleCOTLinksFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><link point='38.838231810315555,-77.06616468204862' /><link point='38.83745360129687,-77.06579790102278' /></detail></event>
"""
        let expected1 = COTLink(
            point: "38.838231810315555,-77.06616468204862"
        )
        let expected2 = COTLink(
            point: "38.83745360129687,-77.06579790102278"
        )
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual1 = detail?.cotLinks?.first
        let actual2 = detail?.cotLinks?.last
        XCTAssertEqual(expected1, actual1)
        XCTAssertEqual(expected2, actual2)
    }
    
    func testProperlyCreatesCOTLinkWithEmbeddedLineAttribute() {
        let nested = "<?xml version='1.0' encoding='UTF-8' standalone='yes'?><event version='2.0' uid='stroke-1' type='u-d-f' time='2026-10-12T17:04:04.335Z' start='2026-10-12T17:04:04.335Z' stale='2026-10-13T17:04:04.335Z' how='h-e'><point lat='36.0' lon='-79.0' hae='0' ce='9999999' le='9999999'/><detail><link point='36.0,-79.0'/><link point='36.1,-79.1'/><contact callsign='Freehand 1'/></detail></event>"
        // Escape for embedding in double-quoted attribute via XML entity-style replacement in source string.
        let escapedNested = nested
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><link line="\(escapedNested)" /><link uid="ANDROID-1" type="a-f-G-U-C" relation="p-p" /></detail></event>
"""
        let event = parser.parse(archiveXML)
        let links = event?.cotDetail?.cotLinks ?? []
        XCTAssertEqual(2, links.count)
        XCTAssertFalse(links[0].line.isEmpty)
        XCTAssertTrue(links[0].line.contains("type='u-d-f'"))
        XCTAssertTrue(links[0].line.contains("Freehand 1"))
        XCTAssertEqual("p-p", links[1].relation)
        XCTAssertTrue(links[1].line.isEmpty)
    }

    func testCOTFillColorFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><fillColor value='-324'/></detail></event>
"""
        let expected = COTFillColor(value: -324)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotFillColor
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTLabelsOnFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><labels_on value='false'/></detail></event>
"""
        let expected = COTLabelsOn(value: false)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotLabelsOn
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTStrokeColorFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><strokeColor value='324'/></detail></event>
"""
        let expected = COTStrokeColor(value: 324)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotStrokeColor
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTStrokeWeightFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><strokeWeight value='4.0'/></detail></event>
"""
        let expected = COTStrokeWeight(value: 4.0)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let actual = detail?.cotStrokeWeight
        XCTAssertEqual(expected, actual)
    }
    
    func testCOTShapeFromXML() {
        let archiveXML = """
<?xml version="1.0" encoding="UTF-8" standalone="yes"?><event><detail><shape><ellipse major='226.98412686380018' minor='226.98412686380018' angle='360'/></shape></detail></event>
"""
        
        let expected = COTEllipse(major: 226.98412686380018, minor: 226.98412686380018, angle: 360)
        let event = parser.parse(archiveXML)
        let detail = event?.cotDetail
        let shape = detail?.cotShape
        let actual = shape?.cotEllipse
        XCTAssertEqual(expected, actual)
    }

    func testFileTransferAckRequestAndResponseFromXML() {
        let transferXML = """
        <?xml version="1.0" encoding="UTF-8"?>
        <event version="2.0" uid="xfer-1" type="b-f-t-r" how="h-e" time="2025-06-04T21:45:20Z" start="2025-06-04T21:45:20Z" stale="2025-06-04T21:45:30Z">
          <point lat="0" lon="0" hae="0" ce="9999999" le="9999999"/>
          <detail>
            <fileshare filename="pkg.zip" senderUrl="https://example/hash" sizeInBytes="12" sha256="abc" senderUid="SENDER" senderCallsign="Call" name="pkg.zip"/>
            <ackrequest uid="ack-1" ackrequested="true" tag="pkg.zip"/>
          </detail>
        </event>
        """
        let requestEvent = parser.parse(transferXML)
        XCTAssertEqual(requestEvent?.cotDetail?.cotAckRequest?.uid, "ack-1")
        XCTAssertEqual(requestEvent?.cotDetail?.cotAckRequest?.ackRequested, true)
        XCTAssertEqual(requestEvent?.cotDetail?.cotAckRequest?.tag, "pkg.zip")
        XCTAssertEqual(requestEvent?.cotDetail?.cotFileshare?.sha256, "abc")

        let ackXML = """
        <?xml version="1.0" encoding="UTF-8"?>
        <event version="2.0" uid="ack-event" type="b-f-t-a" how="h-e" time="2025-06-04T21:45:21Z" start="2025-06-04T21:45:21Z" stale="2025-06-04T21:45:31Z">
          <point lat="0" lon="0" hae="0" ce="9999999" le="9999999"/>
          <detail>
            <ackresponse uid="ack-1" senderUid="RECV" success="true" tag="pkg.zip" reason="" sha256="abc" sizeInBytes="12"/>
          </detail>
        </event>
        """
        let ackEvent = parser.parse(ackXML)
        let response = ackEvent?.cotDetail?.cotAckResponse
        XCTAssertEqual(response?.uid, "ack-1")
        XCTAssertEqual(response?.senderUid, "RECV")
        XCTAssertEqual(response?.success, true)
        XCTAssertEqual(response?.sha256, "abc")
        XCTAssertEqual(response?.sizeInBytes, "12")
    }
}

//
//  COTtoXMLTests.swift
//  
//
//  Created by Cory Foy on 10/9/23.
//

import XCTest

@testable import SwiftTAK

final class COToXMLTests: XCTestCase {
    func testCOTChatToXML() {
        let expected = "<__chat id='All Chat Rooms' chatroom='All Chat Rooms' groupOwner='TESTGO' parent='12345' senderCallsign='TRACKER-1' messageID='45678' ></__chat>"
        let cotChat = COTChat(id: "All Chat Rooms", chatroom: "All Chat Rooms", groupOwner: "TESTGO", parent: "12345", senderCallsign: "TRACKER-1", messageID: "45678")
        XCTAssertEqual(expected, cotChat.toXml())
    }
    
    func testCOTContactToXML() {
        let expected = "<contact endpoint='*:-1:stcp' phone='2125551212' callsign='TESTGO'></contact>"
        let cotContact = COTContact(endpoint: "*:-1:stcp", phone: "2125551212", callsign: "TESTGO")
        XCTAssertEqual(expected, cotContact.toXml())
    }
    
    func testCOTDetailToXML() {
        let expected = "<detail></detail>"
        let cotDetail = COTDetail()
        XCTAssertEqual(expected, cotDetail.toXml())
    }
    
    func testCOTEmergencyToXML() {
        let expected = "<emergency cancel='true' type='b-a-o-tbl'>TESTGO</emergency>"
        let cotEmergency = COTEmergency(cancel: true, type: EmergencyType.NineOneOne, callsign: "TESTGO")
        XCTAssertEqual(expected, cotEmergency.toXml())
    }
    
    func testCOTEventToXML() {
        let testDate = Date()
        let testStartDate = testDate.addingTimeInterval(5.0)
        let testStaleDate = testDate.addingTimeInterval(10.0)
        
        let expected = "<event version='2.0' uid='12345' type='a-f-g' how='m-g' time='\(ISO8601DateFormatter().string(from: testDate))' start='\(ISO8601DateFormatter().string(from: testStartDate))' stale='\(ISO8601DateFormatter().string(from: testStaleDate))'></event>"
        let cotEvent = COTEvent(version: "2.0", uid: "12345", type: "a-f-g", how: "m-g", time: testDate, start: testStartDate, stale: testStaleDate)
        XCTAssertEqual(expected, cotEvent.toXml())
    }
    
    func testCOTGroupToXML() {
        let expected = "<__group name='Cyan' role='Team Member'></__group>"
        let cotGroup = COTGroup(name: "Cyan", role: "Team Member")
        XCTAssertEqual(expected, cotGroup.toXml())
    }
    
    func testCOTLinkToXML() {
        let productionTime = ISO8601DateFormatter().string(from: Date())
        let expected = "<link parent_callsign='TESTGO2' production_time='\(productionTime)' relation='p-p' type='a-f-G' uid='12345' callsign='TESTGO' ></link>"
        let cotLink = COTLink(parentCallsign: "TESTGO2", productionTime: productionTime, relation: "p-p", type: "a-f-G", uid: "12345", callsign: "TESTGO")
        XCTAssertEqual(expected, cotLink.toXml())
    }
    
    func testCOTPointToXML() {
        let expected = "<point lat='31.5' lon='-71.5' hae='1.0' ce='2.0' le='3.0'></point>"
        let cotPoint = COTPoint(lat: "31.5", lon: "-71.5", hae: "1.0", ce: "2.0", le: "3.0")
        XCTAssertEqual(expected, cotPoint.toXml())
    }
    
    func testCOTRemarksToXML() {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let expected = "<remarks source='BAO.F.TRACKER' timestamp='\(timestamp)' >Test Message</remarks>"
        let cotRemarks = COTRemarks(source: "BAO.F.TRACKER", timestamp: timestamp, message: "Test Message")
        XCTAssertEqual(expected, cotRemarks.toXml())
    }
    
    func testCOTServerDestinationToXML() {
        let expected = "<__serverdestination destinations='192.168.79.115:4242:tcp'></__serverdestination>"
        let cotServerDestination = COTServerDestination(destinations: "192.168.79.115:4242:tcp")
        XCTAssertEqual(expected, cotServerDestination.toXml())
    }
    
    func testCOTStatusToXML() {
        let expected = "<status battery='55.0'></status>"
        let cotStatus = COTStatus(battery: "55.0")
        XCTAssertEqual(expected, cotStatus.toXml())
    }
    
    func testCOTTakVToXML() {
        let expected = "<takv device='iPhone' platform='Apple' os='iOS' version='17.0'></takv>"
        let cotTakV = COTTakV(device: "iPhone", platform: "Apple", os: "iOS", version: "17.0")
        XCTAssertEqual(expected, cotTakV.toXml())
    }
    
    func testCOTTrackToXML() {
        let expected = "<track speed='15.75' course='280.78'></track>"
        let cotTrack = COTTrack(speed: "15.75", course: "280.78")
        XCTAssertEqual(expected, cotTrack.toXml())
    }
    
    func testCOTUidToXML() {
        let expected = "<uid Droid='TESTGO'></uid>"
        let cotUid = COTUid(callsign: "TESTGO")
        XCTAssertEqual(expected, cotUid.toXml())
    }
}

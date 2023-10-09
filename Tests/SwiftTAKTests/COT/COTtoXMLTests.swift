//
//  COTtoXMLTests.swift
//  
//
//  Created by Cory Foy on 10/9/23.
//

import XCTest

@testable import SwiftTAK

final class COToXMLTests: XCTestCase {
    func testCOTChatToXML() throws {
        let expected = "<__chat id='All Chat Rooms' chatroom='All Chat Rooms' groupOwner='TESTGO' parent='12345' senderCallsign='TRACKER-1' messageID='45678' ></__chat>"
        let cotChat = COTChat(id: "All Chat Rooms", chatroom: "All Chat Rooms", groupOwner: "TESTGO", parent: "12345", senderCallsign: "TRACKER-1", messageID: "45678")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotChat.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTContactToXML() throws {
        let expected = "<contact endpoint='*:-1:stcp' phone='2125551212' callsign='TESTGO'></contact>"
        let cotContact = COTContact(endpoint: "*:-1:stcp", phone: "2125551212", callsign: "TESTGO")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotContact.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }

    func testCOTDetailToXML() throws {
        let expected = "<detail></detail>"
        let cotDetail = COTDetail()
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotDetail.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTDetailWithChildNodesToXML() throws {
        let expected = "<detail><contact callsign='TESTGO' endpoint='*:-1:stcp'></contact></detail>"
        let cotContact = COTContact(callsign: "TESTGO")
        var cotDetail = COTDetail()
        cotDetail.childNodes.append(cotContact)
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotDetail.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTEmergencyToXML() throws {
        let expected = "<emergency cancel='true' type='b-a-o-tbl'>TESTGO</emergency>"
        let cotEmergency = COTEmergency(cancel: true, type: EmergencyType.NineOneOne, callsign: "TESTGO")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotEmergency.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    //TODO: Implement Child Nodes
    func testCOTEventToXML() throws {
        let testDate = Date()
        let testStartDate = testDate.addingTimeInterval(5.0)
        let testStaleDate = testDate.addingTimeInterval(10.0)
        
        let expected = "<event version='2.0' uid='12345' type='a-f-g' how='m-g' time='\(ISO8601DateFormatter().string(from: testDate))' start='\(ISO8601DateFormatter().string(from: testStartDate))' stale='\(ISO8601DateFormatter().string(from: testStaleDate))'></event>"
        let cotEvent = COTEvent(version: "2.0", uid: "12345", type: "a-f-g", how: "m-g", time: testDate, start: testStartDate, stale: testStaleDate)
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotEvent.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTEventWithChildNodesToXML() throws {
        let testDate = Date()
        let testStartDate = testDate.addingTimeInterval(5.0)
        let testStaleDate = testDate.addingTimeInterval(10.0)
        let cotPoint = COTPoint(lat: "35.0", lon: "-71.5", hae: "1.0", ce: "2.0", le: "3.0")
        var cotEvent = COTEvent(version: "2.0", uid: "12345", type: "a-f-g", how: "m-g", time: testDate, start: testStartDate, stale: testStaleDate)
        cotEvent.childNodes.append(cotPoint)
        
        let expected = "<event version='2.0' uid='12345' type='a-f-g' how='m-g' time='\(ISO8601DateFormatter().string(from: testDate))' start='\(ISO8601DateFormatter().string(from: testStartDate))' stale='\(ISO8601DateFormatter().string(from: testStaleDate))'><point lat='35.0' lon='-71.5' hae='1.0' ce='2.0' le='3.0'></point></event>"
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotEvent.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTGroupToXML() throws {
        let expected = "<__group name='Cyan' role='Team Member'></__group>"
        let cotGroup = COTGroup(name: "Cyan", role: "Team Member")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotGroup.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTLinkToXML() throws {
        let productionTime = ISO8601DateFormatter().string(from: Date())
        let expected = "<link parent_callsign='TESTGO2' production_time='\(productionTime)' relation='p-p' type='a-f-G' uid='12345' callsign='TESTGO' ></link>"
        let cotLink = COTLink(parentCallsign: "TESTGO2", productionTime: productionTime, relation: "p-p", type: "a-f-G", uid: "12345", callsign: "TESTGO")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotLink.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTPointToXML() throws {
        let expected = "<point lat='31.5' lon='-71.5' hae='1.0' ce='2.0' le='3.0'></point>"
        let cotPoint = COTPoint(lat: "31.5", lon: "-71.5", hae: "1.0", ce: "2.0", le: "3.0")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotPoint.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTRemarksToXML() throws {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let expected = "<remarks source='BAO.F.TRACKER' timestamp='\(timestamp)' >Test Message</remarks>"
        let cotRemarks = COTRemarks(source: "BAO.F.TRACKER", timestamp: timestamp, message: "Test Message")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotRemarks.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTServerDestinationToXML() throws {
        let expected = "<__serverdestination destinations='192.168.79.115:4242:tcp'></__serverdestination>"
        let cotServerDestination = COTServerDestination(destinations: "192.168.79.115:4242:tcp")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotServerDestination.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTStatusToXML() throws {
        let expected = "<status battery='55.0'></status>"
        let cotStatus = COTStatus(battery: "55.0")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotStatus.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTTakVToXML() throws {
        let expected = "<takv device='iPhone' platform='Apple' os='iOS' version='17.0'></takv>"
        let cotTakV = COTTakV(device: "iPhone", platform: "Apple", os: "iOS", version: "17.0")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotTakV.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTTrackToXML() throws {
        let expected = "<track speed='15.75' course='280.78'></track>"
        let cotTrack = COTTrack(speed: "15.75", course: "280.78")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotTrack.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTUidToXML() throws {
        let expected = "<uid Droid='TESTGO'></uid>"
        let cotUid = COTUid(callsign: "TESTGO")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotUid.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
    
    func testCOTVideoToXML() throws {
        let expected = "<__video uid='12345' url='https://video.example.com/stream/cam1'></__video>"
        let cotVideo = COTVideo(url: "https://video.example.com/stream/cam1", uid: "12345")
        
        let expectedDoc = try XMLDocument(xmlString: expected)
        let actualDoc = try XMLDocument(xmlString: cotVideo.toXml())
        
        XCTAssertEqual(expectedDoc, actualDoc)
    }
}

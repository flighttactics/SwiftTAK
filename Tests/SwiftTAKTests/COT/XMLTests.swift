//
//  COTTests.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import XCTest

@testable import SwiftTAK

final class XMLTests: XCTestCase {
    
    var cotMessage: COTMessage?
    let positionInfo = COTPositionInformation(latitude: 0.0, longitude: 0.0)
    let callSign = "TEST-1"
    let group = "Cyan"
    let role = "Team Member"

    override func setUpWithError() throws {
        cotMessage = COTMessage()
    }
    
    func testSendingEmptyBatteryStringDoesNotInsertBatteryStatus() throws {
        let result = cotMessage!.generateCOTXml(positionInfo: positionInfo, callSign: callSign, group: group, role: role, phoneBatteryStatus: "")
        let actualDoc = try XMLDocument(xmlString: result)
        let batteryNode = try actualDoc.nodes(forXPath: "//status[@battery]")
        XCTAssert(batteryNode.isEmpty, "Battery Node was included with empty battery status")
    }
    
    func testGeneratingEmergencyAlertIncludesEmergencyNode() throws {
        let result = cotMessage!.generateEmergencyCOTXml(positionInfo: positionInfo, callSign: callSign, emergencyType: EmergencyType.NineOneOne, isCancelled: false)
        let actualDoc = try XMLDocument(xmlString: result)
        let emergencyNode = try actualDoc.nodes(forXPath: "//emergency[@cancel='false']").first! as? XMLElement
        let relationNode = try actualDoc.nodes(forXPath: "//link[@relation='p-p']")
        let contactNode = try actualDoc.nodes(forXPath: "//contact").first! as? XMLElement

        XCTAssert(emergencyNode != nil, "Emergency Node was not included")
        XCTAssertEqual("TEST-1-Alert", contactNode!.attribute(forName: "callsign")?.stringValue, "Alert callsign was not included")
        XCTAssertEqual(emergencyNode!.attribute(forName: "cancel")!.stringValue, "false")
        XCTAssert(!relationNode.isEmpty, "Link relation was not included")
    }
    
    func testGeneratingCancelledEmergencyProperlyAddsCancelledAttribute() throws {
        let result = cotMessage!.generateEmergencyCOTXml(positionInfo: positionInfo, callSign: callSign, emergencyType: EmergencyType.Cancel, isCancelled: true)
        let actualDoc = try XMLDocument(xmlString: result)
        let emergencyNode = try actualDoc.nodes(forXPath: "//emergency[@cancel='true']")
        XCTAssert(!emergencyNode.isEmpty, "Emergency cancelled status was not included")
    }
    
    func testGeneratingChatMessageWorks() throws {
        let result = cotMessage!.generateChatMessage(
            message: "Hello, World",
            sender: "TEST-TRACKER",
            destinationUrl: "127.0.0.1:4242")
        
        TAKLogger.debug(result)
        
        let actualDoc = try XMLDocument(xmlString: result)
        let chatNode = try actualDoc.nodes(forXPath: "//__chat").first! as! XMLElement
        let remarksNode = try actualDoc.nodes(forXPath: "//remarks").first! as! XMLElement
        
        XCTAssertEqual(chatNode.attribute(forName: "id")!.stringValue, "All Chat Rooms")
        XCTAssertEqual(chatNode.attribute(forName: "chatroom")!.stringValue, "All Chat Rooms")
        XCTAssertEqual(chatNode.attribute(forName: "senderCallsign")!.stringValue, "TEST-TRACKER")
        
        XCTAssertEqual(remarksNode.attribute(forName: "source")!.stringValue, "BAO.F.TAKTracker.TEST-TRACKER")
        XCTAssertEqual(remarksNode.stringValue, "Hello, World")
    }
}

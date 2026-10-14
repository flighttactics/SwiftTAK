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
        let result = cotMessage!.generateCOTXml(positionInfo: positionInfo, callSign: callSign, group: group, role: role, phone:"", phoneBatteryStatus: "")
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
        
        let chatGroupNode = try actualDoc.nodes(forXPath: "//chatgrp").first! as! XMLElement
        let eventNode = try actualDoc.nodes(forXPath: "//event").first! as! XMLElement
        let linkNode = try actualDoc.nodes(forXPath: "//link").first! as! XMLElement
        let eventUid = eventNode.attribute(forName: "uid")!.stringValue
        let senderUid = cotMessage!.deviceID

        XCTAssertEqual(remarksNode.attribute(forName: "source")!.stringValue, "BAO.F.TAKAware.\(senderUid)")
        XCTAssertEqual(remarksNode.attribute(forName: "to")!.stringValue, "All Chat Rooms")
        XCTAssertEqual(remarksNode.stringValue, "Hello, World")
        XCTAssertEqual(chatNode.attribute(forName: "parent")!.stringValue, "RootContactGroup")
        XCTAssertEqual(chatGroupNode.attribute(forName: "uid0")!.stringValue, senderUid)
        XCTAssertEqual(chatGroupNode.attribute(forName: "uid1")!.stringValue, "All Chat Rooms")
        XCTAssertEqual(linkNode.attribute(forName: "uid")!.stringValue, senderUid)
        XCTAssertTrue(eventUid.hasPrefix("GeoChat.\(senderUid).All Chat Rooms."))
    }

    func testGeneratingDirectChatIncludesMartiDest() throws {
        let result = cotMessage!.generateChatMessage(
            message: "Private ping",
            senderCallsign: "ALPHA",
            senderUid: "SENDER",
            conversationId: "PEER",
            chatroom: "BRAVO",
            memberUids: ["SENDER", "PEER"],
            messageID: "MSG-DM",
            destUids: ["PEER"]
        )
        XCTAssertTrue(result.contains("<marti"))
        XCTAssertTrue(result.contains("uid='PEER'") || result.contains("uid=\"PEER\""))
        XCTAssertTrue(result.contains("GeoChat.SENDER.PEER.MSG-DM"))
    }

    func testGeneratingGroupChatIncludesHierarchy() throws {
        let result = cotMessage!.generateChatMessage(
            message: "",
            senderCallsign: "ALPHA",
            senderUid: "SENDER",
            conversationId: "GROUP-ID",
            chatroom: "Squad",
            parent: TAKConstants.USER_GROUPS_PARENT,
            groupOwner: true,
            memberUids: ["SENDER", "PEER-1"],
            messageID: "MSG-G",
            destUids: ["PEER-1"],
            includeHierarchy: true
        )
        XCTAssertTrue(result.contains("<hierarchy"))
        XCTAssertTrue(result.contains("UserGroups"))
        XCTAssertTrue(result.contains("groupOwner='true'") || result.contains("groupOwner=\"true\""))
    }

    func testGeneratingChatMessageUsesStableConversationId() throws {
        let messageID = "11111111-1111-1111-1111-111111111111"
        let senderUid = "SENDER-UID"
        let result = cotMessage!.generateChatMessage(
            message: "Ping",
            senderCallsign: "ALPHA",
            senderUid: senderUid,
            conversationId: "All Chat Rooms",
            messageID: messageID
        )
        let actualDoc = try XMLDocument(xmlString: result)
        let eventNode = try actualDoc.nodes(forXPath: "//event").first! as! XMLElement
        XCTAssertEqual(
            eventNode.attribute(forName: "uid")!.stringValue,
            "GeoChat.\(senderUid).All Chat Rooms.\(messageID)"
        )
    }
}

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
    let latitude = "0.0"
    let longitude = "0.0"
    let callSign = "TEST-1"
    let group = "Cyan"
    let role = "Team Member"

    override func setUpWithError() throws {
        cotMessage = COTMessage()
    }
    
    func testSendingEmptyBatteryStringDoesNotInsertBatteryStatus() throws {
        let result = cotMessage!.generateCOTXml(latitude: latitude, longitude: longitude, callSign: callSign, group: group, role: role, phoneBatteryStatus: "")
        XCTAssert(!result.contains("battery"), "Battery Node was included with empty battery status")
    }
    
    func testGeneratingEmergencyAlertIncludesEmergencyNode() throws {
        let result = cotMessage!.generateEmergencyCOTXml(latitude: latitude, longitude: longitude, callSign: callSign, emergencyType: EmergencyType.NineOneOne, isCancelled: false)
        TAKLogger.debug(result)
        XCTAssert(result.contains("<emergency"), "Emergency Node was not included")
        XCTAssert(result.contains("cancel='false'"), "Emergency cancelled status was not included")
        XCTAssert(result.contains("TEST-1-Alert"), "Alert callsign was not included")
        XCTAssert(result.contains("relation='p-p'"), "Link relation was not included")
    }
    
    func testGeneratingCancelledEmergencyProperlyAddsCancelledAttribute() throws {
        let result = cotMessage!.generateEmergencyCOTXml(latitude: latitude, longitude: longitude, callSign: callSign, emergencyType: EmergencyType.Cancel, isCancelled: true)
        XCTAssert(result.contains("cancel='true'"), "Emergency cancelled status was not included")
    }
    
    func testGeneratingChatMessageWorks() throws {
        let result = cotMessage!.generateChatMessage(
            message: "Hello, World",
            sender: "TEST-TRACKER",
            destinationUrl: "127.0.0.1:4242")
        TAKLogger.debug(result)
        XCTAssert(result.contains("_chat id='All Chat Rooms' chatroom='All Chat Rooms'"))
        XCTAssert(result.contains("senderCallsign='TEST-TRACKER'"))
        XCTAssert(result.contains("remarks source"))
        XCTAssert(result.contains("Hello, World"))
    }
}

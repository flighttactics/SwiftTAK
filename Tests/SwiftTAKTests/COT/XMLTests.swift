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
}

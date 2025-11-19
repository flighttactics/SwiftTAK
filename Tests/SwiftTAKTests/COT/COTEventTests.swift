//
//  COTEventTests.swift
//
//
//  Created by Cory Foy on 8/20/24.
//

import XCTest

@testable import SwiftTAK

final class COTEventTests: XCTestCase {
    func testReturnsProperEventTypeFromType() {
        let cotType = "a-f-G"
        let expected = COTEventType.ATOM
        let cotEvent = COTEvent(version: "2.0", uid: "1234", type: cotType, how: "m-h", time: Date(), start: Date(), stale: Date())
        XCTAssertEqual(expected, cotEvent.eventType)
    }
    
    func testDefaultsEventTypeToCustomForUnknownTypes() {
        let cotType = "UNKNOWN"
        let expected = COTEventType.CUSTOM
        let cotEvent = COTEvent(version: "2.0", uid: "1234", type: cotType, how: "m-h", time: Date(), start: Date(), stale: Date())
        XCTAssertEqual(expected, cotEvent.eventType)
    }
    
    func testDefaultsEventTypeToCustomForEmptyTypes() {
        let cotType = ""
        let expected = COTEventType.CUSTOM
        let cotEvent = COTEvent(version: "2.0", uid: "1234", type: cotType, how: "m-h", time: Date(), start: Date(), stale: Date())
        XCTAssertEqual(expected, cotEvent.eventType)
    }
}

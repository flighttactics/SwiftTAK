//
//  File.swift
//  
//
//  Created by Cory Foy on 3/31/24.
//

import XCTest

@testable import SwiftTAK

class COTDateParserTests: SwiftTAKTestCase {
    
    let dateFormatter = ISO8601DateFormatter()
    
    override func setUp() async throws {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate]
    }
    
    func testHandlesStandardISO8601Format() {
        let dateString = "2024-03-11T12:43:51Z"
        let expected = dateFormatter.date(from: dateString)
        let actual = COTDateParser.parse(dateString)
        XCTAssertEqual(expected, actual)
        
    }
    
    func testHandlesFractionalSeconds() {
        let dateString = "2024-03-11T12:43:51.711Z"
        dateFormatter.formatOptions.update(with: .withFractionalSeconds)
        let expected = dateFormatter.date(from: dateString)
        let actual = COTDateParser.parse(dateString)
        XCTAssertEqual(expected, actual)
    }

    func testParseStaleAttributeUsesParsedDateWhenValid() {
        let dateString = "2024-03-11T13:23:13.000Z"
        let expected = dateFormatter.date(from: dateString)
        let actual = COTDateParser.parseStaleAttribute(dateString)
        XCTAssertEqual(expected, actual)
    }

    func testParseStaleAttributeReturnsNoExpirationWhenMissingOrInvalid() {
        XCTAssertEqual(COTDateParser.parseStaleAttribute(nil), COTDateParser.noExpirationStale)
        XCTAssertEqual(COTDateParser.parseStaleAttribute(""), COTDateParser.noExpirationStale)
        XCTAssertEqual(COTDateParser.parseStaleAttribute("   "), COTDateParser.noExpirationStale)
        XCTAssertEqual(COTDateParser.parseStaleAttribute("not-a-date"), COTDateParser.noExpirationStale)
    }
}

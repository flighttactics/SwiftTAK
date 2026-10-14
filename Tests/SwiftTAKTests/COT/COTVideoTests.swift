//
//  COTVideoTests.swift
//
//
//  Created by Cory Foy on 8/4/24.
//

import XCTest

@testable import SwiftTAK

final class COTVideoTests: XCTestCase {
    func testReturnsVideoURLFromVideoNodeWhenNoConnectionEntry() {
        let videoNode = COTVideo(baseUrl: "rtsp://localhost/myfeed")
        let expected = "rtsp://localhost/myfeed"
        XCTAssertEqual(expected, videoNode.url)
        XCTAssertEqual(.baseUrl, videoNode.resolvedStream.source)
    }

    func testEqualityNoConnectionEntry() {
        let videoNode1 = COTVideo(baseUrl: "rtsp://localhost/myfeed")
        let videoNode2 = COTVideo(baseUrl: "rtsp://localhost/myfeed")
        XCTAssertEqual(videoNode1, videoNode2)
    }

    func testInequalityNoConnectionEntry() {
        let videoNode1 = COTVideo(baseUrl: "rtsp://localhost/myfeed")
        let videoNode2 = COTVideo(baseUrl: "rtsp://localhost/myfeed2")
        XCTAssertNotEqual(videoNode1, videoNode2)
    }

    func testEqualityWithConnectionEntry() {
        let connectionEntry1 = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let videoNode1 = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: connectionEntry1)
        let connectionEntry2 = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let videoNode2 = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: connectionEntry2)
        XCTAssertEqual(videoNode1, videoNode2)
    }

    func testInequalityWithConnectionEntry() {
        let connectionEntry1 = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam 1", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let videoNode1 = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: connectionEntry1)
        let connectionEntry2 = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam 2", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let videoNode2 = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: connectionEntry2)
        XCTAssertNotEqual(videoNode1, videoNode2)
    }

    func testReturnsConcattedURLFromConnectionEntry() {
        let connectionEntry = COTConnectionEntry(uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", alias: "My Cool Cam", connectionProtocol: "rtsp", address: "localhost", port: 8554, path: "/myfeed", roverPort: -1, rtspReliable: 0, ignoreEmbeddedKLV: false, networkTimeout: 12000, bufferTime: -1)
        let videoNode = COTVideo(baseUrl: "localhost:8554/myfeed", uid: "30f3c0c5-11ec-455d-bf0b-d93f1ad14716", connectionEntry: connectionEntry)
        let expected = "rtsp://localhost:8554/myfeed"
        XCTAssertEqual(expected, videoNode.url)
        XCTAssertEqual(.connectionEntry, videoNode.resolvedStream.source)
        XCTAssertEqual(true, videoNode.resolvedStream.identitiesMatch)
    }

    func testPrefersAbsoluteBaseUrlOverConnectionEntry() {
        let connectionEntry = Self.fridlichEntry()
        let absoluteUrl = "rtsp://Fridlich:Fridlich@stream.sullivanny.gov:8554/SCPS-FRIDLICH-EM1?tcp"
        let videoNode = COTVideo(
            baseUrl: absoluteUrl,
            uid: "ICU-SCPS-FRIDLICH-EM1",
            connectionEntry: connectionEntry
        )
        XCTAssertEqual(absoluteUrl, videoNode.url)
        XCTAssertEqual(.baseUrl, videoNode.resolvedStream.source)
        XCTAssertEqual(true, videoNode.resolvedStream.identitiesMatch)
    }

    func testConnectionEntryUrlWithCredentialedAddress() {
        let connectionEntry = Self.fridlichEntry()
        XCTAssertEqual(
            "rtsp://Fridlich:Fridlich@stream.sullivanny.gov:8554/SCPS-FRIDLICH-EM1",
            connectionEntry.url
        )
        XCTAssertEqual("stream.sullivanny.gov", connectionEntry.host)
        XCTAssertEqual("Fridlich", connectionEntry.embeddedCredentials?.username)
        XCTAssertEqual("Fridlich", connectionEntry.embeddedCredentials?.password)
    }

    func testConnectionEntryUrlLeavesAbsoluteAddressAlone() {
        let absolute = "rtsp://camera.example.com:8554/live"
        let connectionEntry = COTConnectionEntry(
            uid: "cam-1",
            alias: "Cam",
            connectionProtocol: "rtsp",
            address: absolute,
            port: 8554,
            path: "/live",
            roverPort: -1,
            rtspReliable: 0,
            ignoreEmbeddedKLV: false,
            networkTimeout: 5000,
            bufferTime: -1
        )
        XCTAssertEqual(absolute, connectionEntry.url)
    }

    func testMergesConnectionEntryCredentialsIntoAbsoluteUrlWithoutAuth() {
        let entry = COTConnectionEntry(
            uid: "cam-1",
            alias: "Cam",
            connectionProtocol: "rtsp",
            address: "user:secret@camera.example.com",
            port: 8554,
            path: "/live",
            roverPort: -1,
            rtspReliable: 1,
            ignoreEmbeddedKLV: false,
            networkTimeout: 5000,
            bufferTime: -1
        )
        let video = COTVideo(
            baseUrl: "rtsp://camera.example.com:8554/live",
            uid: "cam-1",
            connectionEntry: entry
        )
        let resolved = video.resolvedStream
        XCTAssertEqual(.merged, resolved.source)
        XCTAssertEqual(true, resolved.identitiesMatch)
        XCTAssertTrue(resolved.url.contains("user:secret@camera.example.com"))
        XCTAssertTrue(resolved.url.hasPrefix("rtsp://"))
        XCTAssertTrue(resolved.url.contains(":8554/live"))
    }

    func testReportsIdentityMismatchButKeepsAbsoluteUrl() {
        let entry = COTConnectionEntry(
            uid: "cam-1",
            alias: "Cam",
            connectionProtocol: "rtsp",
            address: "other.example.com",
            port: 8554,
            path: "/other",
            roverPort: -1,
            rtspReliable: 0,
            ignoreEmbeddedKLV: false,
            networkTimeout: 5000,
            bufferTime: -1
        )
        let absolute = "rtsp://camera.example.com:8554/live"
        let video = COTVideo(baseUrl: absolute, uid: "cam-1", connectionEntry: entry)
        XCTAssertEqual(absolute, video.url)
        XCTAssertEqual(.baseUrl, video.resolvedStream.source)
        XCTAssertEqual(false, video.resolvedStream.identitiesMatch)
    }

    func testDoesNotOverrideExistingCredentialsOnAbsoluteUrl() {
        let entry = COTConnectionEntry(
            uid: "cam-1",
            alias: "Cam",
            connectionProtocol: "rtsp",
            address: "other:creds@camera.example.com",
            port: 8554,
            path: "/live",
            roverPort: -1,
            rtspReliable: 1,
            ignoreEmbeddedKLV: false,
            networkTimeout: 5000,
            bufferTime: -1
        )
        let absolute = "rtsp://user:pass@camera.example.com:8554/live"
        let video = COTVideo(baseUrl: absolute, uid: "cam-1", connectionEntry: entry)
        XCTAssertEqual(absolute, video.url)
        XCTAssertEqual(.baseUrl, video.resolvedStream.source)
    }

    private static func fridlichEntry() -> COTConnectionEntry {
        COTConnectionEntry(
            uid: "ICU-SCPS-FRIDLICH-EM1",
            alias: "SCPS-FRIDLICH-EM1",
            connectionProtocol: "rtsp",
            address: "Fridlich:Fridlich@stream.sullivanny.gov",
            port: 8554,
            path: "/SCPS-FRIDLICH-EM1",
            roverPort: -1,
            rtspReliable: 1,
            ignoreEmbeddedKLV: false,
            networkTimeout: 5000,
            bufferTime: -1
        )
    }
}

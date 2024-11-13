//
//  File.swift
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
    }
}

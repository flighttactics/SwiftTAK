//
//  DataPackageParserTests.swift
//  
//
//  Created by Cory Foy on 10/6/23.
//

import XCTest

@testable import SwiftTAK

final class DPAllFilesInRootTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_ALL_TOP
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    var dataPackageFileName: String = TestConstants.DP_ALL_TOP
    
    func testSetsBaseDirToEmptyStringWhenFilesInRoot() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual("", parser.packageContents.rootFolder, "Root folder not set properly")
    }
}

final class DPAllFilesInRootWithManifestTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_ALL_TOP_WITH_MANIFEST
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToEmptyStringWhenFilesInRootWithManifest() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual("", parser.packageContents.rootFolder, "Root folder not set properly")
    }
}

final class DPAllFilesInSubfolderTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_SUBFOLDER_ALL_TOP
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToFolderNameWhenFilesInSubfolder() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(TestConstants.DP_SUBFOLDER_NAME, parser.packageContents.rootFolder, "Root folder not set properly")
    }
}

final class DPAllFilesInSubfolderWithManifestTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_SUBFOLDER_WITH_MANIFEST
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToFolderNameWhenFilesInSubfolderWithManifest() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(TestConstants.DP_SUBFOLDER_WITH_MANIFEST_NAME, parser.packageContents.rootFolder, "Root folder not set properly")
    }
}

final class InvalidDataPackageTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_INVALID_ZIP
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToEmptyStringWithInvalidZip() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.rootFolder.isEmpty, "Root folder not set properly")
    }
    
    override func testLoadsServerCertificate() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        TAKLogger.debug(parser.packageContents.serverCertificate.count.description)
        TAKLogger.debug(Data().count.description)
        XCTAssertTrue(parser.packageContents.serverCertificate.isEmpty)
    }
    
    override func testLoadsServerCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.userCertificatePassword.isEmpty)
    }
    
    override func testLoadsUserCertificate() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.userCertificate.isEmpty)
    }
    
    override func testLoadsUserCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.userCertificatePassword.isEmpty)
    }
    
    override func testLoadsServerURL() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.serverURL.isEmpty)
    }
    
    override func testLoadsServerPort() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.serverPort.isEmpty)
    }
    
    override func testLoadsServerProtocol() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.serverProtocol.isEmpty)
    }
}

class DataPackageParserTests: XCTestCase {
    
    func dataPackageFilename() -> String {
        return ""
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(name: "Base Class Tests Excluded")
    }
    
    func loadParser(fileName: String, fileExtension: String) -> DataPackageParser {
        let archiveURL = Bundle.module.url(forResource: fileName, withExtension: fileExtension)!
        let parser = DataPackageParser.init(fileLocation: archiveURL)
        return parser
    }
    
    func testLoadsServerCertificate() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        TAKLogger.debug(parser.packageContents.serverCertificate.count.description)
        TAKLogger.debug(Data().count.description)
        XCTAssertFalse(parser.packageContents.serverCertificate.isEmpty)
    }
    
    func testLoadsServerCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageContents.userCertificatePassword, TestConstants.DEFAULT_CERT_PASSWORD)
    }
    
    func testLoadsUserCertificate() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertFalse(parser.packageContents.userCertificate.isEmpty)
    }
    
    func testLoadsUserCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageContents.userCertificatePassword, TestConstants.DEFAULT_CERT_PASSWORD)
    }
    
    func testLoadsServerURL() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageContents.serverURL, TestConstants.SERVER_URL)
    }
    
    func testLoadsServerPort() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageContents.serverPort, TestConstants.SERVER_PORT)
    }
    
    func testLoadsServerProtocol() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageContents.serverProtocol, TestConstants.SERVER_PROTOCOL)
    }
}

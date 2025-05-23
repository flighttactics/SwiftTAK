//
//  DataPackageParserTests.swift
//  
//
//  Created by Cory Foy on 10/6/23.
//

import XCTest

@testable import SwiftTAK

final class DPMultipleServerCertsATAKFormat: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_ATAK_MULTI_CERT
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testLoadsAllNonIdentityCertsAsServerCerts() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        let expectedCertificateCount = 2
        XCTAssertEqual(expectedCertificateCount, parser.packageContents.serverCertificates.count)
    }
    
    func testProperlyAssociatesCertsAndPasswords() throws {
        guard let rootCertURL = Bundle.module.url(forResource: TestConstants.ROOT_SERVER_CERTIFICATE_NAME, withExtension: TestConstants.CERTIFICATE_FILE_EXTENSION) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["FileError": "Could not open test server certificate"])
        }
        
        guard let intermediateCertURL = Bundle.module.url(forResource: TestConstants.SERVER_CERTIFICATE_NAME, withExtension: TestConstants.CERTIFICATE_FILE_EXTENSION) else {
            throw XCTestError(.failureWhileWaiting, userInfo: ["FileError": "Could not open test server certificate"])
        }
        
        let expectedRootCertData = try Data(contentsOf: rootCertURL)
        let expectedIntermediateCertData = try Data(contentsOf: intermediateCertURL)
        
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        let serverCerts = parser.packageContents.serverCertificates
        
        let rootCertPackage = serverCerts.first(where: {$0.certificatePassword == TestConstants.ROOT_SERVER_CERTFICATE_PASSWORD})
        let intermediateCertPackage = serverCerts.first(where: {$0.certificatePassword == TestConstants.DEFAULT_CERT_PASSWORD})
        
        XCTAssertNotNil(rootCertPackage)
        XCTAssertNotNil(intermediateCertPackage)
        
        XCTAssertEqual(expectedRootCertData, rootCertPackage!.certificateData)
        XCTAssertEqual(expectedIntermediateCertData, intermediateCertPackage!.certificateData)
        
    }
}

final class DPNonMatchingServerCertName: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_NON_MATCHING_CERT_NAME
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testLoadsAnyNonIdentityCertsAsServerCerts() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        let expectedCertificateCount = 1
        XCTAssertEqual(expectedCertificateCount, parser.packageContents.serverCertificates.count)
    }
    
    func testProperlyStoresTheConfiguredServerPasswordForAllServerCerts() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertFalse(parser.packageContents.serverCertificatePassword.isEmpty)
    }
}

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

final class DPAllFilesInSubfolderWithManifestButNoPrefsFileTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_SUBFOLDER_NO_PREFS_WITH_MANIFEST
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToFolderNameWhenFilesInSubfolderWithManifest() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(TestConstants.DP_SUBFOLDER_WITH_MANIFEST_NAME, parser.packageContents.rootFolder, "Root folder not set properly")
    }
    
    // None of these will pass because there's no prefs file
    override func testLoadsServerCertificatePassword() {}
    override func testLoadsUserCertificate() {}
    override func testLoadsUserCertificatePassword() {}
    override func testLoadsServerURL() {}
    override func testLoadsServerPort() {}
    override func testLoadsServerProtocol() {}
}

final class DPAllFilesInSubfolderWithSpacesWithManifestButNoPrefsFileTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_SUBFOLDER_SPACES_NO_PREFS_WITH_MANIFEST
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testSetsBaseDirToFolderNameWhenFilesInSubfolderWithManifest() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(TestConstants.DP_SUBFOLDER_WITH_SPACES_NAME, parser.packageContents.rootFolder, "Root folder not set properly")
    }
    
    // None of these will pass because there's no prefs file
    override func testLoadsServerCertificatePassword() {}
    override func testLoadsUserCertificate() {}
    override func testLoadsUserCertificatePassword() {}
    override func testLoadsServerURL() {}
    override func testLoadsServerPort() {}
    override func testLoadsServerProtocol() {}
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

final class LoadingOtherFilesFromPackageTests: DataPackageParserTests {
    override func dataPackageFilename() -> String {
        TestConstants.DP_MULTI_FILE_ZIP
    }
    
    override class var defaultTestSuite: XCTestSuite {
        XCTestSuite(forTestCaseClass: Self.self)
    }
    
    func testAddsNonCertificateFilesToFileStore() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageFiles.count > 0)
    }
    
    func testLoadsManifestConfigurationParameters() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertEqual(parser.packageConfiguration["uid"], "dc772639-f6f2-4bcc-88b5-1d841d91cd14")
        XCTAssertEqual(parser.packageConfiguration["name"], "TAK Manifest Test")
    }
    
    func testCapturesTheIgnoreFlag() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        let parsedFile = parser.packageFiles.first(where: {$0.fileLocation == "b442d62a63007b3f8562caeeb3bcbf37/startmap.kmz"})
        XCTAssertNotNil(parsedFile)
        XCTAssertFalse(parsedFile!.shouldIgnore)
    }
    
    func testIncludesAllParametersForTheFile() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        let parsedFile = parser.packageFiles.first(where: {$0.fileLocation == "b442d62a63007b3f8562caeeb3bcbf37/startmap.kmz"})
        XCTAssertNotNil(parsedFile)
        XCTAssertEqual(parsedFile?.parameters["name"], "startmap.kmz")
        XCTAssertEqual(parsedFile?.parameters["contentType"], "External GRG Data")
        XCTAssertEqual(parsedFile?.parameters["visible"], "true")
    }
    
    // This DP has no user or server certs in it, so override all these tests
    // We do want to leave them to make sure that nothing crashes dealing with them
    override func testLoadsServerCertificate() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.serverCertificates.isEmpty)
    }
    
    override func testLoadsServerCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(parser.packageContents.serverCertificates.isEmpty)
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

class DataPackageParserTests: SwiftTAKTestCase {
    
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
        XCTAssertFalse(parser.packageContents.serverCertificates.isEmpty)
    }
    
    func testLoadsServerCertificatePassword() {
        let parser = loadParser(fileName: dataPackageFilename(), fileExtension: TestConstants.DP_FILE_EXTENSION)
        parser.parse()
        XCTAssertTrue(
            [TestConstants.DEFAULT_CERT_PASSWORD, TestConstants.ROOT_SERVER_CERTFICATE_PASSWORD].contains(parser.packageContents.serverCertificates.first?.certificatePassword))
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

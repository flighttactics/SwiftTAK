//
//  ManifestParserTests.swift
//  SwiftTAK
//
//  Created by Cory Foy on 11/24/24.
//

import XCTest

@testable import SwiftTAK

class ManifestParserTests: SwiftTAKTestCase {
    let parser = ManifestParser()
    
    let manifestXml = """
<?xml version="1.0" encoding="UTF-8"?>
<MissionPackageManifest version="2">
   <Configuration>
      <Parameter name="uid" value="29b07d31-4842-4c18-9fe5-a7c1724ce892"/>
      <Parameter name="name" value="test-dp-shapes-routes"/>
   </Configuration>
   <Contents>
      <Content ignore="false" zipEntry="c073ad79-263d-417d-b66a-40593206086c/c073ad79-263d-417d-b66a-40593206086c.cot">
         <Parameter name="uid" value="c073ad79-263d-417d-b66a-40593206086c"/>
         <Parameter name="name" value="Drawing Circle 1"/>
      </Content>
      <Content ignore="false" zipEntry="b442d62a63007b3f8562caeeb3bcbf37/startmap.kmz">
         <Parameter name="name" value="startmap.kmz"/>
         <Parameter name="contentType" value="External GRG Data"/>
         <Parameter name="visible" value="true"/>
      </Content>
      <Content ignore="false" zipEntry="d3e82e80-8532-4880-a695-98079cea92fb/d3e82e80-8532-4880-a695-98079cea92fb.cot">
         <Parameter name="uid" value="d3e82e80-8532-4880-a695-98079cea92fb"/>
         <Parameter name="name" value="Test Point"/>
      </Content>
      <Content ignore="false" zipEntry="33d04f3e-8773-4f4a-bd5c-d21df217f818/33d04f3e-8773-4f4a-bd5c-d21df217f818.cot">
         <Parameter name="uid" value="33d04f3e-8773-4f4a-bd5c-d21df217f818"/>
         <Parameter name="name" value="Command Post"/>
      </Content>
      <Content ignore="false" zipEntry="fefee90c-9134-4cc8-90f1-2f815605d0a3/fefee90c-9134-4cc8-90f1-2f815605d0a3.cot">
         <Parameter name="uid" value="fefee90c-9134-4cc8-90f1-2f815605d0a3"/>
         <Parameter name="name" value="Drawing Circle 2"/>
      </Content>
      <Content ignore="false" zipEntry="92ba9fcc-8620-41e8-b8b4-b4f2376a7d2d/92ba9fcc-8620-41e8-b8b4-b4f2376a7d2d.cot">
         <Parameter name="uid" value="92ba9fcc-8620-41e8-b8b4-b4f2376a7d2d"/>
         <Parameter name="name" value="Shape 33"/>
      </Content>
      <Content ignore="false" zipEntry="f779406c-fe82-43fc-bcc6-226f14f24ea0/f779406c-fe82-43fc-bcc6-226f14f24ea0.cot">
         <Parameter name="uid" value="f779406c-fe82-43fc-bcc6-226f14f24ea0"/>
         <Parameter name="name" value="Route 4"/>
      </Content>
   </Contents>
</MissionPackageManifest>
"""
    
    override func setUp() async throws {
        let xmlParser = XMLParser(data: Data(manifestXml.utf8))
        xmlParser.delegate = parser
        xmlParser.parse()
    }
    
    func testLoadsParams() {
        XCTAssertEqual(parser.manifestConfiguration["uid"], "29b07d31-4842-4c18-9fe5-a7c1724ce892")
        XCTAssertEqual(parser.manifestConfiguration["name"], "test-dp-shapes-routes")
    }
    
    func testLoadsAllParamsForFileEntry() {
        let expectedFile = parser.dataPackageFiles.first(where: {$0.fileLocation == "b442d62a63007b3f8562caeeb3bcbf37/startmap.kmz"})
        XCTAssertEqual(expectedFile?.parameters["name"], "startmap.kmz")
        XCTAssertEqual(expectedFile?.parameters["contentType"], "External GRG Data")
        XCTAssertEqual(expectedFile?.parameters["visible"], "true")
    }
    
    func testImportsAllFilesInManifest() {
        let expectedFileCount = 7
        XCTAssertEqual(parser.dataPackageFiles.count, expectedFileCount)
    }
}

//
//  PreferencesParserTests.swift
//  SwiftTAK
//

import XCTest
@testable import SwiftTAK

final class PreferencesParserTests: XCTestCase {
    func testGroupsSuffixedCotStreamConnections() {
        let xml = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <preferences>
          <preference version="1" name="cot_streams">
            <entry key="count" class="class java.lang.Integer">2</entry>
            <entry key="description0" class="class java.lang.String">Primary</entry>
            <entry key="enabled0" class="class java.lang.Boolean">true</entry>
            <entry key="connectString0" class="class java.lang.String">10.0.0.1:8089:ssl</entry>
            <entry key="description1" class="class java.lang.String">Secondary</entry>
            <entry key="enabled1" class="class java.lang.Boolean">false</entry>
            <entry key="connectString1" class="class java.lang.String">10.0.0.2:8089:tcp</entry>
          </preference>
        </preferences>
        """
        let prefsParser = PreferencesParser()
        let xmlParser = XMLParser(data: Data(xml.utf8))
        xmlParser.delegate = prefsParser
        xmlParser.parse()

        let connections = prefsParser.preferences.cotStreamConnections()
        XCTAssertEqual(connections.count, 2)
        XCTAssertEqual(connections[0].host, "10.0.0.1")
        XCTAssertEqual(connections[0].port, "8089")
        XCTAssertEqual(connections[0].protocolName, "ssl")
        XCTAssertTrue(connections[0].enabled)
        XCTAssertEqual(connections[0].description, "Primary")
        XCTAssertEqual(connections[1].host, "10.0.0.2")
        XCTAssertEqual(connections[1].protocolName, "tcp")
        XCTAssertFalse(connections[1].enabled)
        XCTAssertEqual(connections[1].description, "Secondary")
    }

    func testBareEnabledFallsBackForStreamZero() {
        var prefs = TAKPreferences()
        prefs.entries["connectString0"] = "host.example:8089:ssl"
        prefs.entries["description0"] = "Host"
        prefs.entries["enabled"] = "false"
        prefs.serverEnabled = false

        let connections = prefs.cotStreamConnections()
        XCTAssertEqual(connections.count, 1)
        XCTAssertFalse(connections[0].enabled)
    }
}

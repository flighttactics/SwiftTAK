//
//  ConversionsTests.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import GeographicLib
import XCTest

@testable import SwiftTAK

final class ConversionsTests: XCTestCase {
    
    // Location converstions: Lat Long in MGRS, DMS
    // Heading Conversions: True North, Magnetic North - These are both provided automatically by LocationServices
    // Compass Conversions: Magnetic North, True North - These are both provided automatically by LocationServices
    // Speed Conversions: m/s, kph, fps, mph  - This comes from iOS as m/s
    
    let mockLatitude = 38.8856
    let mockLongitude = -76.9953
    let mockSpeedMetersPerSecond = 30.0
    
    func testLatLongToMGRS() {
        let expected = "18S UJ 26938 05973"
        let latitude = mockLatitude
        let longitude = mockLongitude
        let actualFromLib = GeographicLib.GeoCoords(latitude, longitude, 0).MGRSRepresentation(0)
        XCTAssertEqual(expected, Conversions.LatLongToMGRS(latitude: latitude, longitude: longitude))
    }
    
    func testLatitudeToDMS() {
        let latitude = mockLatitude
        XCTAssertEqual("N  38° 53' 08.160\"", Conversions.LatLonToDMS(latitude: latitude))
    }
    
    func testLongitudeToDMS() {
        let longitude = mockLongitude
        XCTAssertEqual("W  76° 59' 43.080\"", Conversions.LatLonToDMS(longitude: longitude))
    }
    
    func testSpeedToMetersPerSecond() {
        XCTAssertEqual("30", Conversions.convertToSpeedUnit(unit: SpeedUnit.MetersPerSecond, metersPerSecond: mockSpeedMetersPerSecond))
    }
    
    func testSpeedToKilomtersPerHour() {
        XCTAssertEqual("108", Conversions.convertToSpeedUnit(unit: SpeedUnit.KmPerHour, metersPerSecond: mockSpeedMetersPerSecond))
    }
    
    func testSpeedToFeetPerSecond() {
        XCTAssertEqual("98", Conversions.convertToSpeedUnit(unit: SpeedUnit.FeetPerSecond, metersPerSecond: mockSpeedMetersPerSecond))
    }
    
    func testSpeedToMilesPerHour() {
        XCTAssertEqual("67", Conversions.convertToSpeedUnit(unit: SpeedUnit.MilesPerHour, metersPerSecond: mockSpeedMetersPerSecond))
    }
    
    func testTogglingDMStoDecimal() {
        XCTAssertEqual(LocationUnit.Decimal, UnitOrder.nextLocationUnit(unit: LocationUnit.DMS))
    }
    
    func testTogglingDecimaltoDMS() {
        XCTAssertEqual(LocationUnit.DMS, UnitOrder.nextLocationUnit(unit: LocationUnit.Decimal))
    }
    
    
//    func testTogglingDMStoMGRS() {
//        XCTAssertEqual(LocationUnit.MGRS, UnitOrder.nextLocationUnit(unit: LocationUnit.DMS))
//    }
//
//    func testTogglingMGRStoDMS() {
//        XCTAssertEqual(LocationUnit.DMS, UnitOrder.nextLocationUnit(unit: LocationUnit.MGRS))
//    }
    
    func testTogglingMNtoTN() {
        XCTAssertEqual(DirectionUnit.TN, UnitOrder.nextDirectionUnit(unit: DirectionUnit.MN))
    }
    
    func testTogglingTNtoMN() {
        XCTAssertEqual(DirectionUnit.MN, UnitOrder.nextDirectionUnit(unit: DirectionUnit.TN))
    }
    
    func testTogglingSpeedUnitMStoKPH() {
        XCTAssertEqual(SpeedUnit.KmPerHour, UnitOrder.nextSpeedUnit(unit: SpeedUnit.MetersPerSecond))
    }
    
    func testTogglingSpeedUnitKPHtoFPS() {
        XCTAssertEqual(SpeedUnit.FeetPerSecond, UnitOrder.nextSpeedUnit(unit: SpeedUnit.KmPerHour))
    }
    
    func testTogglingSpeedUnitFPStoMPH() {
        XCTAssertEqual(SpeedUnit.MilesPerHour, UnitOrder.nextSpeedUnit(unit: SpeedUnit.FeetPerSecond))
    }
    
    func testTogglingSpeedUnitMPHtoMS() {
        XCTAssertEqual(SpeedUnit.MetersPerSecond, UnitOrder.nextSpeedUnit(unit: SpeedUnit.MilesPerHour))
    }
}


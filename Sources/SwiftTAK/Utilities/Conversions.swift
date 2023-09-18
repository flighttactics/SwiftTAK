//
//  Conversions.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public enum SpeedUnit {
    case MetersPerSecond
    case KmPerHour
    case FeetPerSecond
    case MilesPerHour
}

public enum LocationUnit {
    case DMS
    //case MGRS
    case Decimal
}

public enum DirectionUnit {
    case MN
    case TN
}

public struct UnitOrder {
    public static func nextSpeedUnit(unit:SpeedUnit) -> SpeedUnit {
        let order = [SpeedUnit.MetersPerSecond,
                     SpeedUnit.KmPerHour,
                     SpeedUnit.FeetPerSecond,
                     SpeedUnit.MilesPerHour]
        guard let currentPosition = order.firstIndex(of: unit) else {
            return unit
        }
        if(currentPosition+1 == order.count) {
            return order.first!
        } else {
            return order[order.index(after: currentPosition)]
        }
    }
    
    public static func nextLocationUnit(unit:LocationUnit) -> LocationUnit {
        switch unit {
        case LocationUnit.Decimal:
            return LocationUnit.DMS
        case LocationUnit.DMS:
            return LocationUnit.Decimal
        }
    }
    
    public static func nextDirectionUnit(unit:DirectionUnit) -> DirectionUnit {
        switch unit {
        case DirectionUnit.MN:
            return DirectionUnit.TN
        case DirectionUnit.TN:
            return DirectionUnit.MN
        }
    }
}

public class Conversions {
    
    public static func formatOrZero(item: Double?, formatter: String = "%.0f") -> String {
        guard let item = item else {
            return "0"
        }
        return String(format: formatter, item)
    }
    
    public static func convertToSpeedUnit(unit: SpeedUnit, metersPerSecond: Double) -> String {
        let numFeetInOneMeter = 3.281
        let numFeetInOneMile = 5280.0
        switch(unit) {
            case SpeedUnit.MetersPerSecond:
                return formatOrZero(item: metersPerSecond)
            case SpeedUnit.KmPerHour:
                let metersPerHour = metersPerSecond * 3600
                let metersToKm = metersPerHour / 1000
                return formatOrZero(item: metersToKm)
            case SpeedUnit.FeetPerSecond:
                return formatOrZero(item: metersPerSecond * numFeetInOneMeter)
            case SpeedUnit.MilesPerHour:
                let metersPerHour = metersPerSecond * 3600
                let feetPerHour = metersPerHour * numFeetInOneMeter
                let feetToMiles = feetPerHour / numFeetInOneMile
                return formatOrZero(item: feetToMiles)
        }
    }
    
    public static func LatLongToMGRS(latitude: Double, longitude: Double) -> String {
        return ""
    }
    
    public static func LatLonToDMS(latitude: Double) -> String {
        let direction = latitude > 0 ? "N" : "S"
        let unsignedDMS = ConvertToUnsignedDMS(latOrLong: latitude)
        return "\(direction)  \(unsignedDMS)"
    }
    
    public static func LatLonToDMS(longitude: Double) -> String {
        let direction = longitude > 0 ? "E" : "W"
        let unsignedDMS = ConvertToUnsignedDMS(latOrLong: longitude)
        return "\(direction)  \(unsignedDMS)"
    }
    
    public static func LatLonToDecimal(latitude: Double) -> String {
        return Conversions.formatOrZero(item: latitude, formatter: "%.4f")
    }
    
    public static func LatLonToDecimal(longitude: Double) -> String {
        return Conversions.formatOrZero(item: longitude, formatter: "%.4f")
    }
    
    public static func ConvertToUnsignedDMS(latOrLong: Double) -> String {
        let absDegrees = abs(latOrLong)
        let floorAbsDegrees = floor(absDegrees)
        
        let degrees = floorAbsDegrees
        let minutes = floor(60 * (absDegrees - floorAbsDegrees))
        let seconds = 3600 * (absDegrees - floorAbsDegrees) - (60 * minutes)
        return String(format: "%02.0f° %02.0f' %06.3f\"",
                             degrees, minutes, seconds)
    }
}

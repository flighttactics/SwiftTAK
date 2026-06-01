//
//  File.swift
//  
//
//  Created by Cory Foy on 3/31/24.
//

import Foundation

public class COTDateParser {
    public static func parse(_ dateString: String) -> Date? {
        var parsedDate: Date? = nil
        let standardFormat = Date.ISO8601FormatStyle()
        let fractionalSecondsFormat = Date.ISO8601FormatStyle()
            .dateSeparator(.dash)
            .timeSeparator(.colon)
            .year()
            .month()
            .day()
            .time(includingFractionalSeconds: true)
        
        parsedDate = try? Date(dateString, strategy: standardFormat)
        if(parsedDate != nil) { return parsedDate }
        
        parsedDate = try? Date(dateString, strategy: fractionalSecondsFormat)
        if(parsedDate != nil) { return parsedDate }
        
        return nil
    }
    
    public static func toTAKDateString(from date: Date) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
        return dateFormatter.string(from: date)
    }
}

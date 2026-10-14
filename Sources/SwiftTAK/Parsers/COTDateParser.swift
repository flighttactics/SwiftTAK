//
//  File.swift
//  
//
//  Created by Cory Foy on 3/31/24.
//

import Foundation

public class COTDateParser {
    /// Marker for XML CoT whose `stale` attribute was absent or not parseable.
    /// Ingest layers should treat this as “never auto-expire”.
    public static let noExpirationStale = Date.distantFuture

    /// Parses XML `stale`; missing or invalid values do not default to “stale now”.
    public static func parseStaleAttribute(_ rawValue: String?) -> Date {
        guard let rawValue else { return noExpirationStale }
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let parsed = parse(trimmed) else {
            return noExpirationStale
        }
        return parsed
    }

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

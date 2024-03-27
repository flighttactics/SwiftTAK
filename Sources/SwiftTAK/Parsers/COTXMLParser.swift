//
//  File.swift
//  
//
//  Created by Cory Foy on 3/27/24.
//

import Foundation
import SWXMLHash

class COTXMLParser {
    
    let dateFormatter = ISO8601DateFormatter()
    
    public init() {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
    }
    
    public func parse(_ cotxml: String) -> COTEvent? {
        let cot = XMLHash.parse(cotxml)
        
        guard let cotEvent = cot["event"].element else {
            return nil
        }
        
        let eventAttributes = cotEvent.allAttributes
        
        var event = COTEvent(version: eventAttributes["version"]?.text ?? "",
                        uid: eventAttributes["uid"]?.text ?? "",
                        type: eventAttributes["type"]?.text ?? "",
                        how: eventAttributes["how"]?.text ?? "",
                        time: dateFormatter.date(from: eventAttributes["time"]?.text ?? "") ?? Date(),
                        start: dateFormatter.date(from: eventAttributes["start"]?.text ?? "") ?? Date(),
                        stale: dateFormatter.date(from: eventAttributes["stale"]?.text ?? "") ?? Date())
        
        if let cotPoint = cot["event"]["point"].element {
            let pointAttributes = cotPoint.allAttributes
            
            let point = COTPoint(
                lat: pointAttributes["lat"]?.text ?? "0.0",
                lon: pointAttributes["lon"]?.text ?? "0.0",
                hae: pointAttributes["hae"]?.text ?? "999999.0",
                ce: pointAttributes["ce"]?.text ?? "999999.0",
                le: pointAttributes["le"]?.text ?? "999999.0")
            
            event.childNodes.append(point)
        }
        
        if let cotDetail = cot["event"]["detail"].element {
            let detail = COTDetail()
            event.childNodes.append(detail)
        }
        //Under Detail: Chat, Link, Remarks, ServerDestination
        
        return event
    }
}

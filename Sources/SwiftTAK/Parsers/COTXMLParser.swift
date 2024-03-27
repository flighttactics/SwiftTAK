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
        let cot = XMLHash.config {
            config in
                config.detectParsingErrors = true
        }.parse(cotxml)
        
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
            var detail = COTDetail()
            
            if let cotContact = cot["event"]["detail"]["contact"].element {
                let contactAttributes = cotContact.allAttributes
                let contact = COTContact(
                    endpoint: contactAttributes["endpoint"]?.text ?? COTContact.DEFAULT_ENDPOINT,
                    phone: contactAttributes["phone"]?.text ?? "",
                    callsign: contactAttributes["callsign"]?.text ?? ""
                )
                
                detail.childNodes.append(contact)
            }
            
            if let cotRemarks = cot["event"]["detail"]["remarks"].element {
                let remarksAttributes = cotRemarks.allAttributes
                let remarks = COTRemarks(
                    source: remarksAttributes["source"]?.text ?? "",
                    timestamp: remarksAttributes["time"]?.text ?? "",
                    message: cotRemarks.text,
                    to: remarksAttributes["to"]?.text ?? ""
                )
                
                detail.childNodes.append(remarks)
            }
            
            if let cotUid = cot["event"]["detail"]["uid"].element {
                let uidAttributes = cotUid.allAttributes
                var callsign = ""
                if(uidAttributes["callsign"] != nil) {
                    callsign = uidAttributes["callsign"]?.text ?? ""
                } else {
                    callsign = cot["event"]["detail"]["uid"]["Droid"].element?.text ?? ""
                }
                let uid = COTUid(
                    callsign: callsign
                )
                
                detail.childNodes.append(uid)
            }
            
            event.childNodes.append(detail)
        }
        
        return event
    }
}

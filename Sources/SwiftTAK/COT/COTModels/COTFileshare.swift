//
//  COTFileshare.swift
//  SwiftTAK
//
//  Created by Cory Foy on 1/5/26.
//

import Foundation

/*
 <event version= \"2.0\" uid= \"a3ff7c81-66ae-42ac-bede-a3b899fb9239\" type= \"b-f-t-r\" how= \"h-e\" time= \"2025-12-20T21:47:51Z\" start= \"2025-12-20T21:47:51Z\" stale= \"2025-12-20T21:48:01Z\" access= \"Undefined\">
     <point lat= \"36.046994\" lon= \"-79.177004\" hae= \"172.36799566\" ce= \"3.79009247\" le= \"NaN\" />
     <detail>
         <fileshare filename= \"CROWDRX_MAP_UPDATE.zip\" senderUrl= \"https://137.118.181.203:8443/Marti/sync/content?hash=fd40b4f891696108954a98ff1acf63566eb29c0442e81d38e6c1a860853471cd\" sizeInBytes= \"2168\" sha256= \"fd40b4f891696108954a98ff1acf63566eb29c0442e81d38e6c1a860853471cd\" senderUid= \"ANDROID-07b42ddf9728082d\" senderCallsign= \"NC-ORG-FT-FOYC\"
             name= \"CROWDRX_MAP_UPDATE.zip\" />
         <ackrequest uid= \"063766d8-d124-4e4a-a774-05fd0fb710de\" ackrequested= \"true\" tag= \"CROWDRX_MAP_UPDATE.zip\" />
         <_flow-tags_ TAK-Server-7e38d7c8805a4306bc5ab0a61ffec77d= \"2025-12-20T21:47:51Z\" />
     </detail>
 </event>
 */

public struct COTFileshare : COTNode, Equatable {
    public var fileName: String
    public var senderUrl: String
    public var sha256: String
    public var senderUid: String
    public var senderCallsign: String
    public var name: String
    public var sizeInBytes: String = "-1"
    
    public init(fileName: String, senderUrl: String, sha256: String, senderUid: String, senderCallsign: String, name: String, sizeInBytes: String) {
        self.fileName = fileName
        self.senderUrl = senderUrl
        self.sha256 = sha256
        self.senderUid = senderUid
        self.senderCallsign = senderCallsign
        self.name = name
        self.sizeInBytes = sizeInBytes
    }
    
    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["filename"] = fileName
        attrs["senderUrl"] = senderUrl
        attrs["sha256"] = sha256
        attrs["senderUid"] = senderUid
        attrs["senderCallsign"] = senderCallsign
        attrs["name"] = name
        attrs["sizeInBytes"] = sizeInBytes
        return COTXMLHelper.generateXML(nodeName: "fileshare", attributes: attrs, message: "")
    }
    
    public static func == (lhs: COTFileshare, rhs: COTFileshare) -> Bool {
        return lhs.sha256 == rhs.sha256
    }
}

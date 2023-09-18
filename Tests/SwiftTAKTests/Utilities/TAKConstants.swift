//
//  TAKConstants.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

struct TAKConstants {    
    // Ports
    static let DEFAULT_CSR_PORT = "8446"
    static let DEFAULT_WEB_PORT = "8443"
    static let DEFAULT_STREAMING_PORT = "8089"
    
    // Paths
    static let MANIFEST_FILE = "manifest.xml"
    static let PREF_FILE_SUFFIX = ".pref"
    
    static let CERT_CONFIG_PATH = "/Marti/api/tls/config"
    static let CSR_PATH = "/Marti/api/tls/signClient/v2?clientUid=$UID&version=$VERSION"
    
    // Helper Functions
    static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
}

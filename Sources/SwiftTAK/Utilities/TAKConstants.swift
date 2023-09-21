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
    static let UDP_BROADCAST_PORT = "6969"
    
    // Paths
    static let MANIFEST_FILE = "manifest.xml"
    static let PREF_FILE_SUFFIX = ".pref"
    
    static let CERT_CONFIG_PATH = "/Marti/api/tls/config"
    static let CSR_PATH = "/Marti/api/tls/signClient/v2?clientUid=$UID&version=$VERSION"
    
    static let UDP_BROADCAST_URL = "239.2.3.1"
    
    static let TEAM_COLORS = [
        "Blue",
        "Dark Blue",
        "Brown",
        "Cyan",
        "Green",
        "Dark Green",
        "Magenta",
        "Maroon",
        "Orange",
        "Purple",
        "Red",
        "Teal",
        "White",
        "Yellow"
    ]
    
    static let TEAM_ROLES = [
        "Team Member",
        "Team Lead",
        "HQ",
        "Sniper",
        "Medic",
        "Forward Observer",
        "RTO",
        "K9"
    ]
    
    // Helper Functions
    static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
}

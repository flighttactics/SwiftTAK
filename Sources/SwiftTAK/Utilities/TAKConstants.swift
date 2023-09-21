//
//  TAKConstants.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public struct TAKConstants {
    // Ports
    public static let DEFAULT_CSR_PORT = "8446"
    public static let DEFAULT_WEB_PORT = "8443"
    public static let DEFAULT_STREAMING_PORT = "8089"
    public static let UDP_BROADCAST_PORT = "6969"
    
    // Paths
    public static let MANIFEST_FILE = "manifest.xml"
    public static let PREF_FILE_SUFFIX = ".pref"
    
    public static let CERT_CONFIG_PATH = "/Marti/api/tls/config"
    public static let CSR_PATH = "/Marti/api/tls/signClient/v2?clientUid=$UID&version=$VERSION"
    
    public static let UDP_BROADCAST_URL = "239.2.3.1"
    
    public static let TEAM_COLORS = [
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
    
    public static let TEAM_ROLES = [
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
    public static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
}

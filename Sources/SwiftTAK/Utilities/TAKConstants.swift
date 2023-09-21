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
    
    public static let TEAM_COLORS = TeamColor.allCases.map { $0.rawValue }
    public static let TEAM_ROLES = TeamRole.allCases.map { $0.rawValue }
    public static let UNIT_TYPES = UnitType.allCases.map { $0.rawValue }
    
    // Helper Functions
    public static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
}

public enum TeamRole: String, CaseIterable {
    case TeamMember = "Team Member"
    case TeamLead = "Team Lead"
    case HQ = "HQ"
    case Sniper = "Sniper"
    case Medic = "Medic"
    case ForwardObserver = "Forward Observer"
    case RTO = "RTO"
    case K9 = "K9"
}

public enum TeamColor: String, CaseIterable {
    case Blue = "Blue"
    case DarkBlue = "Dark Blue"
    case Brown = "Brown"
    case Cyan = "Cyan"
    case Green = "Green"
    case DarkGreen = "Dark Green"
    case Magenta = "Magenta"
    case Maroon = "Maroon"
    case Orange = "Orange"
    case Purple = "Purple"
    case Red = "Red"
    case Teal = "Teal"
    case White = "White"
    case Yellow = "Yellow"
}

public enum UnitType: String, CaseIterable {
    case Ground = "Ground"
    case Air = "Air"
    case Sea = "Sea"
}

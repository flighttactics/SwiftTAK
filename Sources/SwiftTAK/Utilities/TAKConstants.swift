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
    public static let CHAT_UDP_BROADCAST_PORT = "17012"
    public static let CHAT_TCP_BROADCAST_PORT = "4242"
    
    // Paths
    public static let MANIFEST_FILE = "manifest.xml"
    public static let PREF_FILE_SUFFIX = ".pref"
    
    public static let CERT_CONFIG_PATH = "/Marti/api/tls/config"
    public static let CSR_PATH = "/Marti/api/tls/signClient/v2?clientUid=$UID&version=$VERSION"
    
    public static let UDP_BROADCAST_URL = "239.2.3.1"
    public static let CHAT_UDP_BROADCAST_URL = "224.10.10.1"
    
    // Other constants
    public static let DEFAULT_CHATROOM_NAME = "All Chat Rooms"
    
    // Handy string array representations of some of the enums
    public static let TEAM_COLORS = TeamColor.allCases.map { $0.rawValue }
    public static let TEAM_ROLES = TeamRole.allCases.map { $0.rawValue }
    public static let UNIT_TYPES = UnitType.allCases.map { $0.rawValue }
    public static let EMERGENCY_TYPES = EmergencyType.allCases.map { $0.rawValue }
    
    // Helper Functions
    public static func certificateSigningPath(clientUid: String, appVersion: String) -> String {
        return TAKConstants.CSR_PATH
            .replacingOccurrences(of: "$UID", with: clientUid)
            .replacingOccurrences(of: "$VERSION", with: appVersion)
    }
}

public enum TeamRole: String, CaseIterable, Identifiable {
    case TeamMember = "Team Member"
    case TeamLead = "Team Lead"
    case HQ = "HQ"
    case Sniper = "Sniper"
    case Medic = "Medic"
    case ForwardObserver = "Forward Observer"
    case RTO = "RTO"
    case K9 = "K9"
    
    public var id: Self { self }
}

public enum TeamColor: String, CaseIterable, Identifiable {
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
    
    public var id: Self { self }
}

public enum UnitType: String, CaseIterable, Identifiable {
    case Ground = "Ground"
    case Air = "Air"
    case Sea = "Sea"
    
    public var id: Self { self }
}

public enum EmergencyType: String, CaseIterable, CustomStringConvertible, Identifiable {
    case NineOneOne = "911 Alert"
    case Cancel = "Cancel Alert"
    case Geofence = "Geo-fence Breached"
    case RingTheBell = "Ring The Bell"
    case InContact = "In Contact"
    
    public var description: String {
        switch self {
        case .NineOneOne: return "b-a-o-tbl"
        case .Cancel: return "b-a-o-can"
        case .Geofence: return "b-a-g"
        case .RingTheBell: return "b-a-o-pan"
        case .InContact: return "b-a-o-opn"
        }
    }
    
    public var id: Self { self }
}

public enum HowType: String, CaseIterable, Identifiable {
    case HumanEstimated = "h-e"
    case HumanCalculated = "h-c"
    case HumanTranscribed = "h-t"
    case HumanCutAndPaste = "h-p"
    case HumanGIGO = "h-g-i-g-o"
    case MachineGPSDerived = "m-g"
    case MachineGPSDerivedAugmented = "m-g-n"
    case MachineGPSDerivedDifferential = "m-g-d"
    case MachineMensurated = "m-i"
    case MachineMagnetic = "m-m"
    case MachineIns = "m-n"
    case MachineSimulated = "m-s"
    case MachineConfigured = "m-c"
    case MachineRelated = "m-r"
    case MachinePassed = "m-p"
    case MachineFused = "m-f"
    case MachineAlgorithmic = "m-a"
    case MachineLaserDesignated = "m-l"
    case MachineRadioEPLRS = "m-R-e"
    case MachineRadioPLRS = "m-R-p"
    case MachineRadioDoppler = "m-R-d"
    case MachineRadioVHF = "m-R-v"
    case MachineRadioTadil = "m-R-t"
    case MachineRadioTadilA = "m-R-t-a"
    case MachineRadioTadilB = "m-R-t-b"
    case MachineRadioTadilJ = "m-R-t-j"
    
    public var id: Self { self }
}

public enum LinkType: String, CaseIterable, Identifiable {
    case ParentProducer = "p-p"
    case ParentOwner = "p-o"
    case ParentManager = "p-m"
    case ParentLeader = "p-l"
    case ChildCorrelated = "c-c"
    case ChildFused = "c-f"
    case ChildAlternate = "c-a"
    case RefinementAmplification = "r-a"
    case RefinementUrl = "r-u"
    case TaskingObject = "t-o"
    case TaskingIndirect = "t-i"
    case TaskingSubject = "t-s"
    case TaskingPreposition = "t-p"
    case TaskingPrepositionAt = "t-p-a"
    case TaskingPrepositionBy = "t-p-b"
    case TaskingPrepositionWith = "t-p-w"
    case TaskingPrepositionFrom = "t-p-f"
    case TaskingPrepositionRegarding = "t-p-r"
    case TaskingPrepositionVia = "t-p-v"
    
    public var id: Self { self }
}

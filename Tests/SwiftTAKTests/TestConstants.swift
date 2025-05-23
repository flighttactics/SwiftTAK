//
//  TestConstants.swift
//  
//
//  Created by Cory Foy on 10/7/23.
//

public struct TestConstants {
    
    // Data Package Test Files
    static let DP_ALL_TOP = "tak-all-top"
    static let DP_SUBFOLDER_ALL_TOP = "tak-subfolder-all-top"
    static let DP_ALL_TOP_WITH_MANIFEST = "tak-all-top-with-manifest-folder"
    static let DP_SUBFOLDER_WITH_MANIFEST = "tak-subfolder-with-manifest-folder"
    static let DP_SUBFOLDER_NO_PREFS_WITH_MANIFEST = "tak-subfolder-no-prefs-with-manifest-folder"
    static let DP_SUBFOLDER_SPACES_NO_PREFS_WITH_MANIFEST = "tak-subfolder-spaces-no-prefs-with-manifest-folder"
    static let DP_NO_MANIFEST = "tak-no-manifest"
    static let DP_INVALID_ZIP = "invalid-data-package-zip"
    static let DP_MULTI_FILE_ZIP = "multifile-data-package-zip"
    static let DP_ATAK_MULTI_CERT = "tak-multi-cert-atak-format"
    static let DP_NON_MATCHING_CERT_NAME = "tak-non-matching-cert-name"
    static let DP_FILE_EXTENSION = "zip"
    
    // Data Package Testing Constants
    static let DP_SUBFOLDER_NAME = "rpi-tak"
    static let DP_SUBFOLDER_WITH_MANIFEST_NAME = "rpi-manifest"
    static let DP_SUBFOLDER_WITH_SPACES_NAME = "rpi manifest. 20"
    static let SERVER_CERTIFICATE_NAME = "truststore-intermediate"
    static let ROOT_SERVER_CERTIFICATE_NAME = "truststore-root"
    static let ROOT_SERVER_CERTFICATE_PASSWORD = "taktak"
    static let USER_CERTIFICATE_NAME = "user"
    static let PREF_FILE_NAME = "tak-server"
    static let CERTIFICATE_FILE_EXTENSION = "p12"
    static let DEFAULT_CERT_PASSWORD = "atakatak"
    static let SERVER_URL = "192.168.0.49"
    static let SERVER_PORT = "8089"
    static let SERVER_PROTOCOL = "ssl"
}

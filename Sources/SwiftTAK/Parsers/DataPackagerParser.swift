//
//  DataPackagerParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation
import ZIPFoundation

class DataPackageParser: NSObject {
    
    let MANIFEST_FILE = "manifest.xml"
    var dataPackageContents: [String] = []
    
    var archiveLocation: URL?
    
    init (fileLocation:URL) {
        TAKLogger.debug("[DataPackageParser]: Initializing")
        archiveLocation = fileLocation
        super.init()
    }
    
    func parse() {
        processArchive()
    }

    func processArchive() {
        TAKLogger.debug("[DataPackageParser]: Entering processArchive")
        guard let sourceURL = archiveLocation
        else {
            TAKLogger.error("[DataPackageParser]: Unable to access sourceURL variable \(String(describing: archiveLocation))")
            return
        }

        guard let archive = Archive(url: sourceURL, accessMode: .read)
        else {
            TAKLogger.error("[DataPackageParser]: Unable to access archive at location \(String(describing: archiveLocation))")
            return
        }
        
        TAKLogger.debug("[DataPackageParser]: Files in archive")
        dataPackageContents = archive.map { entry in
            return entry.path
        }
        TAKLogger.debug("[DataPackageParser]: " + String(describing: dataPackageContents))
        
        let prefsFile = retrievePrefsFile(archive: archive)
        let prefs = parsePrefsFile(archive: archive, prefsFile: prefsFile)
        storeUserCertificate(archive: archive, prefs: prefs)
        storeServerCertificate(archive: archive, prefs: prefs)
        storePreferences(preferences: prefs)
        TAKLogger.debug("[DataPackageParser]: processArchive Complete")
    }
    
    func storeUserCertificate(archive: Archive, prefs: TAKPreferences) {
        let fileName = prefs.userCertificateFileName()
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("[DataPackageParser]: userCertificate \(fileName) not found in archive"); return }

        var certData = Data()
        _ = try? archive.extract(certFile) { data in
            certData.append(data)
        }
        //SettingsStore.global.userCertificate = certData
        TAKLogger.debug("[DataPackageParser]: Storing User Certificate")
        TAKLogger.debug("[DataPackageParser]: " + String(describing: certData))
        
        //Parse the cert file
        let parsedCert = PKCS12(data: certData, password: prefs.userCertificatePassword)
        
        guard let identity = parsedCert.identity else {
            TAKLogger.error("[DataPackageParser]: Identity was not present in the parsed cert")
            return
        }
        
        // TODO: Keychain interface abstraction needed
//        SettingsStore.global.storeIdentity(identity: identity, label: prefs.serverConnectionAddress())
        
        TAKLogger.debug("[DataPackageParser]: User Certificate Stored")
    }
    
    func storeServerCertificate(archive: Archive, prefs: TAKPreferences) {
        let fileName = prefs.serverCertificateFileName()
        guard let certFile = archive[fileName]
        else { TAKLogger.debug("[DataPackageParser]: serverCertificate \(fileName) not found in archive"); return }

        var certData = Data()
        _ = try? archive.extract(certFile) { data in
            certData.append(data)
        }
        
        // TODO: Store this in the keychain
//        SettingsStore.global.serverCertificate = certData
    }
    
    func storePreferences(preferences: TAKPreferences) {
        // TODO: Where are we going to store these?
//        SettingsStore.global.userCertificatePassword = preferences.userCertificatePassword
//        SettingsStore.global.serverCertificatePassword = preferences.serverCertificatePassword
//
//        SettingsStore.global.takServerUrl = preferences.serverConnectionAddress()
//        SettingsStore.global.takServerPort = preferences.serverConnectionPort()
//        SettingsStore.global.takServerProtocol = preferences.serverConnectionProtocol()
        
        // TODO: Callbacks when things have changed the app should know about
//        SettingsStore.global.takServerChanged = true
    }
    
    func parsePrefsFile(archive:Archive, prefsFile: String) -> TAKPreferences {
        let prefsParser = PreferencesParser()
        
        guard let prefFile = archive[prefsFile]
        else { TAKLogger.debug("[DataPackageParser]: prefFile not in archive"); return prefsParser.preferences }

        var prefData = Data()
        _ = try? archive.extract(prefFile) { data in
            prefData.append(data)
        }
        let xmlParser = XMLParser(data: prefData)
        xmlParser.delegate = prefsParser
        xmlParser.parse()
        return prefsParser.preferences
    }
    
    func retrievePrefsFile(archive:Archive) -> String {
        var prefsFile = ""
        
        if let prefFileLocation = dataPackageContents.first(where: {
            $0.hasSuffix(".pref")
        }) {
            prefsFile = prefFileLocation
        } else {
            guard let takManifest = archive["manifest.xml"]
            else { return prefsFile }

            var manifestData = Data()
            _ = try? archive.extract(takManifest) { data in
                manifestData.append(data)
            }
            let xmlParser = XMLParser(data: manifestData)
            let manifestParser = ManifestParser()
            xmlParser.delegate = manifestParser
            xmlParser.parse()
            TAKLogger.debug("[DataPackageParser]: Prefs file: \(manifestParser.prefsFile())")
            prefsFile = manifestParser.prefsFile()
        }
        return prefsFile
    }

}

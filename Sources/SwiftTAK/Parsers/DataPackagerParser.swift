//
//  DataPackagerParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation
import ZIPFoundation

public struct DataPackageContents {
    public var rootFolder: String = ""
    public var userCertificate: Data = Data()
    public var userCertificatePassword: String = ""
    public var serverCertificate: Data = Data()
    public var serverCertificatePassword: String = ""
    public var serverURL: String = ""
    public var serverPort: String = ""
    public var serverProtocol: String = ""
    
    public init() {}
}

public class DataPackageParser: NSObject {
    
    public var packageContents = DataPackageContents()
    var archive: Archive?
    
    let MANIFEST_FILE = "manifest.xml"
    var dataPackageContents: [String] = []
    
    var archiveLocation: URL?
    
    public init (fileLocation: URL) {
        TAKLogger.debug("[DataPackageParser]: Initializing")
        archiveLocation = fileLocation
        super.init()
    }
    
    public func parse() {
        processArchive()
    }
    
    func retrieveFileFromArchive(fileName: String) -> Data {
        var fileLocation = fileName
        
        var fileData = Data()
        guard let archive = archive else {
            TAKLogger.error("[DataPackageParser]: retrieveFileFromArchive tried to retrieve from an invalid data package")
            return fileData
        }
        
        let pathComponents = fileLocation.split(separator: "/")
        
        if(!packageContents.rootFolder.isEmpty) {
            if(pathComponents.count > 1 && pathComponents.first! == packageContents.rootFolder) {
                TAKLogger.debug("[DataPackageParser]: Not applying a root folder since it appears to already be in place")
            } else {
                let root = packageContents.rootFolder
                fileLocation = root.appending("/").appending(fileLocation)
            }
        }
        
        TAKLogger.debug("[DataPackageParser]: Attempting to load \(fileLocation) from archive")
        guard let fileEntry = archive[fileLocation]
        else { TAKLogger.debug("[DataPackageParser]: file \(fileLocation) not found in archive"); return fileData }
        
        _ = try? archive.extract(fileEntry) { data in
            fileData.append(data)
        }

        return fileData
    }

    func processArchive() {
        TAKLogger.debug("[DataPackageParser]: Entering processArchive")
        guard let sourceURL = archiveLocation
        else {
            TAKLogger.error("[DataPackageParser]: Unable to access sourceURL variable \(String(describing: archiveLocation))")
            return
        }
        
        archive = Archive(url: sourceURL, accessMode: .read)

        guard archive != nil
        else {
            TAKLogger.error("[DataPackageParser]: Unable to access archive at location \(String(describing: archiveLocation))")
            return
        }
        
        TAKLogger.debug("[DataPackageParser]: Files in archive")
        dataPackageContents = archive!.map { entry in
            return entry.path
        }
        TAKLogger.debug("[DataPackageParser]: " + String(describing: dataPackageContents))
        
        let prefsFile = retrievePrefsFile(archive: archive!)
        storeRootDirectory(prefsFileLocation: prefsFile)
        let prefs = parsePrefsFile(archive: archive!, prefsFile: prefsFile)
        storeUserCertificate(archive: archive!, prefs: prefs)
        storeServerCertificate(archive: archive!, prefs: prefs)
        storePreferences(preferences: prefs)
        TAKLogger.debug("[DataPackageParser]: processArchive Complete")
    }
    
    func storeRootDirectory(prefsFileLocation: String) {
        let pathComponents = prefsFileLocation.split(separator: "/")
        if(pathComponents.count > 1) {
            packageContents.rootFolder = String(pathComponents.first!)
        }
    }
    
    func storeUserCertificate(archive: Archive, prefs: TAKPreferences) {
        let certData = retrieveFileFromArchive(fileName: prefs.userCertificateFileName())
        packageContents.userCertificate = certData
        TAKLogger.debug("[DataPackageParser]: Storing User Certificate")
        TAKLogger.debug("[DataPackageParser]: " + String(describing: certData))
        
        TAKLogger.debug("[DataPackageParser]: User Certificate Stored")
    }
    
    func storeServerCertificate(archive: Archive, prefs: TAKPreferences) {
        let certData = retrieveFileFromArchive(fileName: prefs.serverCertificateFileName())
        packageContents.serverCertificate = certData
    }
    
    func storePreferences(preferences: TAKPreferences) {
        packageContents.userCertificatePassword = preferences.userCertificatePassword
        packageContents.serverCertificatePassword = preferences.serverCertificatePassword

        packageContents.serverURL = preferences.serverConnectionAddress()
        packageContents.serverPort = preferences.serverConnectionPort()
        packageContents.serverProtocol = preferences.serverConnectionProtocol()
    }
    
    func parsePrefsFile(archive:Archive, prefsFile: String) -> TAKPreferences {
        let prefsParser = PreferencesParser()
        let prefData = retrieveFileFromArchive(fileName: prefsFile)

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
            let manifestData = retrieveFileFromArchive(fileName: "manifest.xml")
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

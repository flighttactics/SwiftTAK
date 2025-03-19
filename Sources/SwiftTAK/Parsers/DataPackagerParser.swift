//
//  DataPackagerParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation
import ZIPFoundation

public struct TAKServerCertificatePackage {
    public var certificateData: Data = Data()
    public var certificatePassword: String = ""

    public init() {}

    public init(certificateData: Data, certificatePassword: String) {
        self.certificateData = certificateData
        self.certificatePassword = certificatePassword
    }
}

public struct DataPackageContentsFile {
    public var shouldIgnore: Bool = false
    public var fileLocation: String
    public var parameters: [String:String] = [:]
    public var fileName: String {
        URL(string: fileLocation)?.lastPathComponent ?? fileLocation
    }
}

public struct DataPackageContents {
    public var rootFolder: String = ""
    public var userCertificate: Data = Data()
    public var userCertificatePassword: String = ""
    public var serverCertificate: Data = Data()
    public var serverCertificatePassword: String = ""
    public var serverCertificates: [TAKServerCertificatePackage] = []
    public var serverURL: String = ""
    public var serverPort: String = ""
    public var serverProtocol: String = ""
    
    public init() {}
}

public class DataPackageParser: NSObject {
    
    public var packageContents = DataPackageContents()
    public var packageFiles: [DataPackageContentsFile] = []
    public var packageConfiguration: [String:String] = [:]
    public var inMemory: Bool = true
    var archive: Archive?
    var manifestParser: ManifestParser = ManifestParser()
    var fileManager: FileManager = FileManager()
    
    let MANIFEST_FILE = "manifest.xml"
    var dataPackageContents: [String] = []
    
    var archiveLocation: URL?
    var extractLocation: URL?
    
    public init (fileLocation: URL, extractLocation: URL? = nil) {
        TAKLogger.debug("[DataPackageParser]: Initializing")
        archiveLocation = fileLocation
        if extractLocation != nil {
            inMemory = false
            self.extractLocation = extractLocation
        }
        super.init()
    }
    
    public func parse() {
        processArchive()
    }
    
    func retrieveManifestFileFromArchive() -> Data {
        if let manifestFileLocation = dataPackageContents.first(where: {
            $0.lowercased().hasSuffix("manifest.xml")
        }) {
            return retrieveFileFromArchive(fileName: manifestFileLocation)
        } else {
            return Data()
        }
    }
    
    public func retrieveFileFromArchive(_ dataPackageFile: DataPackageContentsFile) -> Data {
        return retrieveFileFromArchive(fileName: dataPackageFile.fileLocation)
    }
    
    func retrieveFileFromArchive(fileName: String) -> Data {
        var fileLocation = fileName
        var fileData = Data()
        
        guard !fileName.isEmpty else {
            TAKLogger.debug("[DataPackageParser] Attempting to retrieve a file without a filename. Ignoring")
            return fileData
        }

        if inMemory {
            TAKLogger.debug("[DataPackageParser] Loading from an in-memory based data package")
            guard let parsedArchive = archive else {
                TAKLogger.error("[DataPackageParser]: retrieveFileFromArchive tried to retrieve from an invalid data package for \(fileName)")
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
            guard let fileEntry = parsedArchive[fileLocation] else {
                let allPaths = parsedArchive.map { $0.path }.joined(separator: " | ")
                TAKLogger.debug("[DataPackageParser]: file \(fileLocation) not found in archive with paths \(allPaths)")
                return fileData
            }
            
            _ = try? parsedArchive.extract(fileEntry) { data in
                fileData.append(data)
            }
        } else {
            TAKLogger.debug("[DataPackageParser] Loading from a file-system based data package")
            guard let extractLocation = extractLocation else {
                TAKLogger.error("[DataPackageParser] Marked as a file-system retrieval but no extract location found")
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
            
            let fileUrlString = "\(extractLocation.absoluteString)/\(fileLocation)"
            guard let fileUrl = URL(string: fileUrlString) else {
                TAKLogger.error("[DataPackageParser] Unable to create the file location URL from \(fileUrlString)")
                return fileData
            }
            do {
                try fileData.append(Data(contentsOf: fileUrl))
            } catch {
                TAKLogger.error("[DataPackageParser] Error reading file from \(fileUrlString): \(error)")
            }
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
        
        if !inMemory && extractLocation != nil {
            TAKLogger.debug("[DataPackageParser] Processing as a file-system based data package")
            do {
                TAKLogger.debug("[DataPackageParser] Extracting to \(extractLocation!.relativePath)")
                try fileManager.unzipItem(at: sourceURL, to: extractLocation!)
                dataPackageContents = fileManager.subpaths(atPath: extractLocation!.relativePath) ?? []
            } catch {
                TAKLogger.error("[DataPackageParser] Unable to extract data package to \(extractLocation?.relativePath ?? "NO PATH"): \(error)")
                return
            }
        } else {
            TAKLogger.debug("[DataPackageParser] Processing as an in-memory data package")
            guard let parsedArchive = Archive(url: sourceURL, accessMode: .read) else  {
                TAKLogger.error("[DataPackageParser]: Unable to access archive at location \(String(describing: archiveLocation))")
                return
            }
            
            archive = parsedArchive
            
            TAKLogger.debug("[DataPackageParser]: Files in archive")
            dataPackageContents = archive!.map { entry in
                return entry.path
            }
            TAKLogger.debug("[DataPackageParser]: " + String(describing: dataPackageContents))
        }
        storeRootDirectory()
        parseManifestFile()
        let prefsFile = retrievePrefsFile()
        let prefs = parsePrefsFile(prefsFile: prefsFile)
        storeUserCertificate(prefs: prefs)
        storeServerCertificates(prefs: prefs)
        storePreferences(preferences: prefs)
        TAKLogger.debug("[DataPackageParser]: processArchive Complete")
    }
    
    func storeRootDirectory() {
        if let manifestFileLocation = dataPackageContents.first(where: {
            $0.lowercased().hasSuffix("manifest.xml")
        }) {
            let pathComponents = manifestFileLocation.split(separator: "/")
            if(pathComponents.count > 2) {
                TAKLogger.debug("[DataPackageParser] Setting root to \(String(pathComponents.first!)) (m1)")
                packageContents.rootFolder = String(pathComponents.first!)
            } else if (pathComponents.count > 1 && pathComponents.first!.lowercased() != "manifest") {
                TAKLogger.debug("[DataPackageParser] Setting root to \(String(pathComponents.first!)) (m2)")
                packageContents.rootFolder = String(pathComponents.first!)
            }
        } else {
            let prefsFileLocation = retrievePrefsFile()
            let pathComponents = prefsFileLocation.split(separator: "/")
            if(pathComponents.count > 1) {
                TAKLogger.debug("[DataPackageParser] Setting root to \(String(pathComponents.first!)) (p1)")
                packageContents.rootFolder = String(pathComponents.first!)
            }
        }
    }
    
    func storeUserCertificate(prefs: TAKPreferences) {
        let certData = retrieveFileFromArchive(fileName: prefs.userCertificateFileName())
        packageContents.userCertificate = certData
        TAKLogger.debug("[DataPackageParser]: Storing User Certificate")
        TAKLogger.debug("[DataPackageParser]: " + String(describing: certData))
        
        TAKLogger.debug("[DataPackageParser]: User Certificate Stored")
    }
    
    func notHiddenFile(_ path: String) -> Bool {
        // Some operating systems store hidden files in the zip
        // These are identifiable because the filename starts with a dot
        // The path might also start with a dot or a double underscore
        // But we'll only look at the file name for now
        let pathComponents = path.split(separator: "/")
        guard let fileName = pathComponents.last else {
            return !path.starts(with: ".")
        }
        return !fileName.starts(with: ".")
    }
    
    func notUserIdentityCertificate(_ prefs: TAKPreferences, _ path: String) -> Bool {
        let pathComponents = path.split(separator: "/")
        guard let fileName = pathComponents.last else {
            return !(path == prefs.userCertificateFileName())
        }
        return !(fileName == prefs.userCertificateFileName())
    }
    
    func storeServerCertificates(prefs: TAKPreferences) {
        var didStoreAtLeastOneCertificate = false
        prefs.serverCertificates.forEach { key, serverCert in
            let certData = retrieveFileFromArchive(fileName: serverCert.certificateFileName)
            if(!certData.isEmpty) {
                didStoreAtLeastOneCertificate = true
                let certPackage = TAKServerCertificatePackage(certificateData: certData, certificatePassword: serverCert.certificatePassword)
                packageContents.serverCertificates.append(certPackage)
                
            }
        }
        
        if(!didStoreAtLeastOneCertificate) {
            // iTAK supports data packages where basically all p12 files
            // that aren't the identity certificate are loaded as server certs
            // even if they don't have a matching entry in the prefs file.
            // In other words, having `certs/caCert.p12` as the CA location
            // still loads something like `truststore-intermediate.p12` through *magic*
            // Let's replicate that here
            let p12Files = dataPackageContents.filter {
                $0.hasSuffix(".p12") &&
                notUserIdentityCertificate(prefs, $0) &&
                notHiddenFile($0)
            }
            
            if(!p12Files.isEmpty) {
                p12Files.forEach { certPath in
                    let serverCertData = retrieveFileFromArchive(fileName: certPath)
                    
                    // Since we have no idea what the password might be (because the file listed
                    // in the prefs file isn't in the zip file) we'll attempt to grab the cert password
                    // if there was one in the preferences file and use that
                    let certPassword = prefs.serverCertificatePassword
                    let certPackage = TAKServerCertificatePackage(certificateData: serverCertData, certificatePassword: certPassword)
                    packageContents.serverCertificates.append(certPackage)
                }
            }
        }
    }
    
    func storePreferences(preferences: TAKPreferences) {
        packageContents.userCertificatePassword = preferences.userCertificatePassword
        packageContents.serverCertificatePassword = preferences.serverCertificatePassword

        packageContents.serverURL = preferences.serverConnectionAddress()
        packageContents.serverPort = preferences.serverConnectionPort()
        packageContents.serverProtocol = preferences.serverConnectionProtocol()
    }
    
    func parsePrefsFile(prefsFile: String) -> TAKPreferences {
        let prefsParser = PreferencesParser()
        let prefData = retrieveFileFromArchive(fileName: prefsFile)

        let xmlParser = XMLParser(data: prefData)
        xmlParser.delegate = prefsParser
        xmlParser.parse()
        return prefsParser.preferences
    }
    
    func parseManifestFile() {
        TAKLogger.debug("[DataPackageParser] Attempting to parse manifest file")
        let manifestData = retrieveManifestFileFromArchive()
        TAKLogger.debug("[DataPackageParser] Manifest: \(manifestData)")
        let xmlParser = XMLParser(data: manifestData)
        let manifestParser = ManifestParser()
        xmlParser.delegate = manifestParser
        xmlParser.parse()
        packageFiles = manifestParser.dataPackageFiles
        packageConfiguration = manifestParser.manifestConfiguration
    }
    
    func retrievePrefsFile() -> String {
        var prefsFile = ""
        
        if let prefFileLocation = dataPackageContents.first(where: {
            $0.hasSuffix(".pref")
        }) {
            prefsFile = prefFileLocation
        } else {
            prefsFile = manifestParser.prefsFile()
        }
        return prefsFile
    }

}

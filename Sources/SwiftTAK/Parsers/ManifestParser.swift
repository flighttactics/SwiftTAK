//
//  ManifestParser.swift
//  
//
//  Created by Cory Foy on 9/18/23.
//

import Foundation

public class ManifestParser: NSObject, XMLParserDelegate {
    public var fileNames = [String]()
    public var dataPackageFiles: [DataPackageContentsFile] = []
    public var currentDataPackageFile: DataPackageContentsFile?
    public var manifestConfiguration: [String:String] = [:]
    
    var isProcessingManifestConfiguration: Bool = false
    
    public func prefsFile() -> String {
        return fileNames.first(where: { $0.contains(".pref")}) ?? ""
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "Content" && currentDataPackageFile != nil) {
            dataPackageFiles.append(currentDataPackageFile!)
            currentDataPackageFile = nil
        }
    }
    
    public func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if(elementName == "Configuration") {
            isProcessingManifestConfiguration = true
        } else if(elementName == "Content") {
            isProcessingManifestConfiguration = false
            guard let fileLocation = attributeDict["zipEntry"] else {
                TAKLogger.debug("[ManifestParser] No zipEntry for Content node. Skipping")
                return
            }
            // Normalize legacy ATAK backslash zipEntry paths immediately.
            let normalizedLocation = fileLocation.replacingOccurrences(of: "\\", with: "/")
            currentDataPackageFile = DataPackageContentsFile(fileLocation: normalizedLocation)
            if let ignoreFlag = attributeDict["ignore"] {
                currentDataPackageFile?.shouldIgnore = (ignoreFlag == "true")
            }
            
            let file = normalizedLocation.split(separator: "/").last.map(String.init) ?? normalizedLocation
            TAKLogger.debug("[ManifestParser]: Adding file \(file)")
            fileNames.append(file)
        } else if(elementName == "Parameter") {
            if(currentDataPackageFile == nil && !isProcessingManifestConfiguration) {
                TAKLogger.debug("[ManifestParser] No Data Package File for Parameter Node. Skipping.")
                return
            }
            guard let parameterName = attributeDict["name"] else {
                TAKLogger.debug("[ManifestParser] Parameter node does not have a name attribute. Skipping.")
                return
            }
            let parameterValue = attributeDict["value"] ?? ""
            
            if(isProcessingManifestConfiguration) {
                manifestConfiguration[parameterName] = parameterValue
            } else if(currentDataPackageFile != nil) {
                currentDataPackageFile!.parameters[parameterName] = parameterValue
            }
        }
    }
}

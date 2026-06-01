//
//  DataPackageModels.swift
//  TAKAware
//
//  Created by Cory Foy on 4/25/26.
//

import Foundation
import XMLCoder

public struct MissionPackageManifest: Codable {

    public struct Parameter: Codable {
        @Attribute public var name: String
        @Attribute public var value: String

        public init(name: String, value: String) {
            _name = Attribute<String>(name)
            _value = Attribute<String>(value)
        }
    }

    public struct Content: Codable {
        @Attribute public var ignore: Bool
        @Attribute public var zipEntry: String

        public var parameters: [Parameter]

        enum CodingKeys: String, CodingKey {
            case parameters = "Parameter"
            case ignore = "ignore"
            case zipEntry = "zipEntry"
        }

        public init(ignore: Bool, zipEntry: String, parameters: [Parameter]) {
            _ignore = Attribute<Bool>(ignore)
            _zipEntry = Attribute<String>(zipEntry)
            self.parameters = parameters
        }
    }

    public struct Configuration: Codable {
        public var parameters: [Parameter]

        enum CodingKeys: String, CodingKey {
            case parameters = "Parameter"
        }

        public init(parameters: [Parameter]) {
            self.parameters = parameters
        }
    }

    public struct Contents: Codable {
        public var contents: [Content]

        enum CodingKeys: String, CodingKey {
            case contents = "Content"
        }

        public init(contents: [Content]) {
            self.contents = contents
        }
    }

    public init(configuration: [Parameter], contents: [Content]) {
        _version = "2"
        self.configuration = Configuration(parameters: configuration)
        self.contents = Contents(contents: contents)
    }

    @Attribute public var version: String
    public var configuration: Configuration
    public var contents: Contents

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case configuration = "Configuration"
        case contents = "Contents"
    }
}

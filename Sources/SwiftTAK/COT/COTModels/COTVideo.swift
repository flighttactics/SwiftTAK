//
//  COTVideo.swift
//
//
//  Created by Cory Foy on 10/9/23.
//

import Foundation

/// Result of reconciling `__video url` with an optional `ConnectionEntry`.
public struct COTResolvedVideoStream: Equatable {
    public enum Source: String, Equatable {
        /// Absolute `__video url` used as-is.
        case baseUrl
        /// Reconstructed entirely from `ConnectionEntry`.
        case connectionEntry
        /// Absolute `__video url` enriched with ConnectionEntry credentials (or similar).
        case merged
    }

    public let url: String
    public let source: Source
    /// Present when both sides contributed enough to compare host/port/path.
    /// `true` = same stream identity; `false` = conflict (absolute URL still preferred).
    public let identitiesMatch: Bool?

    public init(url: String, source: Source, identitiesMatch: Bool? = nil) {
        self.url = url
        self.source = source
        self.identitiesMatch = identitiesMatch
    }
}

public struct COTVideo : COTNode, Equatable {
    public var baseUrl: String
    public var uid: String = ""
    public var active: Bool? = nil
    public var alias: String? = nil
    public var classification: String? = nil
    public var thumbnail: String? = nil

    public var connectionEntry: COTConnectionEntry? = nil

    public init(
        baseUrl: String,
        uid: String = "",
        active: Bool? = nil,
        alias: String? = nil,
        classification: String? = nil,
        thumbnail: String? = nil,
        connectionEntry: COTConnectionEntry? = nil
    ) {
        self.baseUrl = baseUrl
        self.uid = uid
        self.active = active
        self.alias = alias
        self.classification = classification
        self.thumbnail = thumbnail
        self.connectionEntry = connectionEntry
    }

    /// Playable stream URL after reconciling `__video url` and `ConnectionEntry`.
    public var url: String {
        resolvedStream.url
    }

    /// Full reconciliation result (URL, provenance, identity cross-check).
    public var resolvedStream: COTResolvedVideoStream {
        Self.resolve(baseUrl: baseUrl, connectionEntry: connectionEntry)
    }

    /// Reconcile an absolute/schemeless `__video url` with ConnectionEntry metadata.
    ///
    /// Rules:
    /// - Absolute `__video url` is preferred for playback (creds + query).
    /// - ConnectionEntry supplies reconstruction when `url` is scheme-less, and
    ///   credentials when the absolute URL has none but `address` embeds `user:pass@host`.
    /// - When both sides yield an identity, compare host/port/path; on mismatch still
    ///   prefer the absolute URL but report `identitiesMatch == false`.
    public static func resolve(
        baseUrl: String,
        connectionEntry: COTConnectionEntry?
    ) -> COTResolvedVideoStream {
        let trimmedBase = baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        let absoluteBase = trimmedBase.contains("://") ? trimmedBase : nil
        let entryURL = connectionEntry.map(\.url)

        if let absoluteBase {
            var resolved = absoluteBase
            var source: COTResolvedVideoStream.Source = .baseUrl

            if let connectionEntry,
               let entryCreds = connectionEntry.embeddedCredentials,
               !urlHasCredentials(absoluteBase)
            {
                if let enriched = injectingCredentials(
                    entryCreds,
                    into: absoluteBase
                ) {
                    resolved = enriched
                    source = .merged
                }
            }

            let identitiesMatch: Bool?
            if let connectionEntry,
               let baseIdentity = streamIdentity(fromURLString: absoluteBase)
            {
                let entryIdentity = connectionEntry.streamIdentity
                identitiesMatch = baseIdentity.matches(entryIdentity)
                if identitiesMatch == false {
                    TAKLogger.debug(
                        "[COTVideo] __video url and ConnectionEntry disagree on stream identity. "
                        + "Preferring __video url. base=\(baseIdentity) entry=\(entryIdentity)"
                    )
                }
            } else {
                identitiesMatch = nil
            }

            return COTResolvedVideoStream(
                url: resolved,
                source: source,
                identitiesMatch: identitiesMatch
            )
        }

        if let entryURL, !entryURL.isEmpty {
            let identitiesMatch: Bool?
            if !trimmedBase.isEmpty,
               let baseIdentity = streamIdentity(fromSchemeless: trimmedBase)
                ?? streamIdentity(fromURLString: trimmedBase),
               let connectionEntry
            {
                identitiesMatch = baseIdentity.matches(connectionEntry.streamIdentity)
            } else {
                identitiesMatch = nil
            }
            return COTResolvedVideoStream(
                url: entryURL,
                source: .connectionEntry,
                identitiesMatch: identitiesMatch
            )
        }

        return COTResolvedVideoStream(
            url: trimmedBase,
            source: .baseUrl,
            identitiesMatch: nil
        )
    }

    public func toXml() -> String {
        var attrs: [String:String] = [:]
        attrs["url"] = baseUrl
        attrs["uid"] = uid
        if let active = active { attrs["active"] = active.description }
        if let alias = alias { attrs["alias"] = alias }
        if let classification = classification { attrs["classification"] = classification }
        if let thumbnail = thumbnail { attrs["thumbnail"] = thumbnail }

        return COTXMLHelper.generateXML(nodeName: "__video", attributes: attrs, message: "")
    }

    public static func == (lhs: COTVideo, rhs: COTVideo) -> Bool {
        let entryExistanceSame = (lhs.connectionEntry == nil && lhs.connectionEntry == nil) || (lhs.connectionEntry != nil && rhs.connectionEntry != nil)

        var connectionEntrySame = entryExistanceSame

        if(entryExistanceSame && lhs.connectionEntry != nil) {
            connectionEntrySame = (lhs.connectionEntry == rhs.connectionEntry)
        }

        return lhs.baseUrl == rhs.baseUrl &&
            lhs.uid == rhs.uid &&
            lhs.active == rhs.active &&
            lhs.alias == rhs.alias &&
            lhs.classification == rhs.classification &&
            lhs.thumbnail == rhs.thumbnail &&
            connectionEntrySame
    }

    // MARK: - Identity / credential helpers

    struct StreamIdentity: Equatable, CustomStringConvertible {
        let host: String
        let port: Int?
        let path: String

        func matches(_ other: StreamIdentity) -> Bool {
            host.caseInsensitiveCompare(other.host) == .orderedSame
                && normalizedPath(path) == normalizedPath(other.path)
                && portsMatch(port, other.port)
        }

        var description: String {
            let portSuffix = port.map { ":\($0)" } ?? ""
            return "\(host)\(portSuffix)\(normalizedPath(path))"
        }
    }

    private static func portsMatch(_ lhs: Int?, _ rhs: Int?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?):
            return l == r
        case (nil, nil):
            return true
        default:
            // One side omitted an explicit port — treat as compatible.
            return true
        }
    }

    private static func normalizedPath(_ path: String) -> String {
        if path.isEmpty { return "/" }
        let trimmed = path.hasSuffix("/") && path.count > 1
            ? String(path.dropLast())
            : path
        return trimmed.hasPrefix("/") ? trimmed : "/\(trimmed)"
    }

    private static func urlHasCredentials(_ urlString: String) -> Bool {
        guard let components = urlComponents(from: urlString) else { return false }
        let user = components.user ?? components.percentEncodedUser
        let password = components.password ?? components.percentEncodedPassword
        return !(user?.isEmpty ?? true) || !(password?.isEmpty ?? true)
    }

    private static func injectingCredentials(
        _ credentials: (username: String, password: String?),
        into urlString: String
    ) -> String? {
        guard var components = urlComponents(from: urlString) else { return nil }
        components.user = credentials.username
        components.password = credentials.password
        return components.string
    }

    private static func streamIdentity(fromURLString urlString: String) -> StreamIdentity? {
        guard let components = urlComponents(from: urlString),
              let host = components.host, !host.isEmpty else {
            return nil
        }
        return StreamIdentity(
            host: host,
            port: components.port,
            path: components.path
        )
    }

    /// Parses ATAK scheme-less forms like `host:8554/path` or `host/path`.
    private static func streamIdentity(fromSchemeless value: String) -> StreamIdentity? {
        guard !value.contains("://") else { return nil }
        var hostPortAndPath = value
        if let at = value.lastIndex(of: "@") {
            hostPortAndPath = String(value[value.index(after: at)...])
        }

        let host: String
        let port: Int?
        let path: String

        if let slash = hostPortAndPath.firstIndex(of: "/") {
            let hostPort = String(hostPortAndPath[..<slash])
            path = String(hostPortAndPath[slash...])
            (host, port) = splitHostAndPort(hostPort)
        } else {
            (host, port) = splitHostAndPort(hostPortAndPath)
            path = "/"
        }

        guard !host.isEmpty else { return nil }
        return StreamIdentity(host: host, port: port, path: path)
    }

    private static func splitHostAndPort(_ hostPort: String) -> (String, Int?) {
        guard let colon = hostPort.lastIndex(of: ":"),
              hostPort[colon...].dropFirst().allSatisfy(\.isNumber) else {
            return (hostPort, nil)
        }
        let host = String(hostPort[..<colon])
        let port = Int(hostPort[hostPort.index(after: colon)...])
        return (host, port)
    }

    private static func urlComponents(from urlString: String) -> URLComponents? {
        if let components = URLComponents(string: urlString), components.host != nil {
            return components
        }
        // Foundation rejects some credentialed URLs; rebuild via URL first.
        if let url = URL(string: urlString),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           components.host != nil {
            return components
        }
        return nil
    }
}

///
///  CachedResourceInterfacer.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// A class intended to provide easy saving and loading of Version and Text files within an App's documents directory.
///
class CachedResourceInterfacer: CachedResourceInterfacer_TextManagerInterface {
    
    private let sessionID: String
    
    /// - parameter sessionID: A String used to differentiate between one set of resources and another.
    ///
    init(withSessionID sessionID: String) {
        self.sessionID = sessionID
        createLocalDirectoryIfNeeded()
    }
}

// MARK: - Static

extension CachedResourceInterfacer {
    
    private static let cachedVersionFilename: String = "TextVersions"
    private static let cachesFolderName: String = "\(TextFetcher.self) Caches"
    
    ///
    /// - returns: The Documents Directory URL (or nil, should that fail) with the TextFetcher Caches directory appended to the end
    ///
    static let cachesURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(cachesFolderName, isDirectory: true) ?? URL(fileURLWithPath: "")
    
    ///
    /// - parameter sessionID: The Session ID to be appended
    /// - returns:             The cachesURL (or nil) with the provided Session ID appended to the end as a directory
    ///
    static func directoryURL(forSession sessionID: String) -> URL {
        Self.cachesURL.appendingPathComponent(sessionID, isDirectory: true)
    }
    
    ///
    /// - parameter sessionID: The Session ID to be used when forming the directoryURL
    /// - returns:             The directoryURL (or nil) with the Versions Cache's filename and extension appended to the end
    ///
    static func versionsURL(forSession sessionID: String) -> URL {
        Self.directoryURL(forSession: sessionID).appendingPathComponent(cachedVersionFilename).appendingPathExtension("json")
    }
    
    ///
    /// - parameter textSource: The Text Source containing the relevant filename and extension
    /// - parameter sessionID: The Session ID to be used when forming the directoryURL
    /// - returns: The directoryURL (or nil) with the filename and extension of the provided Text Source appended to the end
    ///
    static func fileURL(forTextSource textSource: TextSource, inSession sessionID: String) -> URL {
        Self.directoryURL(forSession: sessionID).appendingPathComponent(textSource.identifier).appendingPathExtension("txt")
    }
}

// MARK: - Setup

extension CachedResourceInterfacer {
    
    ///
    /// Creates a new directory for the current session within the app's Documents directory, if one does not already exist.
    ///
    private func createLocalDirectoryIfNeeded() {
        let documentsDirectoryURL = Self.directoryURL(forSession: sessionID)
        try? FileManager.default.createDirectory(atPath: documentsDirectoryURL.path, withIntermediateDirectories: true, attributes: nil)
    }
}

// MARK: - Retrieval

extension CachedResourceInterfacer {
    
    ///
    /// Loads Data from the Version file in the Cache Directory, decodes it into a [String: String] dictionary,
    /// maps it to [String: Version] and returns the result, or nil, should any of that fail.
    ///
    /// - returns: The loaded, decoded, mapped version values, or nil, should they fail to load or decode.
    ///
    func cachedVersions() -> VersionStore? {
        let data = try? Data(contentsOf: Self.versionsURL(forSession: sessionID))
        return VersionStore(withData: data)
    }
    
    ///
    /// Loads Data from the Cache Directory using the textSource.identifier, decodes it as UTF-8 into a String value,
    /// and returns the result, or nil, should any of that fail.
    ///
    /// - parameter textSource: The TextSource specifying the identifier needed to locate and load the bundled text.
    /// - returns: The loaded, decoded text, or nil, should it fail to load or decode.
    ///
    func cachedText(forSource textSource: TextSource) -> String? {
        return try? String(contentsOf: Self.fileURL(forTextSource: textSource, inSession: sessionID), encoding: .utf8)
    }
}

// MARK: - Saving

extension CachedResourceInterfacer {
    
    ///
    /// Maps the supplied versions to [String: String] format, encodes it to JSON, and writes it into the Cache Directory.
    ///
    /// - parameter versions: The versions you would like cached.
    ///
    func saveToCache(_ versions: VersionStore) {
        if let data = versions.jsonEncodedData {
            createLocalDirectoryIfNeeded()
            try? data.write(to: Self.versionsURL(forSession: sessionID))
        }
    }
    
    ///
    /// Encodes the provided text as UTF-8, and writes the resulting data into the Cache Directory named using the provided textSource.identifier.
    ///
    /// - parameter text: The text you would like cached.
    /// - parameter textSource: The TextSource associated with the provided text.
    ///
    func saveToCache(_ text: String, forSource textSource: TextSource) {
        createLocalDirectoryIfNeeded()
        let url = Self.fileURL(forTextSource: textSource, inSession: sessionID)
        try? text.write(to: url, atomically: true, encoding: .utf8)
    }
}

// MARK: - Clearing

extension CachedResourceInterfacer {
    
    ///
    /// Deletes the version cache file from within the Cache Directory.
    ///
    func clearCachedVersions() {
        let url = Self.versionsURL(forSession: sessionID)
        try? FileManager.default.removeItem(at: url)
    }
    
    ///
    /// Deletes the entire session's Cache Directory.
    ///
    func clearCaches() {
        let documentsDirectoryURL = Self.directoryURL(forSession: sessionID)
        try? FileManager.default.removeItem(at: documentsDirectoryURL)
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension CachedResourceInterfacer {
        static var test_cachesFolderName: String { cachesFolderName }
        static var test_cachedVersionFilename: String { cachedVersionFilename }
        var test_sessionID: String { sessionID }
        func test_createLocalDirectoryIfNeeded() { createLocalDirectoryIfNeeded() }
    }
#endif

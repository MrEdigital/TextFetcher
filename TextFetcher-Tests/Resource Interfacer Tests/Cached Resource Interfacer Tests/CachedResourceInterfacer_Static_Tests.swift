///
///  CachedResourceInterfacer_Static_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// CachedResourceInterfacer Unit Tests - Static
///
class CachedResourceInterfacer_Static_Tests: XCTestCase {
    
    var interfacer: CachedResourceInterfacer!
    
    override func tearDown() {
        super.tearDown()
        interfacer?.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following Static functions:
///
///     static let cachesURL: URL?
///     static func directoryURL(forSession sessionID: String) -> URL?
///     static func versionsURL(forSession sessionID: String) -> URL?
///     static func fileURL(forTextSource textSource: TextSource, inSession sessionID: String) -> URL?
///
extension CachedResourceInterfacer_Static_Tests {
    
    // MARK: - T - Caches URL
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the static variable:
    ///
    ///      static let cachesURL: URL?
    ///
    /// The following value is expected:
    /// A URL matching the Documents Directory, with an additional directory whose name matches CachedResourceInterfacer.cachesFolderName
    ///
    func test_cachesURL() {
        
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path
        else {
            return XCTFail()
        }
        
        let cachesURL = CachedResourceInterfacer.cachesURL
        XCTAssertEqual(cachesURL.path, documentsPath + "/" + CachedResourceInterfacer.test_cachesFolderName)
    }
    
    // MARK: - T - Directory URL
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the static variable:
    ///
    ///      static func directoryURL(forSession sessionID: String) -> URL?
    ///
    /// The following value is expected:
    /// A URL matching the cachesURL, with an additional directory whose name matches the provided Session ID
    ///
    func test_directoryURL() {
        
        let sessionID: String = "sddsgdfgfdgf"
        let cachesURL = CachedResourceInterfacer.cachesURL
        let directoryURL = CachedResourceInterfacer.directoryURL(forSession: sessionID)
        
        XCTAssertEqual(directoryURL.path, cachesURL.path + "/" + sessionID)
    }
    
    // MARK: - T - Versions URL
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the static variable:
    ///
    ///      static func versionsURL(forSession sessionID: String) -> URL?
    ///
    /// The following value is expected:
    /// A URL matching the directoryURL, with a file named cachedVersionFilename, with extension "json"
    ///
    func test_versionsURL() {
        
        let sessionID: String = "sddsgdfgfdgf"
        let directoryURL = CachedResourceInterfacer.directoryURL(forSession: sessionID)
        let versionsURL = CachedResourceInterfacer.versionsURL(forSession: sessionID)
        
        XCTAssertEqual(versionsURL.path, directoryURL.path + "/" + CachedResourceInterfacer.test_cachedVersionFilename + ".json")
    }
    
    // MARK: - T - File URL
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the static variable:
    ///
    ///      static func fileURL(forTextSource textSource: TextSource, inSession sessionID: String) -> URL?
    ///
    /// The following value is expected:
    /// A URL matching the directoryURL, with a file name matching the provided textSource.identifier, with extension "txt"
    ///
    func test_fileURL() {
        
        let sessionID: String = "sddsgdfgfdgf"
        let textSource: TextSource = .init(identifier: "dfgdfgdfg", bundleFile: nil, remoteFile: nil)
        let directoryURL = CachedResourceInterfacer.directoryURL(forSession: sessionID)
        let fileURL = CachedResourceInterfacer.fileURL(forTextSource: textSource, inSession: sessionID)
        
        XCTAssertEqual(fileURL.path, directoryURL.path + "/" + textSource.identifier + ".txt")
    }
}

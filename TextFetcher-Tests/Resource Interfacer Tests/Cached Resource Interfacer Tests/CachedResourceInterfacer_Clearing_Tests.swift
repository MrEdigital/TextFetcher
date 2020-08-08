///
///  CachedResourceInterfacer_Clearing_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// CachedResourceInterfacer Unit Tests - Clearing
///
class CachedResourceInterfacer_Clearing_Tests: XCTestCase {
    
    var interfacer: CachedResourceInterfacer!
    
    override func tearDown() {
        super.tearDown()
        interfacer?.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func clearCachedVersions()
///     func clearCaches()
///
extension CachedResourceInterfacer_Clearing_Tests {
    
    // MARK: - T - Clear Cached Versions
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func clearCachedVersions()
    ///
    /// The following behavior is expected:
    /// 1 - Deletes the version cache file from within the Cache Directory.
    ///
    func test_clearCachedVersions() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        guard let bundlePath = Bundle(for: Self.self).path(forResource: TestingResources.BundleFileNames.Versions.s, ofType: TestingResources.BundleFileNames.Versions.extension) else { return XCTFail() }
        
        // Behavior #1:

            let versionsURL = CachedResourceInterfacer.versionsURL(forSession: interfacer.test_sessionID)
            try? FileManager.default.copyItem(at: URL(fileURLWithPath: bundlePath), to: versionsURL)
            XCTAssertTrue(FileManager.default.fileExists(atPath: versionsURL.path))
            
            interfacer.clearCachedVersions()
            XCTAssertFalse(FileManager.default.fileExists(atPath: versionsURL.path))
    }
    
    // MARK: - T - Clear Caches
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func clearCaches()
    ///
    /// The following behavior is expected:
    /// 1 - Deletes the entire session's Cache Directory.
    ///
    func test_clearCaches() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        guard let bundlePath = Bundle(for: Self.self).path(forResource: TestingResources.BundleFileNames.Versions.s, ofType: TestingResources.BundleFileNames.Versions.extension)
        else { return XCTFail() }
        
        // Behavior #1:
            let directoryURL = CachedResourceInterfacer.directoryURL(forSession: interfacer.test_sessionID)
            let versionsURL = CachedResourceInterfacer.versionsURL(forSession: interfacer.test_sessionID)
        
            try? FileManager.default.copyItem(at: URL(fileURLWithPath: bundlePath), to: versionsURL)
            XCTAssertTrue(FileManager.default.fileExists(atPath: directoryURL.path))
            
            interfacer.clearCaches()
            XCTAssertFalse(FileManager.default.fileExists(atPath: directoryURL.path))
    }
}

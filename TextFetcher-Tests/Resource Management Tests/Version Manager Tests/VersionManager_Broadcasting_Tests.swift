///
///  VersionManager_Broadcasting_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Broadcasting
///
class VersionManager_Broadcasting_Tests: XCTestCase {
    
    var newerVersionCallCount: Int = 0
    var versionManager: VersionManager! {
        didSet {
            versionManager.setResourceBundle(to: Bundle(for: Self.self))
        }
    }
    
    override func tearDown() {
        super.tearDown()
        versionManager?.test_clearAllCaches()
        newerVersionCallCount = 0
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private func broadcastAnyNewerVersions()
///     private func broadcastLatestVersionLocation(forID resourceID: ResourceID)
///
extension VersionManager_Broadcasting_Tests {
    
    // MARK: - T - Broadcast Any Newer Versions
    ///
    /// VersionManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func broadcastAnyNewerVersions()
    ///
    /// The following behavior is expected:
    /// 1. If no Versions are found, no broadcasts are made.
    /// 2. Versions which are greater than cache should broadcast.
    /// 3. Versions which are less than or equal to cache should not.
    ///
    func test_broadcastAnyNewerVersions() {
        
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setDelegate(to: self)
        
        // Pre Behavior:
            XCTAssertEqual(newerVersionCallCount, 0)
        
        // Behavior #1:
            versionManager.test_broadcastAnyNewerVersions()
            XCTAssertEqual(newerVersionCallCount, 0)
        
        // Behavior #2 - 1:
            versionManager.test_setBundleVersions(to: TestingResources.BundleFileContents.Versions.s)
            versionManager.test_broadcastAnyNewerVersions()
            XCTAssertEqual(newerVersionCallCount, TestingResources.BundleFileContents.Versions.s.count)
            newerVersionCallCount = 0
                
        // Behavior #2 - 2:
            versionManager.test_setBundleVersions(to: TestingResources.BundleFileContents.Versions.m)
            versionManager.test_broadcastAnyNewerVersions()
            XCTAssertEqual(newerVersionCallCount, TestingResources.BundleFileContents.Versions.m.count)
            newerVersionCallCount = 0
        
        // Behavior #3:
            versionManager.test_setBundleVersions(to: TestingResources.BundleFileContents.Versions.s)
            versionManager.test_broadcastAnyNewerVersions()
            XCTAssertEqual(newerVersionCallCount, 0)
    }
    
    // MARK: - T - Broadcast If Newer Version
    ///
    /// VersionManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func broadcastLatestVersionLocation(forID resourceID: ResourceID)
    ///
    /// The following behavior is expected:
    /// 1. If no Versions are found, no broadcasts are made.
    /// 2. Versions which are greater than cache should broadcast.
    /// 3. Versions which are less than or equal to cache should not.
    ///
    func test_broadcastLatestVersionLocation() {
        
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setDelegate(to: self)
        
        // Pre Behavior:
            XCTAssertEqual(newerVersionCallCount, 0)
        
        // Behavior #1:
            versionManager.test_broadcastLatestVersionLocation(forID: "abc")
            XCTAssertEqual(newerVersionCallCount, 0)
            
        // Behavior #2 - 1:
            cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: versionManager.test_sessionID)
            versionManager.test_loadCachedVersions()
            versionManager.test_setVersion(Version(major: 2, minor: 0, patch: 0), forResource: "Test1", inLocation: .bundle)
            versionManager.test_broadcastLatestVersionLocation(forID: "Test1")
            XCTAssertEqual(newerVersionCallCount, 1)
            newerVersionCallCount = 0
                
        // Behavior #2 - 2:
            versionManager.test_setVersion(Version(major: 3, minor: 0, patch: 0), forResource: "Test1", inLocation: .bundle)
            versionManager.test_broadcastLatestVersionLocation(forID: "Test1")
            XCTAssertEqual(newerVersionCallCount, 1)
            newerVersionCallCount = 0
        
        // Behavior #3:
            versionManager.test_setVersion(Version(major: 0, minor: 0, patch: 1), forResource: "Test1", inLocation: .bundle)
            versionManager.test_broadcastLatestVersionLocation(forID: "Test1")
            XCTAssertEqual(newerVersionCallCount, 0)
    }
}

// MARK: - Helper Functions -

extension VersionManager_Broadcasting_Tests: VersionManagerDelegate {
    
    // MARK: Cache Versions
    ///
    func cacheVersions(from fileName: String, forSession sessionID: String) {
        guard let path = Bundle(for: Self.self).path(forResource: fileName, ofType: TestingResources.BundleFileNames.Versions.extension) else {
            return XCTFail()
        }
        do {
            let toURL = CachedResourceInterfacer.versionsURL(forSession: sessionID)
            if FileManager.default.fileExists(atPath: toURL.path) {
                try FileManager.default.removeItem(at: toURL)
            }
            try FileManager.default.copyItem(at: URL(fileURLWithPath: path), to: toURL)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    // MARK: - Newer Version Detected
    ///
    func newerVersionsLocated(_ locatedVersions: [LocationBoundVersion], forResource resourceID: ResourceID) {
        newerVersionCallCount += 1
        versionManager.resourceCached(forID: resourceID, withVersion: locatedVersions.byVersion_descending.first!.version)
    }
}

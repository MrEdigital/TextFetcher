///
///  VersionManager_Saving_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Saving
///
class VersionManager_Saving_Tests: XCTestCase {
    
    var versionManager: VersionManager! {
        didSet {
            versionManager.setResourceBundle(to: Bundle(for: Self.self))
        }
    }
    
    override func tearDown() {
        super.tearDown()
        versionManager?.test_clearAllCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private func saveCurrentVersions()
///
extension VersionManager_Saving_Tests {
    
    // MARK: - T - Save Current Versions
    ///
    /// VersionManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func saveCurrentVersions()
    ///
    /// The following behavior is expected:
    /// 1. The currentVersions store is saved to disk via the cacheInterfacer
    ///
    func test_saveCurrentVersions() {
        
        var expectedCacheVersions: VersionStore
        var cachedVersions: VersionStore?
        let versionSource: VersionSource = .init(bundleFile: nil, remoteFile: .init(urlString: ""))
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setDelegate(to: self)
        versionManager.setVersionSource(to: versionSource)
        
        // Pre Behavior:
        
            cachedVersions = versionManager.test_cacheInterfacer.cachedVersions()
            XCTAssertNil(cachedVersions)
        
        // Behavior #1 - 1:
        
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.s
            versionManager.test_setCurrentVersions(to: expectedCacheVersions)
            versionManager.test_saveCurrentVersions()
            cachedVersions = versionManager.test_cacheInterfacer.cachedVersions()
                
            XCTAssertEqual(cachedVersions?.count, expectedCacheVersions.count)

            expectedCacheVersions.forEachResource { resourceID, version in
                let currentVersion = cachedVersions?.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
            
            versionManager.test_cacheInterfacer.clearCaches()
            versionManager.test_cacheInterfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 2:
        
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.m
            versionManager.test_setCurrentVersions(to: expectedCacheVersions)
            versionManager.test_saveCurrentVersions()
            cachedVersions = versionManager.test_cacheInterfacer.cachedVersions()
                
            XCTAssertEqual(cachedVersions?.count, expectedCacheVersions.count)
        
            expectedCacheVersions.forEachResource { resourceID, version in
                let currentVersion = cachedVersions?.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
            
            versionManager.test_cacheInterfacer.clearCaches()
            versionManager.test_cacheInterfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 3:
            
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.l
            versionManager.test_setCurrentVersions(to: expectedCacheVersions)
            versionManager.test_saveCurrentVersions()
            cachedVersions = versionManager.test_cacheInterfacer.cachedVersions()
                
            XCTAssertEqual(cachedVersions?.count, expectedCacheVersions.count)
        
            expectedCacheVersions.forEachResource { resourceID, version in
                let currentVersion = cachedVersions?.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
            
            versionManager.test_cacheInterfacer.clearCaches()
            versionManager.test_cacheInterfacer.test_createLocalDirectoryIfNeeded()
    }
}

// MARK: - Helper Functions -

extension VersionManager_Saving_Tests: VersionManagerDelegate {
    
    // MARK: Newer Version Detected
    ///
    func newerVersionsLocated(_ locatedVersions: [LocationBoundVersion], forResource resourceID: ResourceID) {
        versionManager.resourceCached(forID: resourceID, withVersion: locatedVersions.first!.version)
    }
}

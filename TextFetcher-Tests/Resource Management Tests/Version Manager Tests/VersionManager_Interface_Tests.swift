///
///  VersionManager_Interface_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Interface
///
class VersionManager_Interface_Tests: XCTestCase {

    let versionsS = TestingResources.BundleFileContents.Versions.s
    let versionsM = TestingResources.BundleFileContents.Versions.m
    let versionsL = TestingResources.BundleFileContents.Versions.l
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
///     func cachedVersion(forResource resourceID: ResourceID) -> Version
///     func locationOfLatestKnownVersion(forID resourceID: String) -> ResourceLocation
///     func resourceCached(forID resourceID: ResourceID, withVersion version: Version)
///     func resourceRegistered(forID resourceID: ResourceID)
///     func clearCaches()
///
extension VersionManager_Interface_Tests {
    
    // MARK: - T - Cached Version For Resource
    ///
    /// Tests the function:
    ///
    ///     func cachedVersion(forResource resourceID: ResourceID) -> Version
    ///
    /// The following behavior is expected:
    /// 1. Returns the cached version for the specified resource
    /// 2. If no version is found, it should return .zero instead
    ///
    func test_cachedVersionForResource() {
        
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:
        
            versionManager.test_setCurrentVersions(to: versionsS)
            versionManager.test_setBundleVersions(to: versionsM)
            versionManager.test_setRemoteVersions(to: versionsL)
        
            for resourceID in versionsS.allResourceIDs {
                XCTAssertEqual(versionManager.cachedVersion(forResource: resourceID), versionsS.version(forResource: resourceID))
            }
        
        // Behavior #2:

            versionManager.test_setCurrentVersions(to: .init())
            
            for resourceID in versionsS.allResourceIDs {
                XCTAssertEqual(versionManager.cachedVersion(forResource: resourceID), .zero)
            }
            
    }
    
    // MARK: - T - Location of Latest Version
    ///
    /// Tests the function:
    ///
    ///     func allVersions(ofResource resourceID: ResourceID) -> ResourceLocation
    ///
    /// The following behavior is expected:
    /// 1. Returns all known Versions for a given resource
    /// 2. Returns 0.0.0 for the cached version if no cached version is found
    ///
    func test_allVersions() {
        
        var locations: [LocationBoundVersion]
        
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        
        guard versionsS.count > 1 else {
            XCTFail("There are supposed to be multiple versions in here!")
            return
        }
        for resourceID in versionsS.allResourceIDs {
        
            // Behavior #1 - 1:
            
                versionManager.test_setCurrentVersions(to: versionsS)
                versionManager.test_setBundleVersions(to: versionsM)
                versionManager.test_setRemoteVersions(to: versionsL)
            
                locations = versionManager.allVersions(ofResource: resourceID)
                XCTAssertEqual(locations.count, 3)
                XCTAssertEqual(locations.first(where: { $0.location == .cache })?.version, versionsS.version(forResource: resourceID))
                XCTAssertEqual(locations.first(where: { $0.location == .bundle })?.version, versionsM.version(forResource: resourceID))
                XCTAssertEqual(locations.first(where: { $0.location == .remote })?.version, versionsL.version(forResource: resourceID))
        
            // Behavior #1 - 2:
            
                versionManager.test_setCurrentVersions(to: versionsL)
                versionManager.test_setBundleVersions(to: versionsS)
                versionManager.test_setRemoteVersions(to: .init())
            
                locations = versionManager.allVersions(ofResource: resourceID)
                XCTAssertEqual(locations.count, 3)
                XCTAssertEqual(locations.first(where: { $0.location == .cache })?.version, versionsL.version(forResource: resourceID))
                XCTAssertEqual(locations.first(where: { $0.location == .bundle })?.version, versionsS.version(forResource: resourceID))
                XCTAssertEqual(locations.first(where: { $0.location == .remote })?.version, .zero)
            
            // Behavior #2:
            
                versionManager.test_setCurrentVersions(to: .init())
                versionManager.test_setBundleVersions(to: .init())
                versionManager.test_setRemoteVersions(to: versionsL)
            
                locations = versionManager.allVersions(ofResource: resourceID)
                XCTAssertEqual(locations.count, 3)
                XCTAssertEqual(locations.first(where: { $0.location == .cache })?.version, .zero)
                XCTAssertEqual(locations.first(where: { $0.location == .bundle })?.version, .zero)
                XCTAssertEqual(locations.first(where: { $0.location == .remote })?.version, versionsL.version(forResource: resourceID))
        }
    }
    
    // MARK: - T - Resource Cached
    ///
    /// Tests the function:
    ///
    ///     func resourceCached(forID resourceID: ResourceID, withVersion version: Version)
    ///
    /// The following behavior is expected:
    /// 1. Updates the current VersionStore's value for the provided resourceID with the provided Version
    /// 2. Caches the current VersionStore
    ///
    func test_resourceCached() {
        
        let versionSource: VersionSource = .init(bundleFile: .init(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: .init(urlString: ""))
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setVersionSource(to: versionSource)
        
        var test1_version: Version?
            
        // Pre Behavior:
            test1_version = versionManager.test_currentVersions.version(forResource: "Test1")
            XCTAssertNil(test1_version)
            versionManager.resourceCached(forID: "Test1", withVersion: Version(major: 2, minor: 3, patch: 4))
        
        // Behavior #1:
            test1_version = versionManager.test_currentVersions.version(forResource: "Test1")
            XCTAssertNotNil(test1_version)
            XCTAssertEqual(test1_version?.major, 2)
            XCTAssertEqual(test1_version?.minor, 3)
            XCTAssertEqual(test1_version?.patch, 4)
        
        // Behavior #2:
            test1_version = versionManager.test_cacheInterfacer.cachedVersions()?.version(forResource: "Test1")
            XCTAssertNotNil(test1_version)
            XCTAssertEqual(test1_version?.major, 2)
            XCTAssertEqual(test1_version?.minor, 3)
            XCTAssertEqual(test1_version?.patch, 4)
    }
    
    // MARK: - T - Resource Registered
    ///
    /// Tests the function:
    ///
    ///     func resourceRegistered(forID resourceID: ResourceID)
    ///
    /// The following behavior is expected:
    /// 1. Nothing should occur if there is no greater version for the provided resourceID than what is in the currentVersions
    /// 2. broadcastIfNewerVersion is called for bundledVersions.  A broadcast should occur if a newer version exists within the bundledVersions at this point
    /// 3. broadcastIfNewerVersion is called for remoteVersions.  A broadcast should occur if a newer version exists within the remoteVersions at this point
    ///
    func test_resourceRegistered() {
        var currentVersions: VersionStore
        var bundledVersions: VersionStore
        var remoteVersions: VersionStore
        
        // Behavior #1:

            currentVersions = versionsL
            bundledVersions = versionsS
            remoteVersions = .init()
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
        
            versionManager.test_setCurrentVersions(to: currentVersions)
            versionManager.test_setBundleVersions(to: bundledVersions)
            versionManager.test_setRemoteVersions(to: remoteVersions)
        
            versionManager.resourceRegistered(forID: currentVersions.allResourceIDs.first!)
            
            XCTAssertEqual(newerVersionCallCount, 0)
            newerVersionCallCount = 0
        
        // Behavior #2:

            currentVersions = versionsS
            bundledVersions = versionsL
            remoteVersions = .init()
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            
            versionManager.test_setCurrentVersions(to: currentVersions)
            versionManager.test_setBundleVersions(to: bundledVersions)
            versionManager.test_setRemoteVersions(to: remoteVersions)
            
            versionManager.resourceRegistered(forID: currentVersions.allResourceIDs.first!)
            
            XCTAssertEqual(newerVersionCallCount, 1)
            newerVersionCallCount = 0
        
        // Behavior #3:
        
            currentVersions = versionsS
            bundledVersions = .init()
            remoteVersions = versionsL
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            
            versionManager.test_setCurrentVersions(to: currentVersions)
            versionManager.test_setBundleVersions(to: bundledVersions)
            versionManager.test_setRemoteVersions(to: remoteVersions)
            
            versionManager.resourceRegistered(forID: currentVersions.allResourceIDs.first!)
            
            XCTAssertEqual(newerVersionCallCount, 1)
    }
    
    // MARK: - T - Clear Cache
    ///
    /// Tests the function:
    ///
    ///     func clearCaches()
    ///
    /// The following behavior is expected:
    /// 1. Clears the cached version store
    /// 2. Deletes cached versions
    ///
    func test_clearCache() {
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: versionManager.test_sessionID)
        versionManager.test_loadCachedVersions()
        
        // Pre Behavior:        
            XCTAssertTrue(versionManager.test_currentVersions.count > 0)
        
        // Behavior #1:
            versionManager.clearCaches()
            XCTAssertEqual(versionManager.test_currentVersions.count, 0)
        
        // Behavior #2:
            versionManager.test_loadCachedVersions()
            XCTAssertEqual(versionManager.test_currentVersions.count, 0)
    }
}

// MARK: - Helper Functions -

extension VersionManager_Interface_Tests: VersionManagerDelegate {
    
    // MARK: Cache Versions
    ///
    func cacheVersions(from fileName: String, forSession sessionID: String) {
        guard let path = Bundle(for: Self.self).path(forResource: fileName, ofType: TestingResources.BundleFileNames.Versions.extension) else {
            return XCTFail()
        }
        do {
            let toURL = CachedResourceInterfacer.versionsURL(forSession: sessionID)
            try FileManager.default.copyItem(at: URL(fileURLWithPath: path), to: toURL)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
        
    // MARK: - Newer Version Detected
    ///
    func newerVersionsLocated(_ locatedVersions: [LocationBoundVersion], forResource resourceID: ResourceID) {
        newerVersionCallCount += 1
        versionManager.resourceCached(forID: resourceID, withVersion: locatedVersions.first!.version)
    }
}


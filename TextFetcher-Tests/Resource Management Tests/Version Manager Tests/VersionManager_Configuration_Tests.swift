///
///  VersionManager_Configuration_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
import OHHTTPStubs
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Configuration
///
class VersionManager_Configuration_Tests: XCTestCase {
    
    var newerVersionCallCount: Int = 0
    var allowNewerVersionCaching: Bool = true
    var versionManager: VersionManager! {
        didSet {
            versionManager.setResourceBundle(to: Bundle(for: Self.self))
        }
    }
    
    override func setUp() {
        super.setUp()

        // Stub for Versions (Medium)
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.m), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.m.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode:200, headers:nil)
        })
    }
    
    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
        versionManager?.test_clearAllCaches()
        newerVersionCallCount = 0
        allowNewerVersionCaching = true
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func setDelegate(to delegate: VersionManagerDelegate?)
///     func setVersionSource(to versionSource: VersionSource)
///     private func saveCacheValues()
///
extension VersionManager_Configuration_Tests {
    
    // MARK: - T - Set Delegate
    ///
    /// Tests the function:
    ///
    ///     func setDelegate(to delegate: VersionManagerDelegate?)
    ///
    /// The following behavior is expected:
    /// 1. Sets the delegate property in versionManager to the supplied reference value
    ///
    func test_setDelegate() {
        
        // Pre Behavior:
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            XCTAssertNil(versionManager.test_delegate)

        // Behavior #1:
            versionManager.setDelegate(to: self)
            XCTAssertTrue(versionManager.test_delegate === self)
    }
    
    // MARK: - T - Set Version Source
    ///
    /// Tests the VersionManager function:
    ///
    ///     func setVersionSource(to versionSource: VersionSource)
    ///
    /// The following behavior is expected:
    /// 1. Sets the versionSource property within versionManager with the supplied reference value
    /// 2. Calls loadCachedVersions() on versionManager, which should load any cached versions into the currentVersions (ie: tests_currentVersions) property
    /// 3. Calls loadBundleVersions() on versionManager, which should load any bundled versions into the bundledVersions (ie: tests_bundledVersions) property
    ///  4. Calls broadcastAnyNewerVersions() for any versions in bundledVersions which are newer than currentVersions
    /// 5. Calls fetchRemoteVersions() on versionManager, which should load any remote versions into the remoteVersions (ie: tests_remoteVersions) property
    ///  6. Calls broadcastAnyNewerVersions() for any versions in remoteVersions which are newer than currentVersions
    ///
    func test_setVersionSource() {

        var expectedCacheVersions: VersionStore
        var expectedBundleVersions: VersionStore
        var expectedRemoteVersions: VersionStore
        var versionSource: VersionSource
        
        // Pre Behavior:
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)

            XCTAssertNil(versionManager.test_versionSource)
            XCTAssertEqual(versionManager.test_currentVersions.count, 0)

        // Behavior #1:
        
            versionSource = .init(bundleFile: .init(fileName: "dsgddfg", fileExtension: "dffggd"), remoteFile: .init(urlString: "fghfgh"))
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            versionManager.setVersionSource(to: versionSource)
            
            XCTAssertNotNil(versionManager.test_versionSource?.bundleFile)
            XCTAssertEqual(versionManager.test_versionSource?.bundleFile?.fileName,      versionSource.bundleFile?.fileName)
            XCTAssertEqual(versionManager.test_versionSource?.bundleFile?.fileExtension, versionSource.bundleFile?.fileExtension)
            XCTAssertEqual(versionManager.test_versionSource?.remoteFile.urlString,      versionSource.remoteFile.urlString)
            
        // Behavior #2:
        
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = .init(bundleFile: nil, remoteFile: .init(urlString: ""))

            versionManager.clearCaches()
            cacheVersions(from: TestingResources.BundleFileNames.Versions.m, forSession: versionManager.test_sessionID)
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            versionManager.setVersionSource(to: versionSource)
        
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedCacheVersions.test_resourceVersions)
            newerVersionCallCount = 0

        // Behavior #3 - 1:
        
            expectedBundleVersions = TestingResources.BundleFileContents.Versions.s
            versionSource = .init(bundleFile: .init(fileName: TestingResources.BundleFileNames.Versions.s, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: .init(urlString: ""))

            versionManager.clearCaches()
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            versionManager.setVersionSource(to: versionSource)
        
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedBundleVersions.test_resourceVersions)
            XCTAssertEqual(versionManager.test_bundledVersions.test_resourceVersions, expectedBundleVersions.test_resourceVersions)

            // Behavior #4 - 1:
                XCTAssertEqual(newerVersionCallCount, expectedBundleVersions.count)
                newerVersionCallCount = 0

        // Behavior #3 - 2:
        
            expectedBundleVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = .init(bundleFile: .init(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: .init(urlString: ""))

            versionManager.clearCaches()
            cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: versionManager.test_sessionID)
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
            versionManager.setVersionSource(to: versionSource)
        
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedBundleVersions.test_resourceVersions)
            XCTAssertEqual(versionManager.test_bundledVersions.test_resourceVersions, expectedBundleVersions.test_resourceVersions)
        
            // Behavior #4 - 2:
                XCTAssertEqual(newerVersionCallCount, expectedBundleVersions.count)
                newerVersionCallCount = 0

        // Behavior #5 - 1:
        
            expectedRemoteVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = .init(bundleFile: nil, remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.m))

            versionManager.clearCaches()
            cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: versionManager.test_sessionID)
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
        
            var exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.setVersionSource(to: versionSource, withCompletion: {
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedRemoteVersions.test_resourceVersions)
            XCTAssertEqual(versionManager.test_remoteVersions.test_resourceVersions, expectedRemoteVersions.test_resourceVersions)

            // Behavior #6 - 1:
                XCTAssertEqual(newerVersionCallCount, expectedRemoteVersions.count)
                newerVersionCallCount = 0

        // Behavior #5 - 2:
        
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.l
            expectedRemoteVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = .init(bundleFile: nil, remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.m))

            versionManager.clearCaches()
            cacheVersions(from: TestingResources.BundleFileNames.Versions.l, forSession: versionManager.test_sessionID)
        
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.setDelegate(to: self)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.setVersionSource(to: versionSource, withCompletion: {
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedCacheVersions.test_resourceVersions)
            XCTAssertEqual(versionManager.test_remoteVersions.test_resourceVersions, expectedRemoteVersions.test_resourceVersions)

            // Behavior #6 - 2:
                XCTAssertEqual(newerVersionCallCount, 0)
                newerVersionCallCount = 0
    }
    
    // MARK: - T - Set Resource Bundle
    ///
    /// Tests the function:
    ///
    ///     private func saveCacheValues()
    ///
    /// The following behavior is expected:
    ///
    func test_setResourceBundle() {
        
        let versionSource: VersionSource = .init(bundleFile: .init(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: .init(urlString: ""))
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setVersionSource(to: versionSource)
        
        versionManager.setResourceBundle(to: .main)
        
        // Test that the bundle is set
        
            XCTAssertEqual(versionManager.test_bundleInterfacer.test_bundle, .main)
        
        // Test that the Bundle Versions were loaded
        
            // Note: There are no bundled version sources in .main
            XCTAssertEqual(versionManager.test_bundledVersions.count, 0)
        
            versionManager.setResourceBundle(to: Bundle(for: Self.self))
        
        // Test that the bundle is set
        
            XCTAssertEqual(versionManager.test_bundleInterfacer.test_bundle, Bundle(for: Self.self))
        
        // Test that the Bundle Versions were loaded
        
            // Note: There is a version source with 4 versions in the test bundle, however
            XCTAssertEqual(versionManager.test_bundledVersions.count, 4)
    }
}

// MARK: - Helper Functions -

extension VersionManager_Configuration_Tests: VersionManagerDelegate {
    
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
        if allowNewerVersionCaching, locatedVersions.byVersion_descending.count > 0 {
            versionManager.resourceCached(forID: resourceID, withVersion: locatedVersions.byVersion_descending[0].version)
        }
    }
}

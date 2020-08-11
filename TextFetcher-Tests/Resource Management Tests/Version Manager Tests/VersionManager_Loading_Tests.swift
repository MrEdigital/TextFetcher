///
///  VersionManager_Loading_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
import OHHTTPStubs
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Loading
///
class VersionManager_Loading_Tests: XCTestCase {
    
    var newerVersionCallCount: Int = 0
    var versionManager: VersionManager! {
        didSet {
            versionManager.setResourceBundle(to: Bundle(for: Self.self))
        }
    }
    
    override func setUp() {
        super.setUp()

        // Stub for Versions (Small)
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.s), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.s.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode: 200, headers:nil)
        })

        // Stub for Versions (Medium)
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.m), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.m.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode: 200, headers:nil)
        })

        // Stub for Versions (Large)
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.l), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.l.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode: 200, headers:nil)
        })
    }
    
    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
        versionManager?.test_clearAllCaches()
        newerVersionCallCount = 0
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private func loadCachedVersions()
///     private func loadBundleVersions()
///     private func fetchRemoteVersions(withCompletion completion: (()->Void)? = nil)
///
extension VersionManager_Loading_Tests {
    
    // MARK: - T - Load Cached Versions
    ///
    /// Tests the function:
    ///
    ///     private func loadCachedVersions()
    ///
    /// The following behavior is expected:
    /// 1. Queries the cacheInterfacer for its cacherVersions() and sets the result as the currentVersions store.
    ///
    func test_loadCachedVersions() {
        
        var expectedCacheVersions: VersionStore
        let versionSource: VersionSource = .init(bundleFile: nil, remoteFile: .init(urlString: ""))
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setDelegate(to: self)
        versionManager.setVersionSource(to: versionSource)
        
        // Pre Behavior:
        
            XCTAssertEqual(versionManager.test_currentVersions.count, 0)
        
        // Behavior #1 - 1:
        
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.s
            cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: versionManager.test_sessionID)
            versionManager.test_loadCachedVersions()
            
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedCacheVersions.test_resourceVersions)
            
            versionManager.test_cacheInterfacer.clearCaches()
            versionManager.test_cacheInterfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 2:
            
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.m
            cacheVersions(from: TestingResources.BundleFileNames.Versions.m, forSession: versionManager.test_sessionID)
            versionManager.test_loadCachedVersions()
            
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedCacheVersions.test_resourceVersions)
            
            versionManager.test_cacheInterfacer.clearCaches()
            versionManager.test_cacheInterfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 3:
            
            expectedCacheVersions = TestingResources.BundleFileContents.Versions.l
            cacheVersions(from: TestingResources.BundleFileNames.Versions.l, forSession: versionManager.test_sessionID)
            versionManager.test_loadCachedVersions()
            
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedCacheVersions.test_resourceVersions)
    }
    
    // MARK: - T - Load Bundle Values
    ///
    /// Tests the function:
    ///
    ///     private func loadBundleVersions()
    ///
    /// The following behavior is expected:
    /// 1. The bundleInerfacer should return any bundled versions for the given VersionSource.
    /// 2. broadcastAnyNewerVersions(...) is called with the new set of versions.
    /// 3. If no corresponding bundle versions exist, the bundledVersion store should be emptied.
    ///
    func test_loadBundleVersions() {
        
        var versionSource: VersionSource
        var expectedVersions: VersionStore
        versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
        versionManager.setDelegate(to: self)
        
        // Behavior #1 - 1:
            expectedVersions = TestingResources.BundleFileContents.Versions.s
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.s, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: ""))
            versionManager.setVersionSource(to: versionSource)
                
            XCTAssertEqual(versionManager.test_bundledVersions.count, expectedVersions.count)
        
            expectedVersions.forEachResource { resourceID, version in
                let currentVersion = versionManager.test_currentVersions.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
        // Behavior #2 - 1:
            XCTAssertEqual(newerVersionCallCount, expectedVersions.count)
            newerVersionCallCount = 0
            
        // Behavior #1 - 2:
            expectedVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: ""))
            versionManager.setVersionSource(to: versionSource)
            versionManager.test_loadBundleVersions()
                
            XCTAssertEqual(versionManager.test_bundledVersions.count, expectedVersions.count)
        
            expectedVersions.forEachResource { resourceID, version in
                let currentVersion = versionManager.test_currentVersions.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
        // Behavior #2 - 2:
            XCTAssertEqual(newerVersionCallCount, expectedVersions.count)
            newerVersionCallCount = 0
            
        // Behavior #3:
            expectedVersions = .init()
            versionSource = VersionSource(bundleFile: BundleFile(fileName: "dfgdfg", fileExtension: "sdfs"), remoteFile: RemoteFile(urlString: ""))
            versionManager.setVersionSource(to: versionSource)
            versionManager.test_loadBundleVersions()
                
            XCTAssertEqual(versionManager.test_bundledVersions.count, expectedVersions.count)
            
        // Behavior #2 - 3:
            XCTAssertEqual(newerVersionCallCount, 0)
    }
    
    // MARK: - T - Fetch Remote Values
    ///
    /// Tests the function:
    ///
    ///     private func fetchRemoteVersions(withCompletion completion: (()->Void)? = nil)
    ///
    /// The following behavior is expected:
    /// 1. The remoteInterfacer fetches versions using a supplied VersionSource, setting them into the remoteVersions property
    /// 2. broadcastAnyNewerVersions is called
    ///
    func test_fetchRemoteVersions() {
        
        var versionSource: VersionSource
        var expectedVersions: VersionStore
        var expectedBundleVersions: VersionStore?
        var exp: XCTestExpectation
        
        // Pre Behavior:

            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.clearCaches()
        
            XCTAssertEqual(versionManager.test_remoteVersions.count, 0)
        
        // Behavior #1 - 1:
        
            expectedVersions = TestingResources.BundleFileContents.Versions.s
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.s))
            versionManager.setVersionSource(to: versionSource)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.test_fetchRemoteVersions(withCompletion: {
                exp.fulfill()
            })
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
            XCTAssertEqual(versionManager.test_remoteVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
        
        // Behavior #1 - 2:

            expectedBundleVersions = TestingResources.BundleFileContents.Versions.l
            expectedVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.l, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.m))
            versionManager.setVersionSource(to: versionSource)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.test_fetchRemoteVersions(withCompletion: {
                exp.fulfill()
            })
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
            XCTAssertEqual(versionManager.test_remoteVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
        
        // Behavior #2 - 1:

            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.clearCaches()
            versionManager.setDelegate(to: self)
            newerVersionCallCount = 0

            expectedBundleVersions = nil
            expectedVersions = TestingResources.BundleFileContents.Versions.s
            versionSource = VersionSource(bundleFile: nil, remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.s))
            versionManager.setVersionSource(to: versionSource)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.test_fetchRemoteVersions(withCompletion: {
                exp.fulfill()
            })
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }

            XCTAssertEqual(versionManager.test_remoteVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
            XCTAssertEqual(newerVersionCallCount, expectedVersions.count)
        
        // Behavior #2 - 2:

            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.clearCaches()
            versionManager.setDelegate(to: self)
            newerVersionCallCount = 0
        
            expectedBundleVersions = TestingResources.BundleFileContents.Versions.l
            expectedVersions = TestingResources.BundleFileContents.Versions.m
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.l, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.m))
            versionManager.setVersionSource(to: versionSource)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.test_fetchRemoteVersions(withCompletion: {
                exp.fulfill()
            })
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
            
            XCTAssertNotEqual(versionManager.test_currentVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
            XCTAssertEqual(newerVersionCallCount, expectedBundleVersions!.count)
        
        // Behavior #2 - 3:
            
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            versionManager.clearCaches()
            versionManager.setDelegate(to: self)
            newerVersionCallCount = 0
        
            expectedBundleVersions = TestingResources.BundleFileContents.Versions.m
            expectedVersions = TestingResources.BundleFileContents.Versions.l
            versionSource = VersionSource(bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: RemoteFile(urlString: "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.l))
            versionManager.setVersionSource(to: versionSource)
        
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            versionManager.test_fetchRemoteVersions(withCompletion: {
                exp.fulfill()
            })
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
            
            XCTAssertEqual(versionManager.test_currentVersions.test_resourceVersions, expectedVersions.test_resourceVersions)
            XCTAssertEqual(newerVersionCallCount, expectedVersions.count + expectedBundleVersions!.count)
    }
}

// MARK: - Helper Functions -

extension VersionManager_Loading_Tests: VersionManagerDelegate {
    
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
        versionManager.resourceCached(forID: resourceID, withVersion: locatedVersions.byVersion_descending.first!.version)
    }
}

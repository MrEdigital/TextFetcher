///
///  CachedResourceInterfacer_Retrieval_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// CachedResourceInterfacer Unit Tests - Retrieval
///
class CachedResourceInterfacer_Retrieval_Tests: XCTestCase {
    
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
///     func cachedVersions() -> VersionManager.Versions?
///     func cachedText(forSource textSource: TextSource) -> String?
///
extension CachedResourceInterfacer_Retrieval_Tests {

    // MARK: - T - Cached Versions
    ///
    /// Tests the function:
    ///
    ///     func cachedVersions() -> VersionManager.Versions?
    ///
    /// The following behavior is expected:
    /// 1. Loads Data from the Version file in the Cache Directory, decodes it into a [String: String] dictionary, maps it to [String: Version] and returns the result
    /// 2. Should any of that fail, nil is returned
    ///
    func test_cachedVersions() {
        
        var cachedVersions: VersionStore?
        var expectedVersions: VersionStore
        
        // Behavior #1 - 1:
        
            interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
            cacheVersions(from: TestingResources.BundleFileNames.Versions.s, forSession: interfacer.test_sessionID)
            
            expectedVersions = TestingResources.BundleFileContents.Versions.s
            cachedVersions = interfacer.cachedVersions()
            XCTAssertNotNil(cachedVersions)
            XCTAssertEqual(cachedVersions?.count, cachedVersions?.count)
                
            expectedVersions.forEachResource { resourceID, version in
                let currentVersion = cachedVersions?.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
            
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 2:
        
            interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
            cacheVersions(from: TestingResources.BundleFileNames.Versions.m, forSession: interfacer.test_sessionID)
            
            expectedVersions = TestingResources.BundleFileContents.Versions.m
            cachedVersions = interfacer.cachedVersions()
            XCTAssertNotNil(cachedVersions)
            XCTAssertEqual(cachedVersions?.count, cachedVersions?.count)
                
            expectedVersions.forEachResource { resourceID, version in
                let currentVersion = cachedVersions?.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
            
            
        // Behavior #2:

            interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
            cachedVersions = interfacer.cachedVersions()
        
            XCTAssertNil(cachedVersions)
    }
    
    // MARK: - T - Cached Text For Source
    ///
    /// Tests the function:
    ///
    ///     func cachedText(forSource textSource: TextSource) -> String?
    ///
    /// The following behavior is expected:
    /// 1. Loads Data from the Cache Directory using the textSource.identifier, decodes it as UTF-8 into a String value, and returns the result
    /// 2. Should any of that fail, nil is returned
    ///
    func test_cachedTextForSource() {
        
        var cachedText: String?
        var expectedText: String
        
        // Behavior #1 - 1:
        
            interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
            cacheText(from: TestingResources.BundleFileNames.Texts.s, forSession: interfacer.test_sessionID)
        
            expectedText = TestingResources.BundleFileContents.Texts.s
            cachedText = interfacer.cachedText(forSource: TextSource(identifier: TestingResources.BundleFileNames.Texts.s, bundleFile: nil, remoteFile: nil))
        
            XCTAssertEqual(cachedText, expectedText)
            
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
            
        // Behavior #1 - 2:
        
            cacheText(from: TestingResources.BundleFileNames.Texts.m, forSession: interfacer.test_sessionID)
        
            expectedText = TestingResources.BundleFileContents.Texts.m
            cachedText = interfacer.cachedText(forSource: TextSource(identifier: TestingResources.BundleFileNames.Texts.m, bundleFile: nil, remoteFile: nil))
        
            XCTAssertEqual(cachedText, expectedText)
            
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
            
        // Behavior #2:
        
            interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
            cachedText = interfacer.cachedText(forSource: TextSource(identifier: TestingResources.BundleFileNames.Texts.s, bundleFile: nil, remoteFile: nil))
            XCTAssertNil(cachedText)
    }
}

// MARK: - Helper Functions... -

extension CachedResourceInterfacer_Retrieval_Tests {
    
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
    
    // MARK: - Cache Text
    ///
    func cacheText(from fileName: String, forSession sessionID: String) {
        guard let path = Bundle(for: Self.self).path(forResource: fileName, ofType: TestingResources.BundleFileNames.Texts.extension) else {
            return XCTFail()
        }
        do {
            let toURL = CachedResourceInterfacer.fileURL(forTextSource: TextSource(identifier: fileName, bundleFile: nil, remoteFile: nil), inSession: sessionID)
            try FileManager.default.copyItem(at: URL(fileURLWithPath: path), to: toURL)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}

///
///  CachedResourceInterfacer_Saving_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// CachedResourceInterfacer Unit Tests - Saving
///
class CachedResourceInterfacer_Saving_Tests: XCTestCase {
    
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
///     func saveToCache(_ versions: VersionManager.Versions)
///     func saveToCache(_ text: String, forSource textSource: TextSource)
///
extension CachedResourceInterfacer_Saving_Tests {
    
    // MARK: - T - Save To Cache - Versions
    ///
    /// Tests the function:
    ///
    ///     func saveToCache(_ versions: VersionManager.Versions)
    ///
    /// The following behavior is expected:
    /// 1 - Maps the supplied versions to [String: String] format, encodes it to JSON, and writes it into the Cache Directory, or not, should the write fail.
    ///
    func test_saveToCache_versions() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        var expectedVersions: VersionStore
        var cachedVersions: VersionStore?
        
        // Pre Behavior:
        
            cachedVersions = interfacer.cachedVersions()
            XCTAssertNil(cachedVersions)
        
        // Behavior #1 - 1:
        
            expectedVersions = TestingResources.BundleFileContents.Versions.s
            interfacer.saveToCache(expectedVersions)
        
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
        
            expectedVersions = TestingResources.BundleFileContents.Versions.m
            interfacer.saveToCache(expectedVersions)
        
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
            
    }
    
    // MARK: T - Save To Cache - Text
    ///
    /// Tests the function:
    /// 1 - Encodes the provided text as UTF-8, and writes the resulting data into the Cache Directory named using the provided textSource.identifier, or not, should the write fail.
    ///
    ///     func saveToCache(_ text: String, forSource textSource: TextSource)
    ///
    /// The following behavior is expected:
    ///
    func test_saveToCache_text() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        var textSource: TextSource
        var expectedText: String
        var cachedText: String?
        
        // Pre Behavior:
        
            cachedText = interfacer.cachedText(forSource: TextSource(identifier: TestingResources.BundleFileNames.Texts.s, bundleFile: nil, remoteFile: nil))
            XCTAssertNil(cachedText)
        
        // Behavior #1 - 1:
        
            expectedText = TestingResources.BundleFileContents.Texts.s
            textSource = TextSource(identifier: TestingResources.BundleFileNames.Texts.s, bundleFile: nil, remoteFile: nil)
            interfacer.saveToCache(expectedText, forSource: textSource)
        
            cachedText = interfacer.cachedText(forSource: TextSource(identifier: TestingResources.BundleFileNames.Texts.s, bundleFile: nil, remoteFile: nil))
            XCTAssertNotNil(cachedText)
            XCTAssertEqual(cachedText, expectedText)
        
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
        
        // Behavior #1 - 2:
        
            expectedText = TestingResources.BundleFileContents.Texts.m
            textSource = TextSource(identifier: TestingResources.BundleFileNames.Texts.m, bundleFile: nil, remoteFile: nil)
            interfacer.saveToCache(expectedText, forSource: textSource)
        
            cachedText = interfacer.cachedText(forSource: textSource)
            XCTAssertNotNil(cachedText)
            XCTAssertEqual(cachedText, expectedText)
            
            interfacer.clearCaches()
            interfacer.test_createLocalDirectoryIfNeeded()
    }
}

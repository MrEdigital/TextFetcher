///
///  TextManager_Saving_Tests.swift
///  Created on 7/24/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Saving
///
class TextManager_Saving_Tests: XCTestCase {
    var textManager: TextManager!
    
    var mockCacheInterfacer: Mock_CacheResourceInterfacer!
    var mockVersionManager: Mock_VersionManager!
    
    var versionIncreaseCount: Int = 0
    var versionIncreasedTo: Version?
    var versionIncreaseTextSource: TextSource?
    
    func resetTextManager(withSessionID sessionID: String) {
        mockCacheInterfacer = .init()
        mockVersionManager = .init()
        textManager = .init(withSessionID: sessionID,
                            cacheInterfacer: mockCacheInterfacer,
                            remoteInterfacer: RemoteResourceInterfacer(),
                            bundleInterfacer: BundledResourceInterfacer(),
                            versionManager: mockVersionManager)
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private func cacheText(_ text: String?, forSource textSource: TextSource, withVersion version: Version?)
///
extension TextManager_Saving_Tests {
    
    // MARK: - T - Cache Text For Source
    ///
    /// Tests the function:
    ///
    ///     private func cacheText(_ text: String?, forSource textSource: TextSource, withVersion version: Version?)
    ///
    /// The following behavior is expected:
    /// 1. Returns immediately if text is nil
    /// 2. Calls saveToCache(...) on the cacheInterfacer
    /// 3. Calls resourceCached(...) on the versionManager
    /// 4. Calls versionIncreased(...) on the delegate
    /// 5. If no Version is provided, .zero is assumed
    ///
    func test_cacheText() {
        
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        textManager.setDelegate(to: self)
        
        let textToCache = "dgfdg"
        let textSource: TextSource = .init(identifier: "sddgfd", bundleFile: BundleFile(fileName: "dffgf", fileExtension: "dsfd"), remoteFile: RemoteFile(urlString: "dsfgfd4s"))
        let version: Version = .init(major: 3242, minor: 2342, patch: 23)
        
        // Behavior #1:
        
            textManager.test_cacheText(nil, forSource: textSource, withVersion: version)
        
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 0)
            XCTAssertNil(mockCacheInterfacer.mock_saveSource)
        
        // Behavior #2:
        
            textManager.test_cacheText(textToCache, forSource: textSource, withVersion: version)
        
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 1)
            XCTAssertEqual(mockCacheInterfacer.mock_saveSource?.identifier, textSource.identifier)
            XCTAssertEqual(mockCacheInterfacer.mock_saveSource?.bundleFile?.fileName, textSource.bundleFile?.fileName)
            XCTAssertEqual(mockCacheInterfacer.mock_saveSource?.bundleFile?.fileExtension, textSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockCacheInterfacer.mock_saveSource?.remoteFile?.urlString, textSource.remoteFile?.urlString)
        
        // Behavior #3:
        
            XCTAssertEqual(mockVersionManager.mock_resourceCacheCount, 1)
            XCTAssertEqual(mockVersionManager.mock_resourceCacheVersion, version)
            
        // Behavior #4:
        
            XCTAssertEqual(versionIncreaseCount, 1)
            XCTAssertEqual(versionIncreasedTo, version)
            XCTAssertEqual(versionIncreaseTextSource?.identifier, textSource.identifier)
            XCTAssertEqual(versionIncreaseTextSource?.bundleFile?.fileName, textSource.bundleFile?.fileName)
            XCTAssertEqual(versionIncreaseTextSource?.bundleFile?.fileExtension, textSource.bundleFile?.fileExtension)
            XCTAssertEqual(versionIncreaseTextSource?.remoteFile?.urlString, textSource.remoteFile?.urlString)
            
        // Behavior #5:
        
            textManager.test_cacheText(textToCache, forSource: textSource, withVersion: nil)
            XCTAssertEqual(mockVersionManager.mock_resourceCacheVersion, .zero)
    }
}

// MARK: - Delegation Conformance

extension TextManager_Saving_Tests: TextManagerDelegate {
    
    func versionIncreased(to version: Version, for textSource: TextSource) {
        versionIncreaseCount += 1
        versionIncreasedTo = version
        versionIncreaseTextSource = textSource
    }
}

// MARK: - Mock Classes

extension TextManager_Saving_Tests {
    
    class Mock_CacheResourceInterfacer: CachedResourceInterfacer_TextManagerInterface {
        
        var mock_saveCount: Int = 0
        var mock_saveSource: TextSource?
        
        func saveToCache(_ text: String, forSource textSource: TextSource) {
            mock_saveCount += 1
            mock_saveSource = textSource
        }
        
        // Unused
        func cachedText(forSource textSource: TextSource) -> String? { "" }
        func clearCaches() {}
    }
    
    class Mock_VersionManager: VersionManager_TextManagerInterface {
        var versionSource: VersionSource?
        var mock_resourceCacheCount: Int = 0
        var mock_resourceCacheVersion: Version?
        
        func resourceCached(forID resourceID: ResourceID, withVersion version: Version) {
            mock_resourceCacheCount += 1
            mock_resourceCacheVersion = version
        }

        // Unused
        func setResourceBundle(to bundle: Bundle) {}
        func setVersionSource(to versionSource: VersionSource, withCompletion completion: (() -> Void)? = nil) {}
        func allVersions(ofResource resourceID: ResourceID) -> [LocationBoundVersion] { [] }
        func resourceRegistered(forID resourceID: ResourceID) {}
        func setDelegate(to delegate: VersionManagerDelegate?) {}
        func cachedVersion(forResource resourceID: ResourceID) -> Version { .zero }
        func clearCaches() {}
    }
}


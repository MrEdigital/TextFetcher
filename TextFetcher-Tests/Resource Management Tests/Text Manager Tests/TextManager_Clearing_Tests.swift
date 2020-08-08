///
///  TextManager_Clearing_Tests.swift
///  Created on 7/24/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Clearing
///
class TextManager_Clearing_Tests: XCTestCase {
    var textManager: TextManager!
    
    var mockCacheInterfacer: Mock_CacheResourceInterfacer!
    
    func resetTextManager(withSessionID sessionID: String) {
        mockCacheInterfacer = .init()
        textManager = .init(withSessionID: sessionID,
                            cacheInterfacer: mockCacheInterfacer,
                            remoteInterfacer: RemoteResourceInterfacer(),
                            bundleInterfacer: BundledResourceInterfacer(),
                            versionManager: VersionManager(withSessionID: sessionID))
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func clearCaches()
///
extension TextManager_Clearing_Tests {
    
    // MARK: - T - Clear Caches
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     func clearCaches()
    ///
    /// The following behavior is expected:
    /// 1. The clearCaches() method should be called on the cacheInterfacer
    ///
    func test_clearCaches() {
        
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        textManager.clearCaches()
        
        // Behavior #1:
            XCTAssertEqual(mockCacheInterfacer.mock_clearCount, 1)
    }
}


// MARK: - Mock Classes

extension TextManager_Clearing_Tests {
    
    class Mock_CacheResourceInterfacer: CachedResourceInterfacer_TextManagerInterface {
        
        var mock_clearCount: Int = 0
        
        func clearCaches() {
            mock_clearCount += 1
        }
        
        // Unused
        func saveToCache(_ text: String, forSource textSource: TextSource) {}
        func cachedText(forSource textSource: TextSource) -> String? { "" }
    }
}

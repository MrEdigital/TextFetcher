///
///  TextManager_VersionManager_Delegation_Tests.swift
///  Created on 7/24/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - VersionManager Delegation
///
class TextManager_VersionManager_Delegation_Tests: XCTestCase {
    var textManager: TextManager!
    
    static let cachedText  = "dgdfgdfgfdgdfgdfgg554g54g44g"
    static let bundledText = "h3rhouyr98ur948fh3ofgg4g4v4v"
    static let remoteText  = "k23nm,2n3rhio2h094r2nklefdsf"
    
    var mockBundleInterfacer: Mock_BundledResourceInterfacer!
    var mockRemoteInterfacer: Mock_RemoteResourceInterfacer!
    var mockCacheInterfacer: Mock_CacheResourceInterfacer!
    
    func resetTextManager(withSessionID sessionID: String) {
        mockBundleInterfacer = .init()
        mockRemoteInterfacer = .init()
        mockCacheInterfacer = .init()
        
        clearCaches()
        textManager = .init(withSessionID: sessionID,
                            cacheInterfacer: mockCacheInterfacer,
                            remoteInterfacer: mockRemoteInterfacer,
                            bundleInterfacer: mockBundleInterfacer,
                            versionManager: VersionManager(withSessionID: sessionID))
    }
    
    override func tearDown() {
        super.tearDown()
        clearCaches()
    }
    
    private func clearCaches() {
        CachedResourceInterfacer(withSessionID: textManager?.test_sessionID ?? "").clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func newestVersionLocated(_ version: Version, forID resourceID: String, at location: ResourceLocation)
///
extension TextManager_VersionManager_Delegation_Tests {
    
    // MARK: - T - Newer Version Found
    ///
    /// Tests the function:
    ///
    ///     func newestVersionLocated(_ version: Version, forID resourceID: String, at location: ResourceLocation)
    ///
    /// The following behavior is expected:
    /// 1. If an ID is provided does not match a registered TextSource, the function will immediately be returned
    /// 2. If the location matches .cache, the function will return
    /// 3. If the location matches .bundle, then loadBundleText is called, which calls bundleInterfacer.text(...), and then the end result is then cached using the cacheText(...) method .
    /// 4. If the location matches .remote, then loadRemoteText is called, which calls remoteInterfacer.fetch(...), and then the end result is then cached using the cacheText(...) method .
    ///
    func test_newerVersionFound() {

        let textSource: TextSource = .init(identifier: "sdfg", bundleFile: BundleFile(fileName: "gdgdfge", fileExtension: "egrre"), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:

            textManager.newerVersionsLocated([.init(version: .zero, location: .bundle)], forResource: "ertert")
            XCTAssertEqual(mockBundleInterfacer.mock_textCount, 0)
            XCTAssertEqual(mockRemoteInterfacer.mock_fetchCount, 0)
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 0)
            
        // Behavior #1:

            textManager.test_setTextSources([textSource])

            textManager.newerVersionsLocated([.init(version: .zero, location: .cache)], forResource: textSource.identifier)
            XCTAssertEqual(mockBundleInterfacer.mock_textCount, 0)
            XCTAssertEqual(mockRemoteInterfacer.mock_fetchCount, 0)
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 0)
        
        // Behavior #3:

            textManager.test_setTextSources([textSource])
            
            textManager.newerVersionsLocated([.init(version: .zero, location: .bundle)], forResource: textSource.identifier)
            XCTAssertEqual(mockBundleInterfacer.mock_textCount, 1)
            XCTAssertEqual(mockRemoteInterfacer.mock_fetchCount, 0)
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 1)
            
        // Behavior #4:

            textManager.test_setTextSources([textSource])
            
            let exp = expectation(description: "Waiting on fetch, if necessary")
            mockRemoteInterfacer.mock_onFetchCompletion = {
                exp.fulfill()
            }
            textManager.newerVersionsLocated([.init(version: .zero, location: .remote)], forResource: textSource.identifier)
        
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
            XCTAssertEqual(mockBundleInterfacer.mock_textCount, 1)
            XCTAssertEqual(mockRemoteInterfacer.mock_fetchCount, 1)
            XCTAssertEqual(mockCacheInterfacer.mock_saveCount, 2)
    }
}

// MARK: - Mock Classes

extension TextManager_VersionManager_Delegation_Tests {
    
    class Mock_BundledResourceInterfacer: BundledResourceInterfacer_TextManagerInterface {
        var mock_textCount: Int = 0
        
        func text(forSource textSource: TextSource) -> String? {
            mock_textCount += 1
            return TextManager_Loading_Tests.bundledText
        }
        
        // Unused
        func setBundle(to bundle: Bundle) {}
    }
    
    class Mock_RemoteResourceInterfacer: RemoteResourceInterfacer_TextManagerInterface {
        var mock_fetchCount: Int = 0
        var mock_onFetchCompletion: (()->Void)? = nil
        
        func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion) {
            mock_fetchCount += 1
            
            DispatchQueue.global().async { // Loosely simulates the asynchronaity of a remote fetch
                DispatchQueue.main.async {
                    completion(TextManager_Loading_Tests.remoteText)
                    self.mock_onFetchCompletion?()
                }
            }
        }
        
        // Unused
        func setResourceTimeout(to timeout: TimeInterval) {}
    }
    
    class Mock_CacheResourceInterfacer: CachedResourceInterfacer_TextManagerInterface {
        var mock_saveCount: Int = 0
        
        func saveToCache(_ text: String, forSource textSource: TextSource) {
            mock_saveCount += 1
        }
        
        // Unused
        func cachedText(forSource textSource: TextSource) -> String? { return nil }
        func clearCaches() {}
    }
}

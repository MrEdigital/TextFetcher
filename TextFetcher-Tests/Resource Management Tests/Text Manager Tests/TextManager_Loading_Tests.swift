///
///  TextManager_Loading_Tests.swift
///  Created on 7/24/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Loading
///
class TextManager_Loading_Tests: XCTestCase {
    var textManager: TextManager!
    
    static let cachedText  = "dgdfgdfgfdgdfgdfgg554g54g44g"
    static let bundledText = "h3rhouyr98ur948fh3ofgg4g4v4v"
    static let remoteText  = "k23nm,2n3rhio2h094r2nklefdsf"
    
    let versionsS = TestingResources.BundleFileContents.Versions.s
    let versionsM = TestingResources.BundleFileContents.Versions.m
    let versionsL = TestingResources.BundleFileContents.Versions.l
    
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
        
        textManager.setResourceTimeout(to: 0.5)
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
///     func cachedText(forResource resourceID: String, completion: @escaping TextFetchCompletion)
///     private func loadBundledText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
///     private func loadCachedText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
///     private func loadRemoteText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
///
extension TextManager_Loading_Tests {
    
    // MARK: - T - Cached Text with ID
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     func cachedText(forResource resourceID: String, completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If an ID is provided which does not match a registered TextSource, the completion should immediately return nil
    /// 2. loadCachedText should be called, and the result returned
    ///
    func test_cachedTextWithID() {
        
        var textSource: TextSource
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:

            textManager.test_setTextSources([]) // No text sources

            var exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.cachedText(forResource: "sdfg", completion: { text, version in
                XCTAssertNil(text)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #2 - 1:
        
            textSource = .init(identifier: "sdfg", bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
            textManager.test_setTextSources([textSource])

            exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.cachedText(forResource: textSource.identifier, completion: { text, version in
                XCTAssertNil(text)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
            
        // Behavior #2 - 2:
        
            textSource = .init(identifier: "sdfg", bundleFile: nil, remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
            textManager.test_setTextSources([textSource])

            exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.cachedText(forResource: textSource.identifier, completion: { text, version in
                XCTAssertEqual(text, TextManager_Loading_Tests.cachedText)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 1)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
    }
    
    // MARK: - T - Latest Text with ID
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     func latestText(forResource resourceID: String, completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If an ID is provided which does not match a registered TextSource, the completion should immediately return nil
    /// 2. If the latest version location is .cache, the cached corresponding text should return.  If no text is found, nil is returned.
    /// 3. If the latest version location is .bundle, the bundled corresponding text should return.  If no text is returned, cached text (or nil) is returned instead.
    /// 4. If the latest version location is .remote, the remote corresponding text should return.  If no text is returned, cached text (or nil) is returned instead..
    ///
    func test_latestTextWithID() {
        
        var textSource: TextSource
        var exp: XCTestExpectation
        
        for textSourceID in versionsS.allResourceIDs {
            
            // Behavior #1:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textManager.test_setTextSources([]) // No text sources

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertNil(text)
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #2:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsL)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsM)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsS)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.bundledText)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #3 - 1:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsM)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsL)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsS)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.bundledText)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #3 - 2:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: nil, remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsM)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsL)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsS)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 1)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 0)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.cachedText)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #4 - 1:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsM)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsS)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsL)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 0)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 1)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.remoteText)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #4 - 2:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: nil)
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsM)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsS)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsL)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.bundledText)
                    exp.fulfill()
                })

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }

            // Behavior #4 - 3:

                resetTextManager(withSessionID: "\(Self.self).\(#function)")

                textSource = .init(identifier: textSourceID, bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: nil)
                textManager.test_setTextSources([textSource])

                textManager.test_versionManager?.test_setCurrentVersions(to: versionsM)
                textManager.test_versionManager?.test_setBundleVersions(to: versionsS)
                textManager.test_versionManager?.test_setRemoteVersions(to: versionsL)

                exp = expectation(description: "Waiting on fetch, if necessary")
                textManager.latestText(forResource: textSourceID, completion: { text, version in
                    XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                    XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                    XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.identifier, textSource.identifier)
                    XCTAssertEqual(text, Self.bundledText)
                    exp.fulfill()
                })

                textManager = nil // this should prevent the cache from being hit, because the weak self in the completion block should be released

                waitForExpectations(timeout: 1) { error in
                    XCTAssertNil(error)
                }
        }
    }
    
    // MARK: - T - Load Bundled Text
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func loadBundledText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. text(...) is called on the bundleInterfacer
    ///
    func test_loadBundledText() {
        
        var textSource: TextSource
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1 - 1:
        
            textSource = .init(identifier: "sdfg", bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))

            var exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.test_loadBundledText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertEqual(text, TextManager_Loading_Tests.bundledText)
                XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                XCTAssertEqual(self.mockBundleInterfacer.mock_textSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
            
        // Behavior #1 - 2:
        
            textSource = .init(identifier: "sdfg", bundleFile: nil, remoteFile: RemoteFile(urlString: "gdfgdfgdf"))

            exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.test_loadBundledText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertNil(text)
                XCTAssertEqual(self.mockBundleInterfacer.mock_textCount, 1)
                XCTAssertEqual(self.mockBundleInterfacer.mock_textSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
    }
    
    // MARK: - T - Load Cached Text
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func loadCachedText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. cachedText(...) is called on the cacheInterfacer
    ///
    func test_loadCachedText() {
        
        var textSource: TextSource
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1 - 1:
        
            textSource = .init(identifier: "sdfg", bundleFile: BundleFile(fileName: "", fileExtension: ""), remoteFile: RemoteFile(urlString: "gdfgdfgdf"))

            var exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.test_loadCachedText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertNil(text)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 0)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
            
        // Behavior #1 - 2:
        
            textSource = .init(identifier: "sdfg", bundleFile: nil, remoteFile: RemoteFile(urlString: "gdfgdfgdf"))

            exp = expectation(description: "Waiting on fetch, if necessary")
            textManager.test_loadCachedText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertEqual(text, TextManager_Loading_Tests.cachedText)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextCount, 1)
                XCTAssertEqual(self.mockCacheInterfacer.mock_cachedTextSource?.identifier, textSource.identifier)
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
    }
    
    // MARK: - T - Load Remote Text
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     private func loadRemoteText(forSource textSource: TextSource, completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. fetch is called on the remoteInterfacer and the result of the fetch is returned via the compltion block
    ///
    func test_loadRemoteText() {
        
        var textSource: TextSource
        resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1 - 1:
        
            textSource = .init(identifier: "sdfg", bundleFile: nil, remoteFile: nil)
            
            var exp = expectation(description: "Waiting on (Simulated) Remote Fetch")
            textManager.test_loadRemoteText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 0)
                XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.identifier, textSource.identifier)
                XCTAssertNil(text)
                
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #1 - 2:
        
            textSource = .init(identifier: "sdfg", bundleFile: nil, remoteFile: RemoteFile(urlString: "gdfgdfgdf"))
            
            exp = expectation(description: "Waiting on (Simulated) Remote Fetch")
            textManager.test_loadRemoteText(forSource: textSource, withVersion: .zero, completion: { text, version in
                XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchCount, 1)
                XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.identifier, textSource.identifier)
                XCTAssertEqual(self.mockRemoteInterfacer.mock_fetchTextSource?.remoteFile?.urlString, textSource.remoteFile?.urlString)
                XCTAssertEqual(text, TextManager_Loading_Tests.remoteText)
                
                exp.fulfill()
            })
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
    }
}

// MARK: - Mock Classes

extension TextManager_Loading_Tests {
    
    class Mock_CacheResourceInterfacer: CachedResourceInterfacer_TextManagerInterface {
        
        var mock_saveSource: TextSource?
        var mock_cachedTextCount: Int = 0
        var mock_cachedTextSource: TextSource?
        
        func cachedText(forSource textSource: TextSource) -> String? {
            mock_cachedTextSource = textSource
            
            if textSource.bundleFile == nil {
                mock_cachedTextCount += 1
                return TextManager_Loading_Tests.cachedText
            } else {
                return nil
            }
        }
        
        // Unused
        func saveToCache(_ text: String, forSource textSource: TextSource) {}
        func clearCaches() {}
    }
    
    class Mock_BundledResourceInterfacer: BundledResourceInterfacer_TextManagerInterface {
        var mock_textCount: Int = 0
        var mock_textSource: TextSource?
        
        func text(forSource textSource: TextSource) -> String? {
            mock_textSource = textSource
            
            if textSource.bundleFile == nil {
                return nil
            } else {
                mock_textCount += 1
                return TextManager_Loading_Tests.bundledText
            }
        }
        
        // Unused
        func setBundle(to bundle: Bundle) {}
    }
    
    class Mock_RemoteResourceInterfacer: RemoteResourceInterfacer_TextManagerInterface {
        var mock_fetchCount: Int = 0
        var mock_fetchTextSource: TextSource?
        
        func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion) {
            mock_fetchTextSource = textSource
            
            DispatchQueue.global().async { // Loosely simulates the asynchronaity of a remote fetch
                DispatchQueue.main.async {
                    if textSource.remoteFile != nil {
                        self.mock_fetchCount += 1
                        completion(TextManager_Loading_Tests.remoteText)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
        
        // Unused
        func setResourceTimeout(to timeout: TimeInterval) {}
    }
}


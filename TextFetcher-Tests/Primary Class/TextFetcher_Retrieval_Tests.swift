///
///  TextFetcher_Retrieval_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - Retrieval
///
class TextFetcher_Retrieval_Tests: XCTestCase {
    
    static let cachedText: String = "dgdfgdfgfdgdfgdfgg554g54g44g"
    static let cachedVersion: Version = .init(major: 123, minor: 456, patch: 678)
    
    static let latestText: String = "h3rhouyr98ur948fh3ofgg4g4v4v"
    static let latestVersion: Version = .init(major: 123, minor: 456, patch: 678)
    
    var mockTextManager: Mock_TextManager!
    
    func resetTextFetcher(withSessionID sessionID: String) {
        mockTextManager = .init()
        
        textFetcher?.clearCaches()
        textFetcher = .init(withSessionID: sessionID,
                            textManager: mockTextManager)
    }
    
    var textFetcher: TextFetcher!
    
    override func tearDown() {
        super.tearDown()
        textFetcher?.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public func text(for textSourceProvider: TextSourceProvider, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
///     public func text(for textSource: TextSource, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
///     public func text(for resourceID: String, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
///
extension TextFetcher_Retrieval_Tests {
    
    // MARK: - T - Text From Privder
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func text(for textSourceProvider: TextSourceProvider, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If awaitRemoteFetchIfNeeded is set to false, the cachedText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    /// 2. If awaitRemoteFetchIfNeeded is set to true, the latestText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    ///
    func test_textForTextProvider() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var exp: XCTestExpectation
        var textSourceProvider: Mock_TextSourceProvider
        
        // Behavior #1:
        
            textSourceProvider = .init(textSource: .init(identifier: "dffgdfg", bundleFile: nil, remoteFile: nil))
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: textSourceProvider, awaitRemoteFetchIfNeeded: false) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_cachedTextID, textSourceProvider.textSource.identifier)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.cachedText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.cachedVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #2:

            textSourceProvider = .init(textSource: .init(identifier: "ergegrere", bundleFile: nil, remoteFile: nil))
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: textSourceProvider, awaitRemoteFetchIfNeeded: true) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_latestTextID, textSourceProvider.textSource.identifier)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.latestText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.latestVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
    }
    
    // MARK: - T - Text For TextSource
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func text(for textSource: TextSource, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If awaitRemoteFetchIfNeeded is set to false, the cachedText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    /// 2. If awaitRemoteFetchIfNeeded is set to true, the latestText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    ///
    func test_textForTextSource() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var exp: XCTestExpectation
        var textSource: TextSource
        
        // Behavior #1:
        
            textSource = .init(identifier: "dffgdfg", bundleFile: nil, remoteFile: nil)
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: textSource, awaitRemoteFetchIfNeeded: false) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_cachedTextID, textSource.identifier)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.cachedText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.cachedVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #2:
        
            textSource = .init(identifier: "ergegrere", bundleFile: nil, remoteFile: nil)
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: textSource, awaitRemoteFetchIfNeeded: true) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_latestTextID, textSource.identifier)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.latestText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.latestVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
    }
    
    // MARK: - T - Text For Resource
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func text(for resourceID: String, awaitRemoteFetchIfNeeded: Bool, completion: @escaping TextRequestCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If awaitRemoteFetchIfNeeded is set to false, the cachedText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    /// 2. If awaitRemoteFetchIfNeeded is set to true, the latestText(...) method is called on the TextFetcher's TextManager, passing in the resourceID and completion.
    ///
    func test_textForResource() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var exp: XCTestExpectation
        var resourceID: ResourceID
        
        // Behavior #1:
        
            resourceID = "dffgfdgdg"
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: resourceID, awaitRemoteFetchIfNeeded: false) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_cachedTextID, resourceID)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.cachedText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.cachedVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #2:
        
            resourceID = "ergegrere"
            exp = expectation(description: "Waiting on (Mock) Fetch")
            textFetcher.text(for: resourceID, awaitRemoteFetchIfNeeded: true) { text, version in
                XCTAssertEqual(self.mockTextManager.mock_latestTextID, resourceID)
                XCTAssertEqual(text, TextFetcher_Retrieval_Tests.latestText)
                XCTAssertEqual(version, TextFetcher_Retrieval_Tests.latestVersion)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 1) { error in
                XCTAssertNil(error)
            }
        
    }
}

// MARK: - Mock Classes

extension TextFetcher_Retrieval_Tests {
    
    struct Mock_TextSourceProvider: TextSourceProvider {
        let textSource: TextSource
    }
    
    class Mock_TextManager: TextManager_TextFetcherInterface {
        
        var mock_cachedTextCount: Int = 0
        var mock_cachedTextID: ResourceID?
        func cachedText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {
            mock_cachedTextCount += 1
            mock_cachedTextID = resourceID
            completion(TextFetcher_Retrieval_Tests.cachedText, TextFetcher_Retrieval_Tests.cachedVersion)
        }
        
        var mock_latestTextCount: Int = 0
        var mock_latestTextID: ResourceID?
        func latestText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {
            mock_latestTextCount += 1
            mock_latestTextID = resourceID
            completion(TextFetcher_Retrieval_Tests.latestText, TextFetcher_Retrieval_Tests.latestVersion)
        }
        
        // Unused
        func setDelegate(to delegate: TextManagerDelegate?) {}
        func setResourceBundle(to bundle: Bundle) {}
        func setResourceTimeout(to timeout: TimeInterval) {}
        func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)?) {}
        func registerTextSource(_ textSource: TextSource) {}
        func clearCaches() {}
    }
}




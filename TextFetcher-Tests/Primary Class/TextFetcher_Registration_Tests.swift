///
///  TextFetcher_Registration_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Registration
///
class TextFetcher_Registration_Tests: XCTestCase {
    
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
///     public func registerTextSource(_ textSource: TextSource)
///     public func registerTextSource(fromProvider textSourceProvider: TextSourceProvider)
///
extension TextFetcher_Registration_Tests {
    
    // MARK: - T - Register Text Source
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func registerTextSource(_ textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. The TextFetcher's TextManager should have its registerTextSource(...) method called one time, with the provided TextSource passed in
    ///
    func test_registerTextSource() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var newTextSource: TextSource
        
        // Pre-Behavior:
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 0)
            XCTAssertNil(mockTextManager.mock_textSource)
        
        // Behavior #1 - 1:
            newTextSource = .init(identifier: "dfg34dfg", bundleFile: .init(fileName: "dfdfgdffg", fileExtension: "dff"), remoteFile: .init(urlString: "sdfdfsdf"))
            textFetcher.registerTextSource(newTextSource)
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 1)
            XCTAssertEqual(mockTextManager.mock_textSource?.identifier, newTextSource.identifier)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileName, newTextSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileExtension, newTextSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_textSource?.remoteFile?.urlString, newTextSource.remoteFile?.urlString)
        
        // Behavior #1 - 2:
            newTextSource = .init(identifier: "jhj3434hj", bundleFile: .init(fileName: "fghfgh", fileExtension: "htrhrth"), remoteFile: .init(urlString: "ww4w4t"))
            textFetcher.registerTextSource(newTextSource)
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 2)
            XCTAssertEqual(mockTextManager.mock_textSource?.identifier, newTextSource.identifier)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileName, newTextSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileExtension, newTextSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_textSource?.remoteFile?.urlString, newTextSource.remoteFile?.urlString)
    }
    
    // MARK: - T - Register Text Source From Provider
    ///
    /// TextManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func registerTextSource(fromProvider textSourceProvider: TextSourceProvider)
    ///
    /// The following behavior is expected:
    /// 1. The TextFetcher's TextManager should have its registerTextSource(...) method called one time, with the provided TextSourceProvider's TextSource passed in
    ///
    func test_registerTextSourceFromProvider() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var newTextSource: TextSource
        
        // Pre-Behavior:
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 0)
            XCTAssertNil(mockTextManager.mock_textSource)
        
        // Behavior #1 - 1:
            newTextSource = .init(identifier: "dfg34dfg", bundleFile: .init(fileName: "dfdfgdffg", fileExtension: "dff"), remoteFile: .init(urlString: "sdfdfsdf"))
            textFetcher.registerTextSource(fromProvider: Mock_TextSourceProvider(textSource: newTextSource))
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 1)
            XCTAssertEqual(mockTextManager.mock_textSource?.identifier, newTextSource.identifier)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileName, newTextSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileExtension, newTextSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_textSource?.remoteFile?.urlString, newTextSource.remoteFile?.urlString)
        
        // Behavior #1 - 2:
            newTextSource = .init(identifier: "jhj3434hj", bundleFile: .init(fileName: "fghfgh", fileExtension: "htrhrth"), remoteFile: .init(urlString: "ww4w4t"))
            textFetcher.registerTextSource(fromProvider: Mock_TextSourceProvider(textSource: newTextSource))
            XCTAssertEqual(mockTextManager.mock_registerTextSourceCount, 2)
            XCTAssertEqual(mockTextManager.mock_textSource?.identifier, newTextSource.identifier)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileName, newTextSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_textSource?.bundleFile?.fileExtension, newTextSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_textSource?.remoteFile?.urlString, newTextSource.remoteFile?.urlString)
    }
}

// MARK: - Mock Classes

extension TextFetcher_Registration_Tests {
    
    struct Mock_TextSourceProvider: TextSourceProvider {
        let textSource: TextSource
    }
    
    class Mock_TextManager: TextManager_TextFetcherInterface {
        
        var mock_registerTextSourceCount: Int = 0
        var mock_textSource: TextSource?
        func registerTextSource(_ textSource: TextSource) {
            mock_registerTextSourceCount += 1
            mock_textSource = textSource
        }
        
        // Unused
        func setDelegate(to delegate: TextManagerDelegate?) {}
        func setResourceBundle(to bundle: Bundle) {}
        func setResourceTimeout(to timeout: TimeInterval) {}
        func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)?) {}
        func cachedText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {}
        func latestText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {}
        func clearCaches() {}
    }
}


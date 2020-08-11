///
///  TextFetcher_Configuration_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - Configuration
///
class TextFetcher_Configuration_Tests: XCTestCase {
    
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
///     public func setResourceBundle(to bundle: Bundle)
///     public func setResourceTimeout(to timeout: TimeInterval)
///     public func setVersionSource(_ versionSource: VersionSource, withCompletion completion: (()->Void)? = nil)
///
extension TextFetcher_Configuration_Tests {
    
    // MARK: - T - Set Resource Bundle
    ///
    /// Tests the function:
    ///
    ///     public func setResourceBundle(to bundle: Bundle)
    ///
    /// The following behavior is expected:
    /// 1. The TextFetcher's TextManager should have its setResourceBundle(...) method called one time, with the provided bundle passed in
    ///
    func test_setResourceBundle() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var bundle: Bundle
        
        // Pre-Behavior:
            XCTAssertEqual(mockTextManager.mock_setBundleCount, 0)
        
        // Behavior #1 - 1:
            bundle = Bundle(for: Self.self)
            textFetcher.setResourceBundle(to: bundle)
            XCTAssertEqual(mockTextManager.mock_setBundleCount, 1)
            XCTAssertTrue(mockTextManager.mock_bundle === bundle)
        
        // Behavior #1 - 2:
            bundle = Bundle.main
            textFetcher.setResourceBundle(to: bundle)
            XCTAssertEqual(mockTextManager.mock_setBundleCount, 2)
            XCTAssertTrue(mockTextManager.mock_bundle === bundle)
    }
    
    // MARK: - T - Set Resource Timeout
    ///
    /// Tests the function:
    ///
    ///     public func setResourceTimeout(to timeout: TimeInterval)
    ///
    /// The following behavior is expected:
    /// 1. The TextFetcher's TextManager should have its setResourceTimeout(...) method called one time, with the provided TimeInterval passed in
    ///
    func test_setResourceTimeout() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var newTimeout: TimeInterval = 1234
        
        // Pre-Behavior:
            XCTAssertEqual(mockTextManager.mock_setResourceTimeoutCount, 0)
            XCTAssertNotEqual(mockTextManager.mock_resourceTimeout, newTimeout)
        
        // Behavior #1:
            textFetcher.setResourceTimeout(to: newTimeout)
            XCTAssertEqual(mockTextManager.mock_setResourceTimeoutCount, 1)
            XCTAssertEqual(mockTextManager.mock_resourceTimeout, newTimeout)
            
        // Behavior #2:
            newTimeout = 432423
            textFetcher.setResourceTimeout(to: newTimeout)
            XCTAssertEqual(mockTextManager.mock_setResourceTimeoutCount, 2)
            XCTAssertEqual(mockTextManager.mock_resourceTimeout, newTimeout)
    }
    
    // MARK: - T - Set Version Source
    ///
    /// Tests the function:
    ///
    ///     public func setVersionSource(_ versionSource: VersionSource, withCompletion completion: (()->Void)? = nil)
    ///
    /// The following behavior is expected:
    /// 1. The TextFetcher's TextManager should have its setVersionSource(...) method called one time, with the provided VersionSource passed in 
    ///
    func test_setVersionSource() {
        
        resetTextFetcher(withSessionID: "\(Self.self).\(#function)")
        var newVersionSource: VersionSource
        
        // Pre-Behavior:
            XCTAssertEqual(mockTextManager.mock_setVersionSourceCount, 0)
            XCTAssertNil(mockTextManager.mock_versionSource)
            XCTAssertNil(mockTextManager.mock_versionSourceCompletion)
        
        // Behavior #1 - 1:
            newVersionSource = .init(bundleFile: .init(fileName: "dfdfgdffg", fileExtension: "dff"), remoteFile: .init(urlString: "sdfdfsdf"))
            textFetcher.setVersionSource(to: newVersionSource, withCompletion: {})
            XCTAssertEqual(mockTextManager.mock_setVersionSourceCount, 1)
            XCTAssertEqual(mockTextManager.mock_versionSource?.bundleFile?.fileName, newVersionSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_versionSource?.bundleFile?.fileExtension, newVersionSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_versionSource?.remoteFile.urlString, newVersionSource.remoteFile.urlString)
            XCTAssertNotNil(mockTextManager.mock_versionSourceCompletion)
        
        // Behavior #1 - 2:
            newVersionSource = .init(bundleFile: .init(fileName: "fghfgh", fileExtension: "htrhrth"), remoteFile: .init(urlString: "ww4w4t"))
            textFetcher.setVersionSource(to: newVersionSource, withCompletion: {})
            XCTAssertEqual(mockTextManager.mock_setVersionSourceCount, 2)
            XCTAssertEqual(mockTextManager.mock_versionSource?.bundleFile?.fileName, newVersionSource.bundleFile?.fileName)
            XCTAssertEqual(mockTextManager.mock_versionSource?.bundleFile?.fileExtension, newVersionSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockTextManager.mock_versionSource?.remoteFile.urlString, newVersionSource.remoteFile.urlString)
            XCTAssertNotNil(mockTextManager.mock_versionSourceCompletion)
    }
}

// MARK: - Mock Classes

extension TextFetcher_Configuration_Tests {
    
    class Mock_TextManager: TextManager_TextFetcherInterface {
        
        var mock_setBundleCount: Int = 0
        var mock_bundle: Bundle?
        func setResourceBundle(to bundle: Bundle) {
            mock_setBundleCount += 1
            mock_bundle = bundle
        }
        
        var mock_setResourceTimeoutCount: Int = 0
        var mock_resourceTimeout: TimeInterval?
        func setResourceTimeout(to timeout: TimeInterval) {
            mock_setResourceTimeoutCount += 1
            mock_resourceTimeout = timeout
        }
        
        var mock_setVersionSourceCount: Int = 0
        var mock_versionSource: VersionSource?
        var mock_versionSourceCompletion: (()->Void)?
        func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)?) {
            mock_setVersionSourceCount += 1
            mock_versionSource = versionSource
            mock_versionSourceCompletion = completion
            completion?()
        }
        
        // Unused
        func setDelegate(to delegate: TextManagerDelegate?) {}
        func registerTextSource(_ textSource: TextSource) {}
        func cachedText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {}
        func latestText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {}
        func clearCaches() {}
    }
}

///
///  TextManager_Configuration.swift
///  Created on 7/24/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Configuration
///
class TextManager_Configuration_Tests: XCTestCase {
    
    var mockBundleInterfacer: Mock_BundledResourceInterfacer!
    var mockRemoteInterfacer: Mock_RemoteResourceInterfacer!
    var mockVersionManager: Mock_VersionManager!
    
    func resetTextManager(withSessionID sessionID: String) {
        mockBundleInterfacer = .init()
        mockRemoteInterfacer = .init()
        mockVersionManager = .init()
        
        textManager?.clearCaches()
        textManager = .init(withSessionID: sessionID,
                            cacheInterfacer: CachedResourceInterfacer(withSessionID: sessionID),
                            remoteInterfacer: mockRemoteInterfacer,
                            bundleInterfacer: mockBundleInterfacer,
                            versionManager: mockVersionManager)
    }
    
    var textManager: TextManager!
    
    override func tearDown() {
        super.tearDown()
        textManager?.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func setDelegate(to delegate: TextManagerDelegate?)
///     func setResourceBundle(to bundle: Bundle)
///     func setResourceTimeout(to timeout: TimeInterval)
///     func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil)
///     func registerTextSource(_ textSource: TextSource)
///
extension TextManager_Configuration_Tests {
    
    // MARK: - T - Set Delegate
    ///
    /// Tests the function:
    ///
    ///     func setDelegate(to delegate: TextManagerDelegate?)
    ///
    /// The following behavior is expected:
    /// 1. Sets the delegate property in textManager to the supplied reference value
    ///
    func test_setDelegate() {
        
        // Pre Behavior:
            resetTextManager(withSessionID: "\(Self.self).\(#function)")
            XCTAssertNil(textManager.test_delegate)
        
        // Behavior #1:
            textManager.setDelegate(to: self)
            XCTAssertTrue(textManager.test_delegate === self)
    }
    
    // MARK: - T - Set Resource Bundle
    ///
    /// Tests the function:
    ///
    ///     func setResourceBundle(to bundle: Bundle)
    ///
    /// The following behavior is expected:
    /// 1. setBundle(...) is set on the bundleInterfacer
    /// 2. setResourceBundle(...) is set on the versionManager
    ///
    func test_setResourceBundle() {
        
        // Pre Behavior:
            resetTextManager(withSessionID: "\(Self.self).\(#function)")
            textManager.setResourceBundle(to: Bundle(for: Self.self))
        
        // Behavior #1:
            XCTAssertEqual(mockBundleInterfacer.mock_setBundleCount, 1)
            XCTAssertEqual(mockBundleInterfacer.mock_bundle, Bundle(for: Self.self))
        
        // Behavior #2:
            XCTAssertEqual(mockVersionManager.mock_setBundleCount, 1)
            XCTAssertEqual(mockVersionManager.mock_bundle, Bundle(for: Self.self))
    }
    
    // MARK: - T - Set Delegate
    ///
    /// Tests the function:
    ///
    ///     func setResourceTimeout(to timeout: TimeInterval)
    ///
    /// The following behavior is expected:
    /// 1. The timeout for the remoteinterfacer should be set.
    ///
    func test_setResourceTimeout() {
        
        // Pre Behavior:
            resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:
            textManager.setResourceTimeout(to: 1000)
            XCTAssertEqual(mockRemoteInterfacer.mock_setTimeoutCount, 1)
            XCTAssertEqual(mockRemoteInterfacer.mock_timeout, 1000)
    }
    
    // MARK: - T - Set Delegate
    ///
    /// Tests the function:
    ///
    ///     func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil)
    ///
    /// The following behavior is expected:
    /// 1. The versionSource for the versionManager should be set.
    ///
    func test_setVersionSource() {
        
        // Pre Behavior:
            resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:
            let versionSource: VersionSource = .init(bundleFile: BundleFile(fileName: "sddfgdf", fileExtension: "gdfgd"), remoteFile: RemoteFile(urlString: "sdgfdfg"))
            textManager.setVersionSource(to: versionSource)
        
            XCTAssertEqual(mockVersionManager.mock_setVersionSourceCount, 1)
            XCTAssertEqual(mockVersionManager.mock_versionSource?.bundleFile?.fileName, versionSource.bundleFile?.fileName)
            XCTAssertEqual(mockVersionManager.mock_versionSource?.bundleFile?.fileExtension, versionSource.bundleFile?.fileExtension)
            XCTAssertEqual(mockVersionManager.mock_versionSource?.remoteFile.urlString, versionSource.remoteFile.urlString)
    }
    
    // MARK: - T - Set Delegate
    ///
    /// Tests the function:
    ///
    ///     func registerTextSource(_ textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. The TextSource should be inserted into the textSources set
    /// 2. The resourceRegistered(...) method should be called on the versionManager
    ///
    func test_registerTextSource() {
        
        // Pre Behavior:
            resetTextManager(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:
            let textSource: TextSource = .init(identifier: "dffgdfg", bundleFile: BundleFile(fileName: "dffgdfg", fileExtension: "ddgfddfg"), remoteFile: RemoteFile(urlString: "dfgdfg"))
            textManager.registerTextSource(textSource)
            XCTAssertTrue(textManager.test_textSources.contains(textSource))
        
        // Behavior #2:
            XCTAssertEqual(mockVersionManager.mock_registeredResourceCount, 1)
            XCTAssertEqual(mockVersionManager.mock_registeredResourceID, textSource.identifier)
    }
}

// MARK: - Delegation Conformance

extension TextManager_Configuration_Tests: TextManagerDelegate {
    func versionIncreased(to version: Version, for textSource: TextSource) {}
}

// MARK: - Mock Classes

extension TextManager_Configuration_Tests {
    
    class Mock_BundledResourceInterfacer: BundledResourceInterfacer_TextManagerInterface {
        
        var mock_setBundleCount: Int = 0
        var mock_bundle: Bundle?
        
        func setBundle(to bundle: Bundle) {
            mock_setBundleCount += 1
            mock_bundle = bundle
        }
        
        // Unused
        func text(forSource textSource: TextSource) -> String? { nil }
    }
    
    class Mock_RemoteResourceInterfacer: RemoteResourceInterfacer_TextManagerInterface {
        var mock_setTimeoutCount: Int = 0
        var mock_timeout: TimeInterval?
        
        func setResourceTimeout(to timeout: TimeInterval) {
            mock_setTimeoutCount += 1
            mock_timeout = timeout
        }
        
        // Unused
        func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion) {}
    }
    
    class Mock_VersionManager: VersionManager_TextManagerInterface {
        var versionSource: VersionSource?
        var mock_setBundleCount: Int = 0
        var mock_setVersionSourceCount: Int = 0
        var mock_registeredResourceCount: Int = 0
        var mock_bundle: Bundle?
        var mock_versionSource: VersionSource?
        var mock_registeredResourceID: String?
        
        func setResourceBundle(to bundle: Bundle) {
            mock_setBundleCount += 1
            mock_bundle = bundle
        }
        
        func setVersionSource(to versionSource: VersionSource, withCompletion completion: (() -> Void)? = nil) {
            mock_setVersionSourceCount += 1
            mock_versionSource = versionSource
            completion?()
        }
        
        func resourceRegistered(forID resourceID: ResourceID) {
            mock_registeredResourceCount += 1
            mock_registeredResourceID = resourceID
        }
        
        // Unused
        func setDelegate(to delegate: VersionManagerDelegate?) {}
        func allVersions(ofResource resourceID: ResourceID) -> [LocationBoundVersion] { [] }
        func resourceCached(forID resourceID: ResourceID, withVersion version: Version) {}
        func cachedVersion(forResource resourceID: ResourceID) -> Version { .zero }
        func clearCaches() {}
    }
}

///
///  BundledResourceInterfacer_Retrieval_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// BundledResourceInterfacer Unit Tests - Retrieval
///
class BundledResourceInterfacer_Retrieval_Tests: XCTestCase {
    
    var interfacer: BundledResourceInterfacer!
    
    override func setUp() {
        super.setUp()
        interfacer = .init()
        interfacer.setBundle(to: Bundle(for: Self.self))
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func versions(forSource versionSource: VersionSource?) -> [String: Version]?
///     func text(forSource textSource: TextSource) -> String?
///
extension BundledResourceInterfacer_Retrieval_Tests {
    
    // MARK: - T - Version For Source
    ///
    /// Tests the function:
    ///
    ///     func versions(forSource versionSource: VersionSource?) -> [String: Version]?
    ///
    /// The following behavior is expected:
    /// 1. Guard-unwraps the supplied VersionSource, retrieves Data from the bundle using the VersionSource's bundleFile values, decodes it to [String: String], then maps it to [String: Version] and returns the result
    /// 2. Should any of that fail, nil is returned
    ///
    func test_versionsForSource() {
        
        // Behavior #1 - 1:
        
            var bundleFile: BundleFile = .init(fileName: TestingResources.BundleFileNames.Versions.s, fileExtension: TestingResources.BundleFileNames.Versions.extension)
            var bundleVersions = TestingResources.BundleFileContents.Versions.s
        
            var versionSource = VersionSource(bundleFile: bundleFile, remoteFile: .init(urlString: ""))
            guard let versions_s = interfacer.versions(forSource: versionSource) else {
                return XCTFail()
            }
                
            bundleVersions.forEachResource { resourceID, version in
                let currentVersion = versions_s.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
        // Behavior #1 - 2:
        
            bundleFile = .init(fileName: TestingResources.BundleFileNames.Versions.m, fileExtension: TestingResources.BundleFileNames.Versions.extension)
            bundleVersions = TestingResources.BundleFileContents.Versions.m
        
            versionSource = VersionSource(bundleFile: bundleFile, remoteFile: .init(urlString: ""))
            guard let versions_m = interfacer.versions(forSource: versionSource) else {
                return XCTFail()
            }
            
            bundleVersions.forEachResource { resourceID, version in
                let currentVersion = versions_m.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
        // Behavior #1 - 3:
        
            bundleFile = .init(fileName: TestingResources.BundleFileNames.Versions.l, fileExtension: TestingResources.BundleFileNames.Versions.extension)
            bundleVersions = TestingResources.BundleFileContents.Versions.l
        
            versionSource = VersionSource(bundleFile: bundleFile, remoteFile: .init(urlString: ""))
            guard let versions_l = interfacer.versions(forSource: versionSource) else {
                return XCTFail()
            }
            
            bundleVersions.forEachResource { resourceID, version in
                let currentVersion = versions_l.version(forResource: resourceID)
                XCTAssertNotNil(currentVersion)
                XCTAssertEqual(currentVersion?.major, version.major)
                XCTAssertEqual(currentVersion?.minor, version.minor)
                XCTAssertEqual(currentVersion?.patch, version.patch)
            }
        
        // Behavior #2 - 1:
            XCTAssertNil(interfacer.versions(forSource: nil))
            
        // Behavior #2 - 2:
            versionSource = VersionSource(bundleFile: .init(fileName: "fsdfsdf", fileExtension: TestingResources.BundleFileNames.Versions.extension), remoteFile: .init(urlString: ""))
            XCTAssertNil(interfacer.versions(forSource: versionSource))
    }
    
    // MARK: - T - Text For Source
    ///
    /// Tests the function:
    ///
    ///     func text(forSource textSource: TextSource) -> String?
    ///
    /// The following behavior is expected:
    /// 1. Retrieves a String value from the bundle using the TextSource's bundleFile values and returns the result
    /// 2. Should that fail, nil is returned
    ///
    func test_textForSource() {
        
        // Behavior #1 - 1:
        
            var expectedText = TestingResources.BundleFileContents.Texts.s
            var textSource = TextSource(identifier: "abc", bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Texts.s, fileExtension: TestingResources.BundleFileNames.Texts.extension), remoteFile: RemoteFile(urlString: ""))
            
            XCTAssertEqual(interfacer.text(forSource: textSource), expectedText)
        
        // Behavior #1 - 2:
        
            expectedText = TestingResources.BundleFileContents.Texts.m
            textSource = TextSource(identifier: "abc", bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Texts.m, fileExtension: TestingResources.BundleFileNames.Texts.extension), remoteFile: RemoteFile(urlString: ""))

            XCTAssertEqual(interfacer.text(forSource: textSource), expectedText)
        
        // Behavior #1 - 3:
        
            expectedText = TestingResources.BundleFileContents.Texts.l
            textSource = TextSource(identifier: "abc", bundleFile: BundleFile(fileName: TestingResources.BundleFileNames.Texts.l, fileExtension: TestingResources.BundleFileNames.Texts.extension), remoteFile: RemoteFile(urlString: ""))

            XCTAssertEqual(interfacer.text(forSource: textSource), expectedText)
        
        // Behavior #2:
        
            textSource = TextSource(identifier: "abc", bundleFile: BundleFile(fileName: "dsfsfsdf", fileExtension: TestingResources.BundleFileNames.Texts.extension), remoteFile: RemoteFile(urlString: ""))

            XCTAssertNil(interfacer.text(forSource: textSource))
    }
}


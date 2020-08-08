///
///  CachedResourceInterfacer_Setup_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// CachedResourceInterfacer Unit Tests - Setup
///
class CachedResourceInterfacer_Setup_Tests: XCTestCase {
    
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
///     init(withSessionID sessionID: String)
///     func createLocalDirectoryIfNeeded()
///
extension CachedResourceInterfacer_Setup_Tests {

    // MARK: - T - Init
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     init(withSessionID sessionID: String)
    ///
    /// The following behavior is expected:
    /// 1. Sets the sessionID property to the supplied reference value
    /// 2. Calls createLocalDirectoryIfNeeded()
    ///
    func test_init() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        // Behavior #1:
            XCTAssertEqual(interfacer.test_sessionID, "\(Self.self).\(#function)")
        
        // Behavior #2:
            let url = CachedResourceInterfacer.directoryURL(forSession: interfacer.test_sessionID)
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
    
    // MARK: - T - Create Local Directory If Needed
    ///
    /// CachedResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func createLocalDirectoryIfNeeded()
    ///
    /// The following behavior is expected:
    /// 1. Creates a directory with a name matching the provided sessionID within the documents directory, if one does not already exist.
    ///
    func test_createLocalDirectoryIfNeeded() {
        interfacer = CachedResourceInterfacer(withSessionID: "\(Self.self).\(#function)")
        
        let url = CachedResourceInterfacer.directoryURL(forSession: interfacer.test_sessionID)
        try? FileManager.default.removeItem(at: url)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        
        // Behavior #1:
            interfacer.test_createLocalDirectoryIfNeeded()
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
    }
}

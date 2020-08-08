///
///  VersionManager_Initialization_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionManager Unit Tests - Initialization
///
class VersionManager_Initialization_Tests: XCTestCase {
    var versionManager: VersionManager!
    
    override func tearDown() {
        super.tearDown()
        versionManager?.test_cacheInterfacer.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     init(withSessionID sessionID: String)
///
extension VersionManager_Initialization_Tests {
    
    // MARK: - T - Init with sessionID
    ///
    /// VersionManager Unit Test
    ///
    /// Tests the function:
    ///
    ///     init(withSessionID sessionID: String)
    ///
    /// The following behavior is expected:
    /// 1. Sets the sessionID property in versionManager to the supplied value
    /// 2. Creates an instance of cacheInterfacer with the supplied sessionID
    ///
    func test_init() {
        
        // Behavior #1:
            versionManager = VersionManager(withSessionID: "\(Self.self).\(#function)")
            XCTAssertEqual(versionManager.test_sessionID, "\(Self.self).\(#function)")
        
        // Behavior #2:
            XCTAssertEqual(versionManager.test_cacheInterfacer.test_sessionID, "\(Self.self).\(#function)")
    }
}

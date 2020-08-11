///
///  TextManager_Initialization_Tests.swift
///  Created on 7/24/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextManager Unit Tests - Initialization
///
class TextManager_Initialization_Tests: XCTestCase {
    
    var textManager: TextManager!
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     init(withSessionID sessionID: String)
///
extension TextManager_Initialization_Tests {
    
    // MARK: - T - Init
    ///
    /// Tests the function:
    ///
    ///     init(withSessionID sessionID: String)
    ///
    /// The following behavior is expected:
    /// 1. Sets the sessionID property to the provided value
    /// 2. Initializes the cacheInterfacer and versionManager with the provided sessionID
    /// 3. Passes self into the versionManager setDelegate(...) method
    ///
    func test_setInit() {
        
        let sessionID = "\(Self.self).\(#function)"
        textManager = .init(withSessionID: sessionID)
        
        // Behavior #1:
            XCTAssertEqual(textManager.test_sessionID, sessionID)
        
        // Behavior #2:
            XCTAssertEqual((textManager.test_cacheInterfacer as? CachedResourceInterfacer)?.test_sessionID, sessionID)
            XCTAssertEqual(textManager.test_versionManager?.test_sessionID, sessionID)
        
        // Behavior #3:
            XCTAssertTrue(textManager.test_versionManager?.test_delegate === textManager)
    }
}

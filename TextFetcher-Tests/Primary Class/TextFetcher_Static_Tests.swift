///
///  TextFetcher_Static_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - Static
///
class TextFetcher_Static_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private static func validID(for sessionID: String) -> String
///
extension TextFetcher_Static_Tests {
    
    // MARK: - T - Valid ID
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     private static func validID(for sessionID: String) -> String
    ///
    /// The following behavior is expected:
    /// 1. If the TextFetcher's defaultID is passed in, a different value (doesn't matter which) is returned
    /// 2. Otherwise, the given value should be returned
    ///
    func test_validID() {
        
        // Behavior #1:
        
            XCTAssertNotEqual(TextFetcher.test_validID(for: TextFetcher.test_defaultID), TextFetcher.test_defaultID)
        
        // Behavior #2:
        
            XCTAssertEqual(TextFetcher.test_validID(for: "Abc"), "Abc")
    }
}

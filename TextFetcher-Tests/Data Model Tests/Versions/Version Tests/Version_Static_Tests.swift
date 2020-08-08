///
///  Version_Static_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// Version Unit Tests - Static
///
class Version_Static_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following static accessors:
///
///     public static let zero: Version
///
extension Version_Static_Tests {
    
    // MARK: - T - Zero
    ///
    /// Version Unit Test
    ///
    /// Tests the static variable:
    ///
    ///      public static let zero: Version
    ///
    /// The following value is expected:
    /// 1. A Version containing major, minor, and patch versions, all equal to 0
    ///
    func test_zero() {
        
        let version = Version.zero
        
        // Behavior #1:
        
            XCTAssertEqual(version.major, 0)
            XCTAssertEqual(version.minor, 0)
            XCTAssertEqual(version.patch, 0)
    }
}

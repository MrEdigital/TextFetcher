///
///  Version_AltType_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// Version Unit Tests - Alt Types
///
class Version_AltType_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public var stringValue: String
///
extension Version_AltType_Tests {
    
    // MARK: - T - String Value
    ///
    /// Version Unit Test
    ///
    /// Tests the variable:
    ///
    ///     public var stringValue: String
    ///
    /// The following behavior is expected:
    /// 1. major, minor, and patch integers should be combined into a string, separated by periods, and returned.
    ///
    func test_stringValue() {
        
        var version: Version
        
        // Behavior #1 - 1:
            version = .init(major: 123, minor: 456, patch: 789)
            XCTAssertEqual(version.stringValue, "123.456.789")
            
        // Behavior #1 - 2:
            version = .init(major: 354354, minor: 456456, patch: 13123)
            XCTAssertEqual(version.stringValue, "354354.456456.13123")
        
        // Behavior #1 - 3:
            version = .init(major: 0, minor: 0, patch: 0)
            XCTAssertEqual(version.stringValue, "0.0.0")
    }
}

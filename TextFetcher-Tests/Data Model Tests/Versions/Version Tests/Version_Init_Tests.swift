///
///  Version_Init_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// Version Unit Tests - Initializers
///
class Version_Init_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     public init(major: UInt, minor: UInt, patch: UInt)
///     public init(withString string: String)
///
extension Version_Init_Tests {
    
    // MARK: - T - Init with Major/Minor/Patch
    ///
    /// Version Unit Test
    ///
    /// Tests the function:
    ///
    ///     public init(major: UInt, minor: UInt, patch: UInt)
    ///
    /// The following behavior is expected:
    /// 1. Sets the major, minor, and patch property values equal to the provided values.
    ///
    func test_init() {
        
        var version: Version
        
        // Behavior #1 - 1:
            version = .init(major: 123, minor: 456, patch: 789)
            XCTAssertEqual(version.major, 123)
            XCTAssertEqual(version.minor, 456)
            XCTAssertEqual(version.patch, 789)
            
        // Behavior #1 - 2:
            version = .init(major: 354354, minor: 456456, patch: 13123)
            XCTAssertEqual(version.major, 354354)
            XCTAssertEqual(version.minor, 456456)
            XCTAssertEqual(version.patch, 13123)
            
        // Behavior #1 - 3:
            version = .init(major: 0, minor: 0, patch: 0)
            XCTAssertEqual(version.major, 0)
            XCTAssertEqual(version.minor, 0)
            XCTAssertEqual(version.patch, 0)
    }
    
    // MARK: - T - Init with String
    ///
    /// Version Unit Test
    ///
    /// Tests the function:
    ///
    ///     public init(withString string: String)
    ///
    /// The following behavior is expected:
    /// 1. Separates out a major, minor, and patch unsigned integer from the provided string, with "." as the separator, and then uses them to call init(major: UInt, minor: UInt, patch: UInt)
    /// 2. Should the string contain more or less than 3 digits separated by ".", or if any of the integers fail to initialize from the separated strings, a value of Version.zero is returned instead.
    ///
    func test_initWithString() {
        
        var version: Version?
        
        // Behavior #1 - 1:
            
            version = Version(withString: "123.456.789")
            XCTAssertNotNil(version)
            XCTAssertEqual(version!.major, 123)
            XCTAssertEqual(version!.minor, 456)
            XCTAssertEqual(version!.patch, 789)
        
        // Behavior #1 - 2:
            version = Version(withString: "354354.456456.13123")
            XCTAssertNotNil(version)
            XCTAssertEqual(version!.major, 354354)
            XCTAssertEqual(version!.minor, 456456)
            XCTAssertEqual(version!.patch, 13123)
        
        // Behavior #1 - 3:
            version = Version(withString: "0.0.0")
            XCTAssertNotNil(version)
            XCTAssertEqual(version!.major, 0)
            XCTAssertEqual(version!.minor, 0)
            XCTAssertEqual(version!.patch, 0)
        
        // Behavior #2 - 1:
            version = Version(withString: "A.0.0")
            XCTAssertNil(version)
        
        // Behavior #2 - 2:
            version = Version(withString: "0.A.0")
            XCTAssertNil(version)
        
        // Behavior #2 - 3:
            version = Version(withString: "0.0.A")
            XCTAssertNil(version)
        
        // Behavior #2 - 4:
            version = Version(withString: "-1.0.0")
            XCTAssertNil(version)
        
        // Behavior #2 - 5:
            version = Version(withString: "0.-1.0")
            XCTAssertNil(version)
        
        // Behavior #2 - 6:
            version = Version(withString: "0.0.-1")
            XCTAssertNil(version)
            
        // Behavior #2 - 7:
            version = Version(withString: "0.0")
            XCTAssertNil(version)
        
        // Behavior #2 - 8:
            version = Version(withString: "0.0.0.0")
            XCTAssertNil(version)
    }
}

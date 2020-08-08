///
///  Version_Comparitor_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// Version Unit Tests - Comparitors
///
class Version_Comparitor_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following public static functions:
///
///     static func ==(_ lhs: Version, _ rhs: Version) -> Bool
///     static func !=(_ lhs: Version, _ rhs: Version) -> Bool
///     static func >=(_ lhs: Version, _ rhs: Version) -> Bool
///     static func >(_ lhs: Version, _ rhs: Version) -> Bool
///     static func <(_ lhs: Version, _ rhs: Version) -> Bool
///     static func <=(_ lhs: Version, _ rhs: Version) -> Bool
///
extension Version_Comparitor_Tests {
    
    // MARK: - T - Is Equal
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func ==(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. Returns true so long as major, minor, AND patch values of both Versions are all equal.
    ///
    func test_equal() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertTrue(versionA == versionB)
            XCTAssertTrue(versionB == versionA)

        // Behavior #1 - 2:
            versionA = .init(major: 123, minor: 345, patch: 876)
            versionB = .init(major: 123, minor: 345, patch: 876)
            XCTAssertTrue(versionA == versionB)
            XCTAssertTrue(versionB == versionA)

        // Behavior #1 - 3:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 1)
            XCTAssertFalse(versionA == versionB)
            XCTAssertFalse(versionB == versionA)

        // Behavior #1 - 4:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 1, patch: 0)
            XCTAssertFalse(versionA == versionB)
            XCTAssertFalse(versionB == versionA)

        // Behavior #1 - 5:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 1, minor: 0, patch: 0)
            XCTAssertFalse(versionA == versionB)
            XCTAssertFalse(versionB == versionA)

        // Behavior #1 - 6:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 1, minor: 1, patch: 1)
            XCTAssertFalse(versionA == versionB)
            XCTAssertFalse(versionB == versionA)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 2, patch: 3)
            versionB = .init(major: 3, minor: 2, patch: 1)
            XCTAssertFalse(versionA == versionB)
            XCTAssertFalse(versionB == versionA)
    }
    
    // MARK: - T - Is Not Equal
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func !=(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. Returns true so long as major, minor, OR patch values of both Versions are not equal.
    ///
    func test_notEqual() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertFalse(versionA != versionB)
            XCTAssertFalse(versionB != versionA)

        // Behavior #1 - 2:
            versionA = .init(major: 123, minor: 345, patch: 876)
            versionB = .init(major: 123, minor: 345, patch: 876)
            XCTAssertFalse(versionA != versionB)
            XCTAssertFalse(versionB != versionA)

        // Behavior #1 - 3:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 1)
            XCTAssertTrue(versionA != versionB)
            XCTAssertTrue(versionB != versionA)

        // Behavior #1 - 4:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 1, patch: 0)
            XCTAssertTrue(versionA != versionB)
            XCTAssertTrue(versionB != versionA)

        // Behavior #1 - 5:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 1, minor: 0, patch: 0)
            XCTAssertTrue(versionA != versionB)
            XCTAssertTrue(versionB != versionA)

        // Behavior #1 - 6:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 1, minor: 1, patch: 1)
            XCTAssertTrue(versionA != versionB)
            XCTAssertTrue(versionB != versionA)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 2, patch: 3)
            versionB = .init(major: 3, minor: 2, patch: 1)
            XCTAssertTrue(versionA != versionB)
            XCTAssertTrue(versionB != versionA)
    }
    
    // MARK: - T - Is Greater Than
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func >(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. Returns true so long as major is greater than major, or majors are equal and minor is greater than minor, or majors and minors are equal, but patch is greater than patch, between two Versions.
    ///
    func test_greaterThan() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertFalse(versionA > versionB)
            XCTAssertFalse(versionB > versionA)

        // Behavior #1 - 2:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 0, patch: 2)
            XCTAssertTrue(versionA > versionB)
            XCTAssertFalse(versionB > versionA)

        // Behavior #1 - 3:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 2, patch: 2)
            XCTAssertTrue(versionA > versionB)
            XCTAssertFalse(versionB > versionA)

        // Behavior #1 - 4:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 1)
            
            XCTAssertFalse(versionA > versionB)
            XCTAssertFalse(versionB > versionA)

        // Behavior #1 - 5:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 2)
            
            XCTAssertTrue(versionB > versionA)
            XCTAssertFalse(versionA > versionB)

        // Behavior #1 - 6:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 2, patch: 1)
            
            XCTAssertTrue(versionB > versionA)
            XCTAssertFalse(versionA > versionB)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 2, minor: 1, patch: 1)
            
            XCTAssertTrue(versionB > versionA)
            XCTAssertFalse(versionA > versionB)
    }
    
    // MARK: - T - Is Less Than
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func <(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. The reverse of test_greaterThan().
    ///
    func test_lessThan() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertFalse(versionA < versionB)
            XCTAssertFalse(versionB < versionA)

        // Behavior #1 - 2:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 0, patch: 2)
            XCTAssertTrue(versionB < versionA)
            XCTAssertFalse(versionA < versionB)

        // Behavior #1 - 3:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 2, patch: 2)
            XCTAssertTrue(versionB < versionA)
            XCTAssertFalse(versionA < versionB)

        // Behavior #1 - 4:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 1)
            XCTAssertFalse(versionB < versionA)
            XCTAssertFalse(versionA < versionB)

        // Behavior #1 - 5:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 2)
            XCTAssertTrue(versionA < versionB)
            XCTAssertFalse(versionB < versionA)

        // Behavior #1 - 6:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 2, patch: 1)
            XCTAssertTrue(versionA < versionB)
            XCTAssertFalse(versionB < versionA)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 2, minor: 1, patch: 1)
            XCTAssertTrue(versionA < versionB)
            XCTAssertFalse(versionB < versionA)
    }
    
    // MARK: - T - Is Greater Than Or Equal
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func >=(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. Returns true so long as test_greaterThan() OR test_equal().
    ///
    func test_greaterThanOrEqual() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertTrue(versionB >= versionA)
            XCTAssertTrue(versionA >= versionB)

        // Behavior #1 - 2:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 0, patch: 2)
            XCTAssertTrue(versionA >= versionB)
            XCTAssertFalse(versionB >= versionA)

        // Behavior #1 - 3:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 2, patch: 2)
            XCTAssertTrue(versionA >= versionB)
            XCTAssertFalse(versionB >= versionA)

        // Behavior #1 - 4:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 1)
            XCTAssertTrue(versionA >= versionB)
            XCTAssertTrue(versionB >= versionA)

        // Behavior #1 - 5:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 2)
            XCTAssertTrue(versionB >= versionA)
            XCTAssertFalse(versionA >= versionB)

        // Behavior #1 - 6:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 2, patch: 1)
            XCTAssertTrue(versionB >= versionA)
            XCTAssertFalse(versionA >= versionB)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 2, minor: 1, patch: 1)
            XCTAssertTrue(versionB >= versionA)
            XCTAssertFalse(versionA >= versionB)
    }
    
    // MARK: - T - Is Less Than Or Equal
    ///
    /// Version Unit Test
    ///
    /// Tests the functions:
    ///
    ///     static func <=(_ lhs: Version, _ rhs: Version) -> Bool
    ///
    /// The following behavior is expected:
    /// 1. Returns true so long as test_lessThan() OR test_equal().
    ///
    func test_lessThanOrEqual() {
        
        var versionA: Version
        var versionB: Version

        // Behavior #1 - 1:
            versionA = .init(major: 0, minor: 0, patch: 0)
            versionB = .init(major: 0, minor: 0, patch: 0)
            XCTAssertTrue(versionA <= versionB)
            XCTAssertTrue(versionB <= versionA)

        // Behavior #1 - 2:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 0, patch: 2)
            XCTAssertTrue(versionB <= versionA)
            XCTAssertFalse(versionA <= versionB)

        // Behavior #1 - 3:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 0, minor: 2, patch: 2)
            XCTAssertTrue(versionB <= versionA)
            XCTAssertFalse(versionA <= versionB)

        // Behavior #1 - 4:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 1)
            XCTAssertTrue(versionB <= versionA)
            XCTAssertTrue(versionA <= versionB)

        // Behavior #1 - 5:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 1, patch: 2)
            XCTAssertTrue(versionA <= versionB)
            XCTAssertFalse(versionB <= versionA)

        // Behavior #1 - 6:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 1, minor: 2, patch: 1)
            XCTAssertTrue(versionA <= versionB)
            XCTAssertFalse(versionB <= versionA)

        // Behavior #1 - 7:
            versionA = .init(major: 1, minor: 1, patch: 1)
            versionB = .init(major: 2, minor: 1, patch: 1)
            XCTAssertTrue(versionA <= versionB)
            XCTAssertFalse(versionB <= versionA)
    }
}

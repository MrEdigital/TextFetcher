///
///  VersionStore_Initialization_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionStore Unit Tests - Initialization
///
class VersionStore_Initialization_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     init?(withData data: Data?)
///     init(withStringVersions stringVersions: [ResourceID: String] = [:])
///
extension VersionStore_Initialization_Tests {
    
    // MARK: - T - Init with Data
    ///
    /// VersionStore Unit Test
    ///
    /// Tests the function:
    ///
    ///     init?(withData data: Data?)
    ///
    /// The following behavior is expected:
    /// 1. If no data is provided, it should return as nil.
    /// 2. If Data that cannot decode into [String: String] is provided, it should return nil.
    /// 3. If Data is provided that CAN decode into [String: String], a valid VersionStore should return.
    /// 4. The VersionStore should contain resourceVersions which match the encoded data.
    ///
    func test_initWithData() {
        
        let validVersion1: Version = .init(major: 123, minor: 456, patch: 789)
        let validVersion2: Version = .init(major: 1, minor: 2, patch: 3)
        let validVersions: [String: String] = ["ResourceID1": validVersion1.stringValue, "ResourceID2": validVersion2.stringValue]
        let invalidVersions: [String: Int] = ["ResourceID1": 3, "ResourceID2": 6]
        
        // Behavior #1:
            XCTAssertNil(VersionStore(withData: nil))
        
        // Behavior #2:
            let invalidData: Data? = try? JSONEncoder().encode(invalidVersions)
            XCTAssertNotNil(invalidData)
            XCTAssertNil(VersionStore(withData: invalidData))
            
        // Behavior #3:
            let validData: Data? = try? JSONEncoder().encode(validVersions)
            let versionStore = VersionStore(withData: validData)
            XCTAssertNotNil(validData)
            XCTAssertNotNil(versionStore)
        
        // Behavior #4:
            XCTAssertEqual(versionStore?.test_resourceVersions.count, 2)
            XCTAssertEqual(versionStore?.test_resourceVersions["ResourceID1"], validVersion1)
            XCTAssertEqual(versionStore?.test_resourceVersions["ResourceID2"], validVersion2)
    }
    
    // MARK: - T - Init with String Versions
    ///
    /// VersionStore Unit Test
    ///
    /// Tests the function:
    ///
    ///     init(withStringVersions stringVersions: [ResourceID: String] = [:])
    ///
    /// The following behavior is expected:
    /// 1. A VersionStore should be returned containing resourceVersions that match the provided dictionary.
    /// 2. Dictionary values which cannot produce a valid Version object should not be included in the resulting VersionStore.
    ///
    func test_initWithStringVersions() {
        
        let validVersion1: Version = .init(major: 123, minor: 456, patch: 789)
        let validVersion2: Version = .init(major: 1, minor: 2, patch: 3)
        let validVersions: [String: String] = ["ResourceID1": validVersion1.stringValue, "ResourceID2": validVersion2.stringValue]
        let invalidVersions: [String: String] = ["ResourceID1": "1.1.1.1", "ResourceID2": "1.1"]
        
        // Behavior #1:
            let versionStore1 = VersionStore(withStringVersions: validVersions)
            XCTAssertEqual(versionStore1.test_resourceVersions.count, 2)
            XCTAssertEqual(versionStore1.test_resourceVersions["ResourceID1"], validVersion1)
            XCTAssertEqual(versionStore1.test_resourceVersions["ResourceID2"], validVersion2)
            
        // Behavior #2:
            let versionStore2 = VersionStore(withStringVersions: invalidVersions)
            XCTAssertEqual(versionStore2.test_resourceVersions.count, 0)
    }
}


///
///  VersionStore_Getter_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionStore Unit Tests - Getters
///
class VersionStore_Getter_Tests: XCTestCase {
    
    static let versions1: [String: Version] = ["ResourceID1": .init(major: 123, minor: 456, patch: 789), "ResourceID2": .init(major: 1, minor: 2, patch: 3)]
    static let versions2: [String: Version] = ["ResourceID1": .init(major: 123, minor: 456, patch: 789), "ResourceID2": .init(major: 1, minor: 2, patch: 3),
                                               "ResourceID3": .init(major: 45, minor: 2423, patch: 1),   "ResourceID4": .init(major: 54, minor: 23, patch: 73)]
    static let versions3: [String: Version] = ["ResourceID1": .init(major: 123, minor: 456, patch: 789), "ResourceID2": .init(major: 1, minor: 2, patch: 3),
                                               "ResourceID3": .init(major: 45, minor: 2423, patch: 1),   "ResourceID4": .init(major: 54, minor: 23, patch: 73),
                                               "ResourceID5": .init(major: 11, minor: 23, patch: 786),   "ResourceID6": .init(major: 14, minor: 62, patch: 6)]
    var versionStore: VersionStore!
    
    override func setUp() {
        super.setUp()
        versionStore = .init()
    }
}

// MARK: - Tests...
///
/// Covering the following getters:
///
///     var count: Int { resourceVersions.count }
///     var allResourceIDs: Set<ResourceID> { .init(resourceVersions.map({ $0.key })) }
///     var jsonEncodedData: Data?
///
extension VersionStore_Getter_Tests {
    
    // MARK: - T - Count
    ///
    /// Tests the getter:
    ///
    ///     var count: Int
    ///
    /// The following behavior is expected:
    /// 1. The number of registered versions should always be reflected in the resulting value
    ///
    func test_count() {
        
        // Behavior #1 - 1:
            XCTAssertEqual(versionStore.count, 0)
        
        // Behavior #1 - 2:
            versionStore.test_setResourceVersions(to: Self.versions1)
            XCTAssertEqual(versionStore.count, Self.versions1.count)
            
        // Behavior #1 - 3:
            versionStore.test_setResourceVersions(to: Self.versions2)
            XCTAssertEqual(versionStore.count, Self.versions2.count)
            
        // Behavior #1 - 4:
            versionStore.test_setResourceVersions(to: Self.versions3)
            XCTAssertEqual(versionStore.count, Self.versions3.count)
    }
    
    // MARK: - T - All Resource IDs
    ///
    /// Tests the getter:
    ///
    ///     var allResourceIDs: Set<ResourceID>
    ///
    /// The following behavior is expected:
    /// 1. The Keys for each value in the versionStore should be returned in a Set
    ///
    func test_allResourceIDs() {
        
        // Behavior #1 - 1:
            XCTAssertEqual(versionStore.allResourceIDs.count, 0)
        
        // Behavior #1 - 2:
            versionStore.test_setResourceVersions(to: Self.versions1)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions1.map({ $0.key })))
            
        // Behavior #1 - 3:
            versionStore.test_setResourceVersions(to: Self.versions2)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions2.map({ $0.key })))
            
        // Behavior #1 - 4:
            versionStore.test_setResourceVersions(to: Self.versions3)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions3.map({ $0.key })))
    }
    
    // MARK: - T - JSON Encoded Data
    ///
    /// Tests the getter:
    ///
    ///     var jsonEncodedData: Data?
    ///
    /// The following behavior is expected:
    /// 1. A non-nil Data object should be generated and returned, which can be decoded into [String: String], or used to
    ///    initialize a new instance of VersionStore.
    ///
    func test_jsonEncodedData() {
        
        var data: Data?
        var decodedDictionary: [String: String]?
        
        // Behavior #1 - 1:
            data = versionStore.jsonEncodedData
            XCTAssertNotNil(data)
            decodedDictionary = try? JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertNotNil(decodedDictionary)
        
        // Behavior #1 - 2:
            versionStore.test_setResourceVersions(to: Self.versions1)
            data = versionStore.jsonEncodedData
            XCTAssertNotNil(data)
            decodedDictionary = try? JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertNotNil(decodedDictionary)
            XCTAssertEqual(versionStore.count, Self.versions1.count)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions1.map({ $0.key })))
            XCTAssertEqual(versionStore.test_allVersions, Self.versions1.map({ $0.value }))
            
        // Behavior #1 - 3:
            versionStore.test_setResourceVersions(to: Self.versions2)
            data = versionStore.jsonEncodedData
            XCTAssertNotNil(data)
            decodedDictionary = try? JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertNotNil(decodedDictionary)
            XCTAssertEqual(versionStore.count, Self.versions2.count)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions2.map({ $0.key })))
            XCTAssertEqual(versionStore.test_allVersions, Self.versions2.map({ $0.value }))
            
        // Behavior #1 - 4:
            versionStore.test_setResourceVersions(to: Self.versions3)
            data = versionStore.jsonEncodedData
            XCTAssertNotNil(data)
            decodedDictionary = try? JSONDecoder().decode([String: String].self, from: data!)
            XCTAssertNotNil(decodedDictionary)
            XCTAssertEqual(versionStore.count, Self.versions3.count)
            XCTAssertEqual(versionStore.allResourceIDs, Set<ResourceID>(Self.versions3.map({ $0.key })))
            XCTAssertEqual(versionStore.test_allVersions, Self.versions3.map({ $0.value }))
    }
}


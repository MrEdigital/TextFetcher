///
///  VersionStore_Interface_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionStore Unit Tests - Interface
///
class VersionStore_Interface_Tests: XCTestCase {
    
    static let versions: [String: Version] = ["ResourceID1": .init(major: 123, minor: 456, patch: 789), "ResourceID2": .init(major: 1, minor: 2, patch: 3),
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
/// Covering the following functions:
///
///     func version(forResource resourceID: ResourceID) -> Version?
///     func forEachResource(_ forEach: (_ resourceID: ResourceID, _ version: Version) -> Void)
///
extension VersionStore_Interface_Tests {
    
    // MARK: - T - Version for Resource ID
    ///
    /// Tests the function:
    ///
    ///     func version(forResource resourceID: ResourceID) -> Version?
    ///
    /// The following behavior is expected:
    /// 1. Should return nil if there is no Version registered for the given Resource ID
    /// 2. Should otherwise return the Version associated with the given Resource ID
    ///
    func test_versionForResource() {
        
        versionStore.test_setResourceVersions(to: Self.versions)
        
        // Behavior #1:
            XCTAssertNil(versionStore.version(forResource: "ResourceID0"))
            XCTAssertNil(versionStore.version(forResource: "dgfdgdfg"))
            XCTAssertNil(versionStore.version(forResource: "hfgh"))
            XCTAssertNil(versionStore.version(forResource: "htrhr"))
        
        // Behavior #2:
            for (resourceID, version) in Self.versions {
                XCTAssertNotNil(versionStore.version(forResource: resourceID))
                XCTAssertEqual(versionStore.version(forResource: resourceID), version)
            }
    }
    
    // MARK: - T - For Each Version
    ///
    /// Tests the function:
    ///
    ///     func forEachResource(_ forEach: (_ resourceID: ResourceID, _ version: Version) -> Void)
    ///
    /// The following behavior is expected:
    /// 1. Should perform the given closure on each ResourceID / Version pair in the resourceVersions dictionary
    ///
    func test_forEachResource() {
        
        versionStore.test_setResourceVersions(to: Self.versions)
        
        // Behavior #1:
        
            var removeCount: Int = 0
            var resourceIDs: [String] = Self.versions.map({ $0.key })
        
            versionStore.forEachResource { resourceID, version in
                resourceIDs.removeAll(where: { $0 == resourceID })
                removeCount += 1
                
                XCTAssertEqual(version, Self.versions[resourceID])
                XCTAssertEqual(resourceIDs.count, Self.versions.count - removeCount)
            }
        
            XCTAssertEqual(resourceIDs.count, 0)
            XCTAssertEqual(removeCount, Self.versions.count)
    }
}


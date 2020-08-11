///
///  VersionStore_Setter_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// VersionStore Unit Tests - Setters
///
class VersionStore_Setter_Tests: XCTestCase {
    
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
///     mutating func setVersion(_ version: Version, forResource resourceID: ResourceID)
///
extension VersionStore_Setter_Tests {
    
    // MARK: - T - Set Version For ResourceID
    ///
    /// Tests the function:
    ///
    ///     mutating func setVersion(_ version: Version, forResource resourceID: ResourceID)
    ///
    /// The following behavior is expected:
    /// 1. Only the Version for the given ResourceID in resourceVersions should be replaced with the given value.
    ///
    func test_setVersionForResourceID() {
        
        let version1: Version = .init(major: 54345, minor: 56756, patch: 7897)
        let version2: Version = .init(major: 45645, minor: 45645, patch: 5655)
        let resourceToSet: String = "ResourceID3"

        versionStore.test_setResourceVersions(to: Self.versions)
        
        // Behavior #1 - 1:
            XCTAssertNotEqual(versionStore.test_resourceVersions[resourceToSet], version1)
            versionStore.setVersion(version1, forResource: resourceToSet)

            XCTAssertEqual(versionStore.test_resourceVersions[resourceToSet], version1)
            for resourceID in versionStore.allResourceIDs {
                if resourceID != resourceToSet {
                    XCTAssertNotEqual(versionStore.test_resourceVersions[resourceID], version1)
                }
            }
    
        // Behavior #1 - 2:
            XCTAssertNotEqual(versionStore.test_resourceVersions[resourceToSet], version2)
            versionStore.setVersion(version2, forResource: resourceToSet)

            XCTAssertEqual(versionStore.test_resourceVersions[resourceToSet], version2)
            for resourceID in versionStore.allResourceIDs {
                if resourceID != resourceToSet {
                    XCTAssertNotEqual(versionStore.test_resourceVersions[resourceID], version2)
                }
            }
        
    }
}


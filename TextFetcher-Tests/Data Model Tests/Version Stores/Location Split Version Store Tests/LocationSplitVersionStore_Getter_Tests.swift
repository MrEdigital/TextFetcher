///
///  LocationSplitVersionStore_Getter_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// LocationSplitVersionStore Unit Tests - Getters
///
class LocationSplitVersionStore_Getter_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following getters:
///
///     private var allResourceIDs: Set<ResourceID
///
extension LocationSplitVersionStore_Getter_Tests {
    
    // MARK: - T - All Resource IDs
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      private var allResourceIDs: Set<ResourceID
    ///
    /// The following behavior is expected:
    /// 1. A set containing the Resource IDs (Strings) of all store Versions should be returned
    ///
    func test_allResourceIDs() {
        
        var locationSplitVersionStore: LocationSplitVersionStore = .init()
        var resourceIDs: Set<ResourceID>

        let vs1: VersionStore = .init(withVersions: ["Test1":    .init(major: 1,   minor: 2,   patch: 3),
                                                     "Test2":    .init(major: 123, minor: 456, patch: 789),
                                                     "Test3":    .init(major: 0,   minor: 0,   patch: 1)])

        let vs2: VersionStore = .init(withVersions: ["Test1":    .init(major: 1,   minor: 2,   patch: 3),
                                                     "Test4":    .init(major: 123, minor: 456, patch: 789),
                                                     "Test5":    .init(major: 0,   minor: 0,   patch: 1)])

        let vs3: VersionStore = .init(withVersions: ["Test2":    .init(major: 1,   minor: 2,   patch: 3),
                                                     "Test3":    .init(major: 123, minor: 456, patch: 789),
                                                     "Test6":    .init(major: 0,   minor: 0,   patch: 1)])
        
        // Behavior #1 - 1:
        
            resourceIDs = locationSplitVersionStore.test_allResourceIDs
            XCTAssertEqual(resourceIDs.count, 0)
        
        // Behavior #1 - 2:
            
            locationSplitVersionStore.setVersions(vs1, forLocation: .cache)
            locationSplitVersionStore.setVersions(vs1, forLocation: .bundle)
            locationSplitVersionStore.setVersions(vs1, forLocation: .remote)
        
            resourceIDs = locationSplitVersionStore.test_allResourceIDs
        
            XCTAssertEqual(resourceIDs.count, 3)
            XCTAssertTrue(resourceIDs.contains("Test1"))
            XCTAssertTrue(resourceIDs.contains("Test2"))
            XCTAssertTrue(resourceIDs.contains("Test3"))
        
        // Behavior #1 - 3:
            
            locationSplitVersionStore.setVersions(vs1, forLocation: .cache)
            locationSplitVersionStore.setVersions(vs2, forLocation: .bundle)
            locationSplitVersionStore.setVersions(vs2, forLocation: .remote)
        
            resourceIDs = locationSplitVersionStore.test_allResourceIDs
        
            XCTAssertEqual(resourceIDs.count, 5)
            XCTAssertTrue(resourceIDs.contains("Test1"))
            XCTAssertTrue(resourceIDs.contains("Test2"))
            XCTAssertTrue(resourceIDs.contains("Test3"))
            XCTAssertTrue(resourceIDs.contains("Test4"))
            XCTAssertTrue(resourceIDs.contains("Test5"))
        
        // Behavior #1 - 4:
            
            locationSplitVersionStore.setVersions(vs1, forLocation: .cache)
            locationSplitVersionStore.setVersions(vs2, forLocation: .bundle)
            locationSplitVersionStore.setVersions(vs3, forLocation: .remote)
        
            resourceIDs = locationSplitVersionStore.test_allResourceIDs
        
            XCTAssertEqual(resourceIDs.count, 6)
            XCTAssertTrue(resourceIDs.contains("Test1"))
            XCTAssertTrue(resourceIDs.contains("Test2"))
            XCTAssertTrue(resourceIDs.contains("Test3"))
            XCTAssertTrue(resourceIDs.contains("Test4"))
            XCTAssertTrue(resourceIDs.contains("Test5"))
            XCTAssertTrue(resourceIDs.contains("Test6"))
        
    }
}


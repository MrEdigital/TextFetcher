///
///  LocationSplitVersionStore_Interface_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// LocationSplitVersionStore Unit Tests - Interface
///
class LocationSplitVersionStore_Interface_Tests: XCTestCase {
    let versionsS = TestingResources.BundleFileContents.Versions.s
    let versionsM = TestingResources.BundleFileContents.Versions.m
    let versionsL = TestingResources.BundleFileContents.Versions.l
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func versionStoreForLocation(_ location: ResourceLocation) -> VersionStore
///     func version(forResource resourceID: ResourceID, inLocation location: ResourceLocation) -> Version?
///     func allVersions(forResource resourceID: ResourceID) -> [LocationBoundVersion]
///     func forEachResource(_ forEach: (_ locatedVersions: [LocationBoundVersion], _ resourceID: ResourceID) -> Void)
///
extension LocationSplitVersionStore_Interface_Tests {
    
    // MARK: - T - Version Store For Location
    ///
    /// Tests the function:
    ///
    ///      func versionStoreForLocation(_ location: ResourceLocation) -> VersionStore
    ///
    /// The following behavior is expected:
    /// 1. A location of .cache should return the cachedVersions VersionStore
    /// 2. A location of .bundle should return the bundledVersions VersionStore
    /// 3. A location of .remote should return the remoteVersions VersionStore
    ///
    func test_versionStoreForLocation() {
        
        var locationSplitVersionStore: LocationSplitVersionStore = .init()
        var versionStore: VersionStore
        var expectedStore: VersionStore
        
        locationSplitVersionStore.setVersions(versionsS, forLocation: .cache)
        locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
        locationSplitVersionStore.setVersions(versionsL, forLocation: .remote)
        
        // Behavior #1:
        
            versionStore = locationSplitVersionStore.versionStoreForLocation(.cache)
            expectedStore = locationSplitVersionStore.test_cachedVersions
            
            XCTAssertEqual(versionStore.count, expectedStore.count)
            versionStore.forEachResource { resourceID, version in
                XCTAssertEqual(version, expectedStore.version(forResource: resourceID))
            }
        
        // Behavior #2:
        
            versionStore = locationSplitVersionStore.versionStoreForLocation(.bundle)
            expectedStore = locationSplitVersionStore.test_bundledVersions
            
            XCTAssertEqual(versionStore.count, expectedStore.count)
            versionStore.forEachResource { resourceID, version in
                XCTAssertEqual(version, expectedStore.version(forResource: resourceID))
            }
        
        // Behavior #3:
        
            versionStore = locationSplitVersionStore.versionStoreForLocation(.remote)
            expectedStore = locationSplitVersionStore.test_remoteVersions
            
            XCTAssertEqual(versionStore.count, expectedStore.count)
            versionStore.forEachResource { resourceID, version in
                XCTAssertEqual(version, expectedStore.version(forResource: resourceID))
            }
    }
    
    // MARK: - T - Version For Resource
    ///
    /// Tests the function:
    ///
    ///      func version(forResource resourceID: ResourceID, inLocation location: ResourceLocation) -> Version?
    ///
    /// The following behavior is expected:
    /// 1. If no resource is found for the provided ResourceID, nil should be returned
    /// 2. Otherwise, the version associated with the resource in the given location should be returned
    ///
    func test_versionForResource() {
        
        var locationSplitVersionStore: LocationSplitVersionStore = .init()
        var versionForResource: Version?
        
        locationSplitVersionStore.setVersions(versionsS, forLocation: .cache)
        locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
        locationSplitVersionStore.setVersions(versionsL, forLocation: .remote)
        
        // Behavior #1:
            
            versionForResource = locationSplitVersionStore.version(forResource: "", inLocation: .cache)
            XCTAssertEqual(versionForResource, nil)
        
        // Behavior #2 - 1:
        
            versionsS.forEachResource { resourceID, version in
                versionForResource = locationSplitVersionStore.version(forResource: resourceID, inLocation: .cache)
                XCTAssertEqual(versionForResource, version)
            }
        
        // Behavior #2 - 2:
        
            versionsM.forEachResource { resourceID, version in
                versionForResource = locationSplitVersionStore.version(forResource: resourceID, inLocation: .bundle)
                XCTAssertEqual(versionForResource, version)
            }
        
        // Behavior #2 - 3:
        
            versionsL.forEachResource { resourceID, version in
                versionForResource = locationSplitVersionStore.version(forResource: resourceID, inLocation: .remote)
                XCTAssertEqual(versionForResource, version)
            }
        
    }
    
    // MARK: - T - All Versions For Resource
    ///
    /// Tests the function:
    ///
    ///      func allVersions(forResource resourceID: ResourceID) -> [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. All versions (LocationBoundVersions) associated with the given ResourceID are returned
    /// 2. If no value is registered, a value of .zero will still be returned
    ///
    func test_allVersionsForResource() {
        
        var locationSplitVersionStore: LocationSplitVersionStore = .init()
        var versionsForResource: [LocationBoundVersion]
        
        guard versionsS.count > 1 else {
            XCTFail("There are supposed to be multiple versions in here!")
            return
        }
        
        // Behavior #1 - 1:
        
            locationSplitVersionStore.setVersions(versionsS, forLocation: .cache)
            locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
        
            for resourceID in versionsS.allResourceIDs {
                versionsForResource = locationSplitVersionStore.allVersions(forResource: resourceID)
                XCTAssertEqual(versionsForResource.count, 3)
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .cache && $0.version == versionsS.version(forResource: resourceID) }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .bundle && $0.version == versionsM.version(forResource: resourceID) }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .remote && $0.version == .zero }))
            }
        
        // Behavior #1 - 2:
        
            locationSplitVersionStore.setVersions(versionsS, forLocation: .cache)
            locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
            locationSplitVersionStore.setVersions(versionsL, forLocation: .remote)
        
            for resourceID in versionsS.allResourceIDs {
                versionsForResource = locationSplitVersionStore.allVersions(forResource: resourceID)
                XCTAssertEqual(versionsForResource.count, 3)
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .cache && $0.version == versionsS.version(forResource: resourceID) }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .bundle && $0.version == versionsM.version(forResource: resourceID) }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .remote && $0.version == versionsL.version(forResource: resourceID) }))
            }
        
        // Behavior #3:
        
            locationSplitVersionStore.setVersions(nil, forLocation: .cache)
            locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
            locationSplitVersionStore.setVersions(nil, forLocation: .remote)
        
            for resourceID in versionsS.allResourceIDs {
                versionsForResource = locationSplitVersionStore.allVersions(forResource: resourceID)
                XCTAssertEqual(versionsForResource.count, 3)
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .cache && $0.version == .zero }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .bundle && $0.version == versionsM.version(forResource: resourceID) }))
                XCTAssertTrue(versionsForResource.contains(where: { $0.location == .remote && $0.version == .zero }))
            }
        
    }
    
    // MARK: - T - For Each Resource
    ///
    /// Tests the function:
    ///
    ///      func forEachResource(_ forEach: (_ locatedVersions: [LocationBoundVersion], _ resourceID: ResourceID) -> Void)
    ///
    /// The following behavior is expected:
    /// 1. The given closure is fired once for each ResourceID, passing through the ResourceID as well as all its associated versions
    ///
    func test_forEachResource() {
        
        var locationSplitVersionStore: LocationSplitVersionStore = .init()
        
        // Behavior #1 - 1:
        
            locationSplitVersionStore.setVersions(versionsS, forLocation: .cache)
            locationSplitVersionStore.setVersions(versionsM, forLocation: .bundle)
        
            locationSplitVersionStore.forEachResource { resourceID, locationBoundVersion in
                XCTAssertEqual(locationBoundVersion.count, 3)
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .cache && $0.version == versionsS.version(forResource: resourceID) }))
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .bundle && $0.version == versionsM.version(forResource: resourceID) }))
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .remote && $0.version == .zero }))
            }
        
        // Behavior #1 - 2:
        
            locationSplitVersionStore.setVersions(versionsM, forLocation: .cache)
            locationSplitVersionStore.setVersions(versionsS, forLocation: .bundle)
            locationSplitVersionStore.setVersions(versionsL, forLocation: .remote)
        
            locationSplitVersionStore.forEachResource { resourceID, locationBoundVersion in
                XCTAssertEqual(locationBoundVersion.count, 3)
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .cache && $0.version == versionsM.version(forResource: resourceID) }))
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .bundle && $0.version == versionsS.version(forResource: resourceID) }))
                XCTAssertTrue(locationBoundVersion.contains(where: { $0.location == .remote && $0.version == versionsL.version(forResource: resourceID) }))
            }
    }
}

///
///  LocationSplitVersionStore_Setter_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// LocationSplitVersionStore Unit Tests - Setters
///
class LocationSplitVersionStore_Setter_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     mutating func setVersions(_ versionStore: VersionStore?, forLocation location: ResourceLocation)
///     mutating func setVersion(_ version: Version, forResource resourceID: ResourceID, inLocation location: ResourceLocation)
///
extension LocationSplitVersionStore_Setter_Tests {
    
    // MARK: - T - Set Versions
    ///
    /// Tests the function:
    ///
    ///      mutating func setVersions(_ versionStore: VersionStore?, forLocation location: ResourceLocation)
    ///
    /// The following behavior is expected:
    /// 1. The VersionStore associated with the given location should be replaced with the given value
    /// 2. Setting a VersionStore to nil should result in an EMPTY VersionStore being set
    ///
    func test_setVersions() {
        
        var locationSplitVersionStore: LocationSplitVersionStore
        
        // Pre-Behavior:
        
            locationSplitVersionStore = .init()
            XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.count, 0)
        
        // Behavior #1 - 1:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)

            XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.count, 0)
        
            TestingResources.BundleFileContents.Versions.s.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.version(forResource: resourceID), version)
            }
        
        // Behavior #1 - 2:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.m, forLocation: .bundle)

            XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.count, 0)
        
            TestingResources.BundleFileContents.Versions.m.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.version(forResource: resourceID), version)
            }
        
        // Behavior #1 - 3:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.l, forLocation: .remote)

            XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.count, 0)
        
            TestingResources.BundleFileContents.Versions.l.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.version(forResource: resourceID), version)
            }
        
        // Behavior #1 - 4:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.m, forLocation: .bundle)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.l, forLocation: .remote)
            
            TestingResources.BundleFileContents.Versions.s.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.version(forResource: resourceID), version)
            }
        
            TestingResources.BundleFileContents.Versions.m.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.version(forResource: resourceID), version)
            }
        
            TestingResources.BundleFileContents.Versions.l.forEachResource { resourceID, version in
                XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.version(forResource: resourceID), version)
            }
        
        // Behavior #2:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.m, forLocation: .bundle)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.l, forLocation: .remote)

            locationSplitVersionStore.setVersions(nil, forLocation: .cache)
            locationSplitVersionStore.setVersions(nil, forLocation: .bundle)
            locationSplitVersionStore.setVersions(nil, forLocation: .remote)
            
            XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.count, 0)
            XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.count, 0)
    }
    
    // MARK: - T - Set Version For Resource
    ///
    /// Tests the function:
    ///
    ///      public static let zero: Version
    ///
    /// The following behavior is expected:
    /// 1. The Version corresponding with the given Resource ID in the given Location should be replaced with, or set to, the given Version
    ///
    func test_setVersionForResource() {
        
        var locationSplitVersionStore: LocationSplitVersionStore
        var resourceID: ResourceID
        
        // Behavior #1 - 1:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .bundle)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .remote)
        
            resourceID = TestingResources.BundleFileContents.Versions.s.test_resourceVersions.keys.first!
            locationSplitVersionStore.setVersion(.zero, forResource: resourceID, inLocation: .cache)
        
            XCTAssertEqual(locationSplitVersionStore.test_cachedVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertNotEqual(locationSplitVersionStore.test_bundledVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertNotEqual(locationSplitVersionStore.test_remoteVersions.test_resourceVersions[resourceID], .zero)
        
        // Behavior #1 - 2:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .bundle)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .remote)
        
            resourceID = TestingResources.BundleFileContents.Versions.s.test_resourceVersions.keys.first!
            locationSplitVersionStore.setVersion(.zero, forResource: resourceID, inLocation: .bundle)
        
            XCTAssertNotEqual(locationSplitVersionStore.test_cachedVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertEqual(locationSplitVersionStore.test_bundledVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertNotEqual(locationSplitVersionStore.test_remoteVersions.test_resourceVersions[resourceID], .zero)
        
        // Behavior #1 - 3:

            locationSplitVersionStore = .init()
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .cache)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .bundle)
            locationSplitVersionStore.setVersions(TestingResources.BundleFileContents.Versions.s, forLocation: .remote)
        
            resourceID = TestingResources.BundleFileContents.Versions.s.test_resourceVersions.keys.first!
            locationSplitVersionStore.setVersion(.zero, forResource: resourceID, inLocation: .remote)
        
            XCTAssertNotEqual(locationSplitVersionStore.test_cachedVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertNotEqual(locationSplitVersionStore.test_bundledVersions.test_resourceVersions[resourceID], .zero)
            XCTAssertEqual(locationSplitVersionStore.test_remoteVersions.test_resourceVersions[resourceID], .zero)
    }
}


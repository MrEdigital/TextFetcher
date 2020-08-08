///
///  LocationBoundVersion_ArrayGetter_Tests.swift
///  Created on 8/3/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// LocationBoundVersion Unit Tests - Array Getters
///
class LocationBoundVersion_ArrayGetter_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following getters:
///
///     var byLocation_ascending: Self
///     var byLocation_descending: Self
///     var byVersion_ascending: Self
///     var byVersion_descending: Self
///     func removingStaleValues() -> Self
///
extension LocationBoundVersion_ArrayGetter_Tests {
    
    // MARK: - T - By Location - Asc
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      var byLocation_ascending: [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. A new instance of the same Array is returned, sorted first by version, then by location distance from the cache, in ascending order (closest to furthest).
    ///
    func test_byLocation_ascending() {
        
        // Location Ordering Note:
        // Cache < Bundle < Remote

        let expectedValue0: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .cache)
        let expectedValue1: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 1), location: .cache)
        let expectedValue2: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .cache)
        let expectedValue3: LocationBoundVersion = .init(version: .init(major: 3, minor: 0, patch: 0), location: .bundle)
        let expectedValue4: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .bundle)
        let expectedValue5: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
        let expectedValue6: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .bundle)
        let expectedValue7: LocationBoundVersion = .init(version: .init(major: 4, minor: 0, patch: 0), location: .remote)
        let expectedValue8: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .remote)
        let expectedValue9: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .remote)
        
        let array: [LocationBoundVersion] = [expectedValue3,
                                             expectedValue6,
                                             expectedValue4,
                                             expectedValue2,
                                             expectedValue1,
                                             expectedValue0,
                                             expectedValue5,
                                             expectedValue9,
                                             expectedValue7,
                                             expectedValue8]
        
        // Behavior #1:
        
            let sortedArray = array.byLocation_ascending
            
            XCTAssertEqual(sortedArray.count, array.count)
            
            XCTAssertEqual(sortedArray[0].location, expectedValue0.location)
            XCTAssertEqual(sortedArray[1].location, expectedValue1.location)
            XCTAssertEqual(sortedArray[2].location, expectedValue2.location)
            XCTAssertEqual(sortedArray[3].location, expectedValue3.location)
            XCTAssertEqual(sortedArray[4].location, expectedValue4.location)
            XCTAssertEqual(sortedArray[5].location, expectedValue5.location)
            XCTAssertEqual(sortedArray[6].location, expectedValue6.location)
            XCTAssertEqual(sortedArray[7].location, expectedValue7.location)
            XCTAssertEqual(sortedArray[8].location, expectedValue8.location)
            XCTAssertEqual(sortedArray[9].location, expectedValue9.location)
            
            XCTAssertEqual(sortedArray[0].version, expectedValue0.version)
            XCTAssertEqual(sortedArray[1].version, expectedValue1.version)
            XCTAssertEqual(sortedArray[2].version, expectedValue2.version)
            XCTAssertEqual(sortedArray[3].version, expectedValue3.version)
            XCTAssertEqual(sortedArray[4].version, expectedValue4.version)
            XCTAssertEqual(sortedArray[5].version, expectedValue5.version)
            XCTAssertEqual(sortedArray[6].version, expectedValue6.version)
            XCTAssertEqual(sortedArray[7].version, expectedValue7.version)
            XCTAssertEqual(sortedArray[8].version, expectedValue8.version)
            XCTAssertEqual(sortedArray[9].version, expectedValue9.version)
        
    }
    
    // MARK: - T - By Location - Desc
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      var byLocation_descending: [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. A new instance of the same Array is returned, sorted first by version, then by location distance from the cache, in descending order (furthest to closest).
    ///
    func test_byLocation_descending() {
        
        // Location Ordering Note:
        // Cache < Bundle < Remote

        let expectedValue9: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .cache)
        let expectedValue8: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 1), location: .cache)
        let expectedValue7: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .cache)
        let expectedValue6: LocationBoundVersion = .init(version: .init(major: 3, minor: 0, patch: 0), location: .bundle)
        let expectedValue5: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .bundle)
        let expectedValue4: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
        let expectedValue3: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .bundle)
        let expectedValue2: LocationBoundVersion = .init(version: .init(major: 4, minor: 0, patch: 0), location: .remote)
        let expectedValue1: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .remote)
        let expectedValue0: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .remote)
        
        let array: [LocationBoundVersion] = [expectedValue3,
                                             expectedValue6,
                                             expectedValue4,
                                             expectedValue2,
                                             expectedValue1,
                                             expectedValue0,
                                             expectedValue5,
                                             expectedValue9,
                                             expectedValue7,
                                             expectedValue8]
        
        // Behavior #1:
        
            let sortedArray = array.byLocation_descending
            
            XCTAssertEqual(sortedArray.count, array.count)
            
            XCTAssertEqual(sortedArray[0].location, expectedValue0.location)
            XCTAssertEqual(sortedArray[1].location, expectedValue1.location)
            XCTAssertEqual(sortedArray[2].location, expectedValue2.location)
            XCTAssertEqual(sortedArray[3].location, expectedValue3.location)
            XCTAssertEqual(sortedArray[4].location, expectedValue4.location)
            XCTAssertEqual(sortedArray[5].location, expectedValue5.location)
            XCTAssertEqual(sortedArray[6].location, expectedValue6.location)
            XCTAssertEqual(sortedArray[7].location, expectedValue7.location)
            XCTAssertEqual(sortedArray[8].location, expectedValue8.location)
            XCTAssertEqual(sortedArray[9].location, expectedValue9.location)
            
            XCTAssertEqual(sortedArray[0].version, expectedValue0.version)
            XCTAssertEqual(sortedArray[1].version, expectedValue1.version)
            XCTAssertEqual(sortedArray[2].version, expectedValue2.version)
            XCTAssertEqual(sortedArray[3].version, expectedValue3.version)
            XCTAssertEqual(sortedArray[4].version, expectedValue4.version)
            XCTAssertEqual(sortedArray[5].version, expectedValue5.version)
            XCTAssertEqual(sortedArray[6].version, expectedValue6.version)
            XCTAssertEqual(sortedArray[7].version, expectedValue7.version)
            XCTAssertEqual(sortedArray[8].version, expectedValue8.version)
            XCTAssertEqual(sortedArray[9].version, expectedValue9.version)
    }
    
    // MARK: - T - By Version - Asc
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      var byVersion_ascending: [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. A new instance of the same Array is returned, sorted first by distance from the cache desending (furthest to closest), then by version, in ascending order (smallest to largest)
    ///
    func test_byVersion_ascending() {
        
        // Location Ordering Note:
        // Cache < Bundle < Remote

        let expectedValue0: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 0), location: .remote)
        let expectedValue1: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .remote)
        let expectedValue2: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .bundle)
        let expectedValue3: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
        let expectedValue4: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .cache)
        let expectedValue5: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .cache)
        let expectedValue6: LocationBoundVersion = .init(version: .init(major: 3, minor: 0, patch: 0), location: .bundle)
        let expectedValue7: LocationBoundVersion = .init(version: .init(major: 4, minor: 0, patch: 0), location: .cache)
        let expectedValue8: LocationBoundVersion = .init(version: .init(major: 5, minor: 0, patch: 0), location: .remote)
        let expectedValue9: LocationBoundVersion = .init(version: .init(major: 6, minor: 0, patch: 0), location: .bundle)
        
        let array: [LocationBoundVersion] = [expectedValue3,
                                             expectedValue6,
                                             expectedValue4,
                                             expectedValue2,
                                             expectedValue1,
                                             expectedValue0,
                                             expectedValue5,
                                             expectedValue9,
                                             expectedValue7,
                                             expectedValue8]
                                             
        // Behavior #1:
        
            let sortedArray = array.byVersion_ascending
            
            XCTAssertEqual(sortedArray.count, array.count)
            
            XCTAssertEqual(sortedArray[0].location, expectedValue0.location)
            XCTAssertEqual(sortedArray[1].location, expectedValue1.location)
            XCTAssertEqual(sortedArray[2].location, expectedValue2.location)
            XCTAssertEqual(sortedArray[3].location, expectedValue3.location)
            XCTAssertEqual(sortedArray[4].location, expectedValue4.location)
            XCTAssertEqual(sortedArray[5].location, expectedValue5.location)
            XCTAssertEqual(sortedArray[6].location, expectedValue6.location)
            XCTAssertEqual(sortedArray[7].location, expectedValue7.location)
            XCTAssertEqual(sortedArray[8].location, expectedValue8.location)
            XCTAssertEqual(sortedArray[9].location, expectedValue9.location)
            
            XCTAssertEqual(sortedArray[0].version, expectedValue0.version)
            XCTAssertEqual(sortedArray[1].version, expectedValue1.version)
            XCTAssertEqual(sortedArray[2].version, expectedValue2.version)
            XCTAssertEqual(sortedArray[3].version, expectedValue3.version)
            XCTAssertEqual(sortedArray[4].version, expectedValue4.version)
            XCTAssertEqual(sortedArray[5].version, expectedValue5.version)
            XCTAssertEqual(sortedArray[6].version, expectedValue6.version)
            XCTAssertEqual(sortedArray[7].version, expectedValue7.version)
            XCTAssertEqual(sortedArray[8].version, expectedValue8.version)
            XCTAssertEqual(sortedArray[9].version, expectedValue9.version)
    }
    
    // MARK: - T - By Version - Desc
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      var byVersion_descending: [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. An new instance of the same Array is returned, sorted first by distance from the cache ascending (closest to furthest), then by version, in descending order (largest to smallest).
    ///
    func test_byVersion_descending() {
        
        // Location Ordering Note:
        // Cache < Bundle < Remote

        let expectedValue9: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 0), location: .remote)
        let expectedValue8: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .remote)
        let expectedValue7: LocationBoundVersion = .init(version: .init(major: 0, minor: 0, patch: 1), location: .bundle)
        let expectedValue6: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
        let expectedValue5: LocationBoundVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .cache)
        let expectedValue4: LocationBoundVersion = .init(version: .init(major: 2, minor: 0, patch: 0), location: .cache)
        let expectedValue3: LocationBoundVersion = .init(version: .init(major: 3, minor: 0, patch: 0), location: .bundle)
        let expectedValue2: LocationBoundVersion = .init(version: .init(major: 4, minor: 0, patch: 0), location: .cache)
        let expectedValue1: LocationBoundVersion = .init(version: .init(major: 5, minor: 0, patch: 0), location: .remote)
        let expectedValue0: LocationBoundVersion = .init(version: .init(major: 6, minor: 0, patch: 0), location: .bundle)
        
        let array: [LocationBoundVersion] = [expectedValue3,
                                             expectedValue6,
                                             expectedValue4,
                                             expectedValue2,
                                             expectedValue1,
                                             expectedValue0,
                                             expectedValue5,
                                             expectedValue9,
                                             expectedValue7,
                                             expectedValue8]
        
        // Behavior #1:
        
            let sortedArray = array.byVersion_descending
            
            XCTAssertEqual(sortedArray.count, array.count)
            
            XCTAssertEqual(sortedArray[0].location, expectedValue0.location)
            XCTAssertEqual(sortedArray[1].location, expectedValue1.location)
            XCTAssertEqual(sortedArray[2].location, expectedValue2.location)
            XCTAssertEqual(sortedArray[3].location, expectedValue3.location)
            XCTAssertEqual(sortedArray[4].location, expectedValue4.location)
            XCTAssertEqual(sortedArray[5].location, expectedValue5.location)
            XCTAssertEqual(sortedArray[6].location, expectedValue6.location)
            XCTAssertEqual(sortedArray[7].location, expectedValue7.location)
            XCTAssertEqual(sortedArray[8].location, expectedValue8.location)
            XCTAssertEqual(sortedArray[9].location, expectedValue9.location)
            
            XCTAssertEqual(sortedArray[0].version, expectedValue0.version)
            XCTAssertEqual(sortedArray[1].version, expectedValue1.version)
            XCTAssertEqual(sortedArray[2].version, expectedValue2.version)
            XCTAssertEqual(sortedArray[3].version, expectedValue3.version)
            XCTAssertEqual(sortedArray[4].version, expectedValue4.version)
            XCTAssertEqual(sortedArray[5].version, expectedValue5.version)
            XCTAssertEqual(sortedArray[6].version, expectedValue6.version)
            XCTAssertEqual(sortedArray[7].version, expectedValue7.version)
            XCTAssertEqual(sortedArray[8].version, expectedValue8.version)
            XCTAssertEqual(sortedArray[9].version, expectedValue9.version)
    }
    
    // MARK: - T - Removing Stale Values
    ///
    /// Version Unit Test
    ///
    /// Tests the getter:
    ///
    ///      func removingStaleValues() -> [LocationBoundVersion]
    ///
    /// The following behavior is expected:
    /// 1. An new instance of the same Array is returned, with any values less than or equal to the cached value removed.
    /// 2. If no cached value is included, the Array returns unchanged.
    ///
    func test_removingStaleValues() {
        
        // Location Ordering Note:
        // Cache < Bundle < Remote

        var cacheVersion: LocationBoundVersion
        var bundleVersion: LocationBoundVersion
        var remoteVersion: LocationBoundVersion
        
        var array: [LocationBoundVersion]
        var purgedArray: [LocationBoundVersion]
        
        // Behavior #1 - 1:

            cacheVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .cache)
            bundleVersion = .init(version: .init(major: 1, minor: 0, patch: 1), location: .bundle)
            remoteVersion = .init(version: .init(major: 2, minor: 0, patch: 1), location: .remote)
            
            array = [cacheVersion, bundleVersion, remoteVersion]
            purgedArray = array.removingStaleValues()
            
            XCTAssertEqual(purgedArray.count, 2)
            XCTAssertTrue(array.contains(where: { $0.location == bundleVersion.location && $0.version == bundleVersion.version }))
            XCTAssertTrue(array.contains(where: { $0.location == remoteVersion.location && $0.version == remoteVersion.version }))
        
        // Behavior #1 - 2:

            cacheVersion = .init(version: .init(major: 1, minor: 0, patch: 1), location: .cache)
            bundleVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
            remoteVersion = .init(version: .init(major: 2, minor: 0, patch: 1), location: .remote)
            
            array = [cacheVersion, bundleVersion, remoteVersion]
            purgedArray = array.removingStaleValues()
            
            XCTAssertEqual(purgedArray.count, 1)
            XCTAssertTrue(array.contains(where: { $0.location == remoteVersion.location && $0.version == remoteVersion.version }))
        
        // Behavior #1 - 3:

            cacheVersion = .init(version: .init(major: 3, minor: 0, patch: 1), location: .cache)
            bundleVersion = .init(version: .init(major: 1, minor: 0, patch: 0), location: .bundle)
            remoteVersion = .init(version: .init(major: 2, minor: 0, patch: 1), location: .remote)
            
            array = [cacheVersion, bundleVersion, remoteVersion]
            purgedArray = array.removingStaleValues()
            
            XCTAssertEqual(purgedArray.count, 0)
        
        // Behavior #2:

            bundleVersion = .init(version: .init(major: 1, minor: 0, patch: 1), location: .bundle)
            remoteVersion = .init(version: .init(major: 2, minor: 0, patch: 1), location: .remote)
            
            array = [bundleVersion, remoteVersion]
            purgedArray = array.removingStaleValues()
            
            XCTAssertEqual(purgedArray.count, 2)
            XCTAssertTrue(array.contains(where: { $0.location == bundleVersion.location && $0.version == bundleVersion.version }))
            XCTAssertTrue(array.contains(where: { $0.location == remoteVersion.location && $0.version == remoteVersion.version }))
    }
}

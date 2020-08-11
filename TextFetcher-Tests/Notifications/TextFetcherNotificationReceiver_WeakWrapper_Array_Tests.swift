///
///  TextFetcherNotificationReceiver_WeakWrapper_Array_Tests.swift
///  Created on 7/24/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcherNotificationReceiver_WeakWrapper_Array_Tests Unit Tests
///
class TextFetcherNotificationReceiver_WeakWrapper_Array_Tests: XCTestCase { }

// MARK: - Tests...
///
/// Covering the following functions:
///
///     mutating func purgeEmptyWrappers()
///     func receivers() -> [TextFetcherNotificationReceiver]
///
extension TextFetcherNotificationReceiver_WeakWrapper_Array_Tests {
    
    // MARK: - T - Purge Empty Wrappers
    ///
    /// Tests the function:
    ///
    ///     mutating func purgeEmptyWrappers()
    ///
    /// The following behavior is expected:
    /// 1. Clears all elements from the array which contain nil (released) values
    ///
    func test_purgeEmptyWrappers() {
        
        let toRetain: [TestReceiver] = [.init(), .init(), .init(), .init()]
        var toRelease: [TestReceiver] = [.init(), .init(), .init(), .init(), .init(), .init()]
        
        var weakWrapperArray: [TextFetcherNotificationReceiver_WeakWrapper] = []
        
        for receiver in toRetain + toRelease {
            weakWrapperArray.append(.init(withTestValue: receiver))
        }
        
        // Pre Behavior:
        
            weakWrapperArray.test_purgeEmptyWrappers()
            XCTAssertEqual(weakWrapperArray.count, (toRetain + toRelease).count)
        
        // Behavior #1:
        
            toRelease.removeAll()
            weakWrapperArray.test_purgeEmptyWrappers()
            XCTAssertEqual(weakWrapperArray.count, toRetain.count)
    }
    
    // MARK: - T - Receivers
    ///
    /// Tests the function:
    ///
    ///     func receivers() -> [TextFetcherNotificationReceiver]
    ///
    /// The following behavior is expected:
    /// 1. Returns all non-nil wrapped references, contained within an array
    ///
    func test_receivers() {
        
        let toRetain: [TestReceiver] = [.init(), .init(), .init(), .init()]
        var toRelease: [TestReceiver] = [.init(), .init(), .init(), .init(), .init(), .init()]
        
        var weakWrapperArray: [TextFetcherNotificationReceiver_WeakWrapper] = []
        
        for receiver in toRetain + toRelease {
            weakWrapperArray.append(.init(withTestValue: receiver))
        }
        
        // Pre Behavior:
        
            var receivers1 = weakWrapperArray.test_receivers()
            XCTAssertEqual(receivers1.count, toRetain.count + toRelease.count)
            receivers1.removeAll()
        
        // Behavior #1:
        
            toRelease.removeAll()
            var receivers2 = weakWrapperArray.test_receivers()
            XCTAssertEqual(receivers2.count, toRetain.count)
            receivers2.removeAll()
    }
}

// MARK: - Mock Object

extension TextFetcherNotificationReceiver_WeakWrapper_Array_Tests {
    
    class TestReceiver: TextFetcherNotificationReceiver {
        func versionIncreased(to version: Version, for textSource: TextSource) {}
    }
}


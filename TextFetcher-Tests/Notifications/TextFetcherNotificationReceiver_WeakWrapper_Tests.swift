///
///  TextFetcherNotificationReceiver_WeakWrapper_Tests.swift
///  Created on 7/24/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcherNotificationReceiver_WeakWrapper Unit Tests
///
class TextFetcherNotificationReceiver_WeakWrapper_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following values and functions:
///
///     private(set) weak var value: TextFetcherNotificationReceiver?
///     fileprivate init(value: TextFetcherNotificationReceiver)
///
extension TextFetcherNotificationReceiver_WeakWrapper_Tests {
    
    // MARK: - T - Initialization
    ///
    /// TextFetcherNotificationReceiver_WeakWrapper Unit Test
    ///
    /// Tests the function:
    ///
    ///     fileprivate init(value: TextFetcherNotificationReceiver)
    ///
    /// The following behavior is expected:
    /// 1. Sets the value property in the wrapper instance to the supplied reference value
    ///
    func test_initialization() {
        
        let receiver: TestReceiver? = .init()
        let weakWrapper: TextFetcherNotificationReceiver_WeakWrapper = .init(withTestValue: receiver!)
        
        // Behavior #1:
            XCTAssertNotNil(weakWrapper.value)
            XCTAssertTrue(receiver === weakWrapper.value)
    }
    
    // MARK: - T - Weak References
    ///
    /// TextFetcherNotificationReceiver_WeakWrapper Unit Test
    ///
    /// Tests the value:
    ///
    ///     private(set) weak var value: TextFetcherNotificationReceiver?
    ///
    /// The following behavior is expected:
    /// 1. The value should remain stored so long as it is externally retained
    /// 2. When no longer retained externally the value should automatically release as welll
    ///
    func test_weakReferences() {
        
        var receiver: TestReceiver? = .init()
        let weakWrapper: TextFetcherNotificationReceiver_WeakWrapper = .init(withTestValue: receiver!)
        
        // Behavior #1:
            XCTAssertNotNil(weakWrapper.value)
            XCTAssertTrue(receiver === weakWrapper.value)
        
        // Behavior #2:
            receiver = nil
            XCTAssertNil(weakWrapper.value)
    }
}

// MARK: - Mock Object

extension TextFetcherNotificationReceiver_WeakWrapper_Tests {
    
    class TestReceiver: TextFetcherNotificationReceiver {
        func versionIncreased(to version: Version, for textSource: TextSource) {}
    }
}

///
///  BundledResourceInterfacer_Configuration_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// BundledResourceInterfacer Unit Tests - Configuration
///
class BundledResourceInterfacer_Configuration_Tests: XCTestCase {
    
    var interfacer: BundledResourceInterfacer!
    
    override func setUp() {
        super.setUp()
        interfacer = .init()
        interfacer.setBundle(to: Bundle(for: Self.self))
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func setBundle(to bundle: Bundle)
///
extension BundledResourceInterfacer_Configuration_Tests {
    
    // MARK: - T - Set Bundle
    ///
    /// Tests the function:
    ///
    ///     func setBundle(to bundle: Bundle)
    ///
    /// The following behavior is expected:
    /// 1. Sets the bundle property in interfacer to the supplied reference value
    ///
    func test_setBundle() {
        
        // Behavior #1 - 1:
            interfacer.setBundle(to: .main)
            XCTAssertEqual(interfacer.test_bundle, .main)
        
        // Behavior #1 - 2:
            interfacer.setBundle(to: Bundle(for: Self.self))
            XCTAssertEqual(interfacer.test_bundle, Bundle(for: Self.self))
    }
}

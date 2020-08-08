///
///  RemoteResourceInterfacer_Configuration_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// RemoteResourceInterfacer Unit Tests - Configuration
///
class RemoteResourceInterfacer_Configuration_Tests: XCTestCase {
    
    var interfacer: RemoteResourceInterfacer!
    
    override func setUp() {
        super.setUp()
        
        interfacer = .init()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func setResourceTimeout(to timeout: TimeInterval)
///
extension RemoteResourceInterfacer_Configuration_Tests {
    
    // MARK: - T - Set Resource Timeout
    ///
    /// RemoteResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func setResourceTimeout(to timeout: TimeInterval)
    ///
    /// The following behavior is expected:
    /// 1. Set the timeout property to the supplied value.
    /// 2. Use that value as the timeout value for any text fetches.
    ///
    func test_setResourceTimeout() {
        
        interfacer.setResourceTimeout(to: 0.5)
        
        // Behavior #1:
            XCTAssertEqual(interfacer.test_timeout, 0.5)
        
        // Behavior #2:

            let urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Texts.m
            let textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            let exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: textSource) { text in
                
                // The stubbed response for Endpoints.Texts.m is set to 1 second
                // The Wait should trigger with an error after 0.75 seconds
                // This should timeout and be called in 0.5 seconds
                XCTAssertNil(text)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 0.75) { error in
                XCTAssertNil(error)
            }
    }
}

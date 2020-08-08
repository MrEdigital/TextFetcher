///
///  TextFetcher_Initialization_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - Initialization
///
class TextFetcher_Initialization_Tests: XCTestCase {
    
    var textFetcher: TextFetcher!
    
    override func tearDown() {
        super.tearDown()
        textFetcher?.clearCaches()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     private init()
///     public init(withSessionID sessionID: String)
///
extension TextFetcher_Initialization_Tests {
    
    // MARK: - T - Init
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     private init()
    ///
    /// The following behavior is expected:
    /// 1. The Session ID should be set to TextFetcher's defaultID
    /// 2. The textFetcher should be set as its textManager's delegate
    ///
    func test_init() {
        
        // Behavior #1:
            textFetcher = TextFetcher.test_init()
            XCTAssertEqual(textFetcher.test_sessionID, TextFetcher.test_defaultID)
        
        // Behavior #2:
            let textManager = textFetcher.test_textManager as! TextManager
            XCTAssertTrue(textManager.test_delegate === textFetcher)
    }
    
    // MARK: - T - Init with Session ID
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public init(withSessionID sessionID: String)
    ///
    /// The following behavior is expected:
    /// 1. The Session ID should be set to supplied value unless it is equal to the TextFetcher's defaultID
    /// 2. The textFetcher should be set as its textManager's delegate
    ///
    func test_initWithSessionID() {
        
        var textManager: TextManager
        
        // Behavior #1 - 1:
            textFetcher = TextFetcher(withSessionID: "\(Self.self).\(#function)")
            XCTAssertEqual(textFetcher.test_sessionID, "\(Self.self).\(#function)")
        
        // Behavior #2 - 1
            textManager = textFetcher.test_textManager as! TextManager
            XCTAssertTrue(textManager.test_delegate === textFetcher)
            textFetcher.clearCaches()
        
        // Behavior #1 - 2:
            textFetcher = TextFetcher(withSessionID: TextFetcher.test_defaultID)
            XCTAssertNotEqual(textFetcher.test_sessionID, TextFetcher.test_defaultID)
        
        // Behavior #2 - 2
            textManager = textFetcher.test_textManager as! TextManager
            XCTAssertTrue(textManager.test_delegate === textFetcher)
            textFetcher.clearCaches()
    }
}

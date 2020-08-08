///
///  TextFetcher_Notification_Tests.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - Notifications
///
class TextFetcher_Notification_Tests: XCTestCase {
    
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
///     public func addNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
///     public func removeNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
///
extension TextFetcher_Notification_Tests {
    
    // MARK: - T - Add Notification Receiver
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func addNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
    ///
    /// The following behavior is expected:
    /// 1. The supplied object should be added to the notificationReceivers array within the textFetcher's notificationManager
    ///
    func test_addNotificationReceiver() {
        
        textFetcher = .init(withSessionID: "\(Self.self).\(#function)")
        
        // Pre-Behavior:
            XCTAssertEqual(textFetcher.test_notificationManager.test_notificationReceivers.count, 0)
    
        // Behavior #1:
            let testReceiver = TestReceiver()
            textFetcher.addNotificationReceiver(testReceiver)
            
            XCTAssertEqual(textFetcher.test_notificationManager.test_notificationReceivers.count, 1)
            XCTAssertTrue(textFetcher.test_notificationManager.test_notificationReceivers[0].value === testReceiver)
    }
    
    // MARK: - T - Remove Notification Receiver
    ///
    /// TextFetcher Unit Test
    ///
    /// Tests the function:
    ///
    ///     public func removeNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
    ///
    /// The following behavior is expected:
    /// 1. If the object provided is registered within the NotificationManager, it should be unregistered
    ///
    func test_removeNotificationReceiver() {
        
        textFetcher = .init(withSessionID: "\(Self.self).\(#function)")
        
        // Pre-Behavior:
            let testReceiver = TestReceiver()
            textFetcher.addNotificationReceiver(testReceiver)
            
            XCTAssertEqual(textFetcher.test_notificationManager.test_notificationReceivers.count, 1)
            XCTAssertTrue(textFetcher.test_notificationManager.test_notificationReceivers[0].value === testReceiver)
    
        // Behavior #1:
            textFetcher.removeNotificationReceiver(testReceiver)
            XCTAssertEqual(textFetcher.test_notificationManager.test_notificationReceivers.count, 0)
    }
}

// MARK: - Mock Object

extension TextFetcher_Notification_Tests {
    
    class TestReceiver: TextFetcherNotificationReceiver {
        var test_versionIncreaseCount: Int = 0
        var test_versionIncreasedTo: Version?
        var test_textSourceIncreased: TextSource?
        
        func versionIncreased(to version: Version, for textSource: TextSource) {
            test_versionIncreaseCount += 1
            test_versionIncreasedTo = version
            test_textSourceIncreased = textSource
        }
    }
}



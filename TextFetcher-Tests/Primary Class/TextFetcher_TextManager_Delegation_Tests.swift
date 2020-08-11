///
///  TextFetcher_TextManager_Delegation_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcher Unit Tests - TextManager Delegation
///
class TextFetcher_TextManager_Delegation_Tests: XCTestCase {
    
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func versionIncreased(to version: Version, for textSource: TextSource)
///
extension TextFetcher_TextManager_Delegation_Tests {
    
    // MARK: - T - Version Increased To
    ///
    /// Tests the function:
    ///
    ///     func versionIncreased(to version: Version, for textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. When called, the NotificationManager should call notifyReceivers_versionIncreased, passing the given Version and TextSource through to each registered receiver
    ///
    func test_versionIncreased() {
        
        let textFetcher: TextFetcher = .init(withSessionID: "\(Self.self).\(#function)")
        let notificiationReceivers: [Mock_NotificationReceiver] = [.init(), .init(), .init(), .init(), .init()]
        var version: Version
        var textSource: TextSource
        
        for notificiationReceiver in notificiationReceivers {
            textFetcher.addNotificationReceiver(notificiationReceiver)
        }
        
        // Pre-Behavior:
            for notificiationReceiver in notificiationReceivers {
                XCTAssertEqual(notificiationReceiver.mock_versionIncreaseCount, 0)
                XCTAssertNil(notificiationReceiver.mock_version)
                XCTAssertNil(notificiationReceiver.mock_textSource)
            }
        
        // Behavior #1 - 1:
            version = .init(major: 134, minor: 345, patch: 234)
            textSource = .init(identifier: "dgdfg", bundleFile: nil, remoteFile: nil)
            textFetcher.versionIncreased(to: version, for: textSource)

            for notificiationReceiver in notificiationReceivers {
                XCTAssertEqual(notificiationReceiver.mock_versionIncreaseCount, 1)
                XCTAssertEqual(notificiationReceiver.mock_version, version)
                XCTAssertEqual(notificiationReceiver.mock_textSource?.identifier, textSource.identifier)
            }
        
        // Behavior #1 - 2:
            version = .init(major: 4534, minor: 56, patch: 3)
            textSource = .init(identifier: "fghfg", bundleFile: nil, remoteFile: nil)
            textFetcher.versionIncreased(to: version, for: textSource)

            for notificiationReceiver in notificiationReceivers {
                XCTAssertEqual(notificiationReceiver.mock_versionIncreaseCount, 2)
                XCTAssertEqual(notificiationReceiver.mock_version, version)
                XCTAssertEqual(notificiationReceiver.mock_textSource?.identifier, textSource.identifier)
            }
        
        // Behavior #1 - 3:
            version = .init(major: 1, minor: 2, patch: 3)
            textSource = .init(identifier: "g3544", bundleFile: nil, remoteFile: nil)
            textFetcher.versionIncreased(to: version, for: textSource)

            for notificiationReceiver in notificiationReceivers {
                XCTAssertEqual(notificiationReceiver.mock_versionIncreaseCount, 3)
                XCTAssertEqual(notificiationReceiver.mock_version, version)
                XCTAssertEqual(notificiationReceiver.mock_textSource?.identifier, textSource.identifier)
            }
        
    }
}

// MARK: - Mock Classes

extension TextFetcher_TextManager_Delegation_Tests {
    
    class Mock_NotificationReceiver: TextFetcherNotificationReceiver {
        
        var mock_versionIncreaseCount: Int = 0
        var mock_version: Version?
        var mock_textSource: TextSource?
        func versionIncreased(to version: Version, for textSource: TextSource) {
            mock_versionIncreaseCount += 1
            mock_version = version
            mock_textSource = textSource
        }
    }
}


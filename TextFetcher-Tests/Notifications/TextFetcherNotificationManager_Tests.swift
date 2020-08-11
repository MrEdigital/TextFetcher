///
///  TextFetcherNotificationManager_Tests.swift
///  Created on 7/24/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextFetcherNotificationManager Unit Tests
///
class TextFetcherNotificationManager_Tests: XCTestCase {
    var notificationManager: TextFetcherNotificationManager!
}

// MARK: - Tests...
///
/// Covering the following values and functions:
///
///     var notificationReceivers: [TextFetcherNotificationReceiver_WeaklyWrapped]
///     func addReceiver(_ receiver: TextFetcherNotificationReceiver)
///     func removeReceiver(_ receiver: TextFetcherNotificationReceiver)
///     func notifyReceivers_versionIncreased(to version: Version, for textSource: TextSource)
///
extension TextFetcherNotificationManager_Tests {
    
    // MARK: - T - Add Receiver
    ///
    /// Tests the function:
    ///
    ///     func addReceiver(_ receiver: TextFetcherNotificationReceiver)
    ///
    /// The following behavior is expected:
    /// 1. The reciever should be weakly wrapped, and the wrapper inserted into the notificationReceivers array
    /// 2. Any released receivers should have their wrappers purged from the array
    ///
    func test_addReceiver() {
        
        let toRetain: [TestReceiver] = [.init(), .init(), .init(), .init()]
        var toRelease: [TestReceiver] = [.init(), .init(), .init(), .init(), .init(), .init()]
        
        notificationManager = .init()
        
        // Pre Behavior:

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, 0)
        
            for receiver in toRelease {
                notificationManager.addReceiver(receiver)
            }

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRelease.count)
        
        // Behavior #1:
        
            for receiver in toRetain {
                notificationManager.addReceiver(receiver)
            }

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRelease.count + toRetain.count)
        
        // Behavior #2:
        
            toRelease.removeAll()
        
            let additionalReceiver: TestReceiver = .init()
            notificationManager.addReceiver(additionalReceiver)

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRetain.count + 1)
    }
    
    // MARK: - T - Remove Receiver
    ///
    /// Tests the function:
    ///
    ///     func removeReceiver(_ receiver: TextFetcherNotificationReceiver)
    ///
    /// The following behavior is expected:
    /// 1. The wrapper containing the supplied receiver should be removed from the notificationReceivers array
    /// 2. Any released receivers should have their wrappers purged from the array
    ///
    func test_removeReceiver() {
        
        let toRetain: [TestReceiver] = [.init(), .init(), .init(), .init()]
        var toRelease: [TestReceiver] = [.init(), .init(), .init(), .init(), .init(), .init()]
        
        let toRemove: TestReceiver = toRetain[0]
        
        notificationManager = .init()
        
        for receiver in (toRetain + toRelease) {
            notificationManager.addReceiver(receiver)
        }
        
        // Pre Behavior:
        
            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRetain.count + toRelease.count)
            toRelease.removeAll()
        
            notificationManager.removeReceiver(toRemove)
        
        // Behavior #1:
        
            for receiver in notificationManager.test_notificationReceivers {
                XCTAssertFalse(receiver.value === toRemove)
            }
        
        // Behavior #2:

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRetain.count - 1)
    }
    
    // MARK: - T - Notify Receivers - Version Increased
    ///
    /// Tests the function:
    ///
    ///     func notifyReceivers_versionIncreased(to version: Version, for textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. Each object in the notificationReceivers array should have the method versionIncreased(...) called upon them
    /// 2. Any released receivers should have their wrappers purged from the array
    ///
    func test_notifyReceivers_versionIncreased() {
        
        let toRetain: [TestReceiver] = [.init(), .init(), .init(), .init()]
        var toRelease: [TestReceiver] = [.init(), .init(), .init(), .init(), .init(), .init()]
    
        notificationManager = .init()
        
        for receiver in (toRetain + toRelease) {
            notificationManager.addReceiver(receiver)
        }
        
        // Pre Behavior:

            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRetain.count + toRelease.count)
            toRelease.removeAll()
            
            let version: Version = .init(major: 43234, minor: 21319, patch: 223)
            let textSource: TextSource = .init(identifier: "sdgdsg", bundleFile: BundleFile(fileName: "dgdfg", fileExtension: "wefrer"), remoteFile: RemoteFile(urlString: "fgfdfg"))
            notificationManager.notifyReceivers_versionIncreased(to: version, for: textSource)
        
        // Behavior #1:
            for receiver in toRetain {
                XCTAssertEqual(receiver.test_versionIncreaseCount, 1)
                XCTAssertEqual(receiver.test_versionIncreasedTo, version)
                XCTAssertEqual(receiver.test_textSourceIncreased?.identifier, textSource.identifier)
                XCTAssertEqual(receiver.test_textSourceIncreased?.bundleFile?.fileName, textSource.bundleFile?.fileName)
                XCTAssertEqual(receiver.test_textSourceIncreased?.bundleFile?.fileExtension, textSource.bundleFile?.fileExtension)
                XCTAssertEqual(receiver.test_textSourceIncreased?.remoteFile?.urlString, textSource.remoteFile?.urlString)
            }
        
        // Behavior #2:
            XCTAssertEqual(notificationManager.test_notificationReceivers.count, toRetain.count)
    }
}

// MARK: - Mock Object

extension TextFetcherNotificationManager_Tests {
    
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

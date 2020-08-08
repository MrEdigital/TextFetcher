///
///  TextFetcherNotificationManager.swift
///  Created on 7/23/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - NotificationManager
///
/// This class is intended to maintain an array of weak references conforming to the TextFetcherNotificationReceiver protocol
/// for the purpose of receiving versionIncrease broadcasts.  Class objects can be subscribed and unsubscribed at any time.  It is expected
/// that versionIncrease broadcasts will only be made any time a TextSource's version actually increases.
///
class TextFetcherNotificationManager {
    
    private var notificationReceivers: [TextFetcherNotificationReceiver_WeakWrapper] = []
    
    ///
    /// Weakly wraps the provided reciever and adds it to the notificationRecievers array.
    /// Also performs a clear pass on any released weak receivers.
    ///
    /// - parameter receiver: The receiver to be added.
    ///
    func addReceiver(_ receiver: TextFetcherNotificationReceiver) {
        notificationReceivers.purgeEmptyWrappers()
        notificationReceivers.append(.init(value: receiver))
    }
    
    ///
    /// Removes the weak wrapper whose value matches the provided receiver from the notificationRecievers array.
    /// Also performs a clear pass on any released weak receivers.
    ///
    /// - parameter receiver: The receiver to be removed.
    ///
    func removeReceiver(_ receiver: TextFetcherNotificationReceiver) {
        notificationReceivers.removeAll(where: { $0.value === receiver })
        notificationReceivers.purgeEmptyWrappers()
    }
    
    ///
    /// Calls versionIncreased(...) on every registered receiver, passing the provided parameters through to each.
    /// Also performs a clear pass on any released weak receivers.
    ///
    /// - parameter version:    The TextSource's new version'
    /// - parameter textSource: The TextSource whose version increased..
    ///
    func notifyReceivers_versionIncreased(to version: Version, for textSource: TextSource) {
        notificationReceivers.purgeEmptyWrappers()
        notificationReceivers.receivers().forEach {
            $0.versionIncreased(to: version, for: textSource)
        }
    }
}

// MARK: - NotificationReceiver
///
/// A public protocol whose conformance allows any class object to receive TextFetcher notifications by passing a reference into
/// the TextFetcher's addNotificationReceiver(...) method.
///
public protocol TextFetcherNotificationReceiver: class {
    func versionIncreased(to version: Version, for textSource: TextSource)
}

// MARK: - Weak Wrapper
///
/// A simple weak wrapper for the TextFetcherNotificationReceiver class.
///
struct TextFetcherNotificationReceiver_WeakWrapper {
    private(set) weak var value: TextFetcherNotificationReceiver?
    
    ///
    /// - parameter value: The notificationReceiver to be weakly wrapped.
    ///
    fileprivate init(value: TextFetcherNotificationReceiver) {
        self.value = value
    }
}

fileprivate extension Array where Element == TextFetcherNotificationReceiver_WeakWrapper {
    
    ///
    /// Purges any elements whose values have been released.
    ///
    mutating func purgeEmptyWrappers() {
        self = filter{ $0.value != nil }
    }
    
    ///
    /// - returns: All stored / unreleased notification receivers.
    ///
    func receivers() -> [TextFetcherNotificationReceiver] {
        return compactMap({ $0.value })
    }
}

// MARK: - Testing Accessors

#if TESTING

    extension TextFetcherNotificationManager {
        var test_notificationReceivers: [TextFetcherNotificationReceiver_WeakWrapper] { notificationReceivers }
    }

    extension TextFetcherNotificationReceiver_WeakWrapper {
        init(withTestValue testValue: TextFetcherNotificationReceiver) {
            self.init(value: testValue)
        }
    }

    extension Array where Element == TextFetcherNotificationReceiver_WeakWrapper {
        mutating func test_purgeEmptyWrappers() { purgeEmptyWrappers() }
        func test_receivers() -> [TextFetcherNotificationReceiver] { receivers() }
    }

#endif

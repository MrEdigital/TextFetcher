///
///  TextFetcher.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

///
/// This is a convenience protocol which facilitates the parameterization of enum cases or objects which are associated with a TextSource, where a TextSource itself would otherwise be needed.
///
public protocol TextSourceProvider {
    var textSource: TextSource { get }
}

// MARK: - Specification
///
/// This is the primary outward-facing class of the TextFetcher library.  The primary intended use of this library is the retrieval and local caching of bundled or remote text documents.  You can specify a version source, such that only newer versions are retrieved as needed.
///
/// Usage:
///
/// 1. Register any Text Sources you would like fetched and cached via the registerTextSource(_:) method(s).
/// 2. Request Text Sources as needed via the text(for...) method(s), while specifying whether it should allow remote fetching if needed.  If not, it will immediately return the previously cached version or, if none exists, the bundled version instead.
///
/// Optionally:
///
/// 1. (Highly encouraged) Provide a VersionSource to determine which versions are best to fetch and cache, via the setVersionSource(_:) method.
/// 2. Configure the timeout (how long before falling back to bundled or cached versions, if a remote fetch takes too long) via the setTimeout(to:) method.
/// 3. Configure the Application Bunlde to be used for Bundled texts via the setResourceBundle(to:) method.
///
/// - note:  A default instance of this class is provided via the static accessor "default".  This instance should cover nearly every use case, but where separate cache stores are needed a public initializer is provided as well.
///
public class TextFetcher {
    
    /// The primary instance of TextCacheManager.
    public static let `default`: TextFetcher = .init()
    private static let defaultID: String = "Default"
    
    private let textManager: TextManager_TextFetcherInterface
    private let notificationManager: TextFetcherNotificationManager = .init()
    
    // Configuration
    let sessionID: String
        
    ///
    /// A private initializer intended be used only for the static default instance of this class.
    ///
    private init() {
        self.sessionID = TextFetcher.defaultID
        self.textManager = TextManager(withSessionID: sessionID)
        textManager.setDelegate(to: self)
    }
    
    ///
    /// - parameter sessionID: A String used to differentiate between one set of Text Sources and their Versions, and another.
    ///
    public init(withSessionID sessionID: String) {
        self.sessionID = Self.validID(for: sessionID)
        self.textManager = TextManager(withSessionID: sessionID)
        textManager.setDelegate(to: self)
    }
    
    ///
    /// Deletes all cached Version and Text values.
    ///
    public func clearCaches() {
        textManager.clearCaches()
    }

    #if TESTING
        ///
        /// A convenience initializer for testing, exposing polymorphic overrides for the various components this class heavily depends upon, as needed.
        ///
        init(withSessionID sessionID: String, textManager: TextManager_TextFetcherInterface) {
            self.sessionID = Self.validID(for: sessionID)
            self.textManager = textManager
            textManager.setDelegate(to: self)
        }
    #endif
}

// MARK: - Static

extension TextFetcher {
    
    ///
    /// Used to ensure the specified Session ID does not conflict with the Default Session ID.
    /// 
    private static func validID(for sessionID: String) -> String {
        if sessionID == TextFetcher.defaultID {
            return TextFetcher.defaultID + "2"
        }
        return sessionID
    }
}

// MARK: - Configuration

extension TextFetcher {
    
    ///
    /// Sets the App Bundle in which to search for any registered TextSources.
    ///
    /// - parameter bundle: The Bundle reference to be set.
    ///
    public func setResourceBundle(to bundle: Bundle) {
        textManager.setResourceBundle(to: bundle)
    }
    
    ///
    /// When a text is requested, if a fetch is ongoing, this is the duration that will elapse before the last cached (or bundled) text is returned instead.  Defaults to 10 seconds.
    ///
    /// - parameter timeout: The specificed duration to set.
    ///
    public func setResourceTimeout(to timeout: TimeInterval) {
        textManager.setResourceTimeout(to: timeout)
    }
    
    ///
    /// Allows a user to specify a remote/bundled, or purely remote Version Source which should contain a JSON dictionary specifying the versions of any number of Text Sources.
    ///
    /// The expected JSON format is:
    ///
    ///     { "text_source_id": "semantic_version_string", ... }
    ///
    /// - parameter versionSource: An object describing the Version Source you would like to set.
    ///
    public func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil) {
        textManager.setVersionSource(to: versionSource, withCompletion: completion)
    }
}

// MARK: - Notifications

extension TextFetcher {
    
    ///
    /// Adds a given object to a list of notification receivers which receive notification broadcasts relevant to TextFetcher behavior.
    /// See TextFetcherNotificationReceiver for a list of potential notifications.
    ///
    /// - parameter receiver: The receiver to be added.
    ///
    public func addNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver) {
        notificationManager.addReceiver(notificationReceiver)
    }

    ///
    /// Removes the specified object from the list of notification receivers.
    ///
    /// - parameter receiver: The receiver to be removed.
    /// - note: You need not call this prior to deinitialization.  Registered receivers are all weak references.
    ///
    public func removeNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver) {
        notificationManager.removeReceiver(notificationReceiver)
    }
}

// MARK: - Registration

extension TextFetcher {
    
    ///
    /// Allows a user to register a local/remote, purely local, or putely remote Text Source for version-based caching and identifier-based retrieval.
    ///
    /// This is a conveinence call which simply forwards to:
    ///
    ///     func registerTextSource(_ textSource: TextSource)
    ///
    /// - parameter textSourceProvider: Any object containsing a reference describing the Text Source you would like registered.
    ///
    public func registerTextSource(fromProvider textSourceProvider: TextSourceProvider) {
        registerTextSource(textSourceProvider.textSource)
    }
    
    ///
    /// Allows a user to register a local/remote, purely local, or putely remote Text Source for version-based caching and identifier-based retrieval.
    ///
    /// - parameter textSource: An object describing the Text Source you would like registered.
    ///
    public func registerTextSource(_ textSource: TextSource) {
        textManager.registerTextSource(textSource)
    }
}

// MARK: - Retrieval

extension TextFetcher {
    
    ///
    /// Retrieves the latest Text corresponding with the provided TextSource and returns it via closure.  If awaitRemoteFetchIfNeeded is true, and the latest version is found to be remote, the provided completion
    /// will be delayed until a response is received.  Otherwise it will only retrieve from cache, as bundled texts would have already been cached by this point, and should return without any delay.
    ///
    /// - parameter textSourceProvider:       An object containing a TextSource reference.
    /// - parameter awaitRemoteFetchIfNeeded: Determines whether or not a remote (network) fetch is allowed should the latest version of the text be remotely located.
    /// - parameter completion:               A closure to be called upon completion, returning the desired text, or nil, should anything fail along the way.
    ///
    /// - note: Completions called from remote fetch responses still return on the main thread.
    ///
    public func text(for textSourceProvider: TextSourceProvider, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion) {
        text(for: textSourceProvider.textSource.identifier, awaitRemoteFetchIfNeeded: awaitRemoteFetchIfNeeded, completion: completion)
    }
    
    ///
    /// Retrieves the latest Text corresponding with the provided TextSource and returns it via closure.  If awaitRemoteFetchIfNeeded is true, and the latest version is found to be remote, the provided completion
    /// will be delayed until a response is received.  Otherwise it will only retrieve from cache, as bundled texts would have already been cached by this point, and should return without any delay.
    ///
    /// - parameter textSource:               A previously-registered TextSource for which you would like its text returned.
    /// - parameter awaitRemoteFetchIfNeeded: Determines whether or not a remote (network) fetch is allowed should the latest version of the text be remotely located.
    /// - parameter completion:               A closure to be called upon completion, returning the desired text, or nil, should anything fail along the way.
    ///
    /// - note: Completions called from remote fetch responses still return on the main thread.
    ///
    public func text(for textSource: TextSource, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion) {
        text(for: textSource.identifier, awaitRemoteFetchIfNeeded: awaitRemoteFetchIfNeeded, completion: completion)
    }
    
    ///
    /// Retrieves the latest Text corresponding with the provided TextSource and returns it via closure.  If awaitRemoteFetchIfNeeded is true, and the latest version is found to be remote, the provided completion
    /// will be delayed until a response is received.  Otherwise it will only retrieve from cache, as bundled texts would have already been cached by this point, and should return without any delay.
    ///
    /// - parameter resourceID:               The identifier associated with the previously-registered TextSource for which you would like its text returned.
    /// - parameter awaitRemoteFetchIfNeeded: Determines whether or not a remote fetch (ie: over the internet) is allowed should the latest version of the text be remotely located.
    /// - parameter completion:               A closure to be called upon completion, returning the desired text, or nil, should anything fail along the way.
    ///
    /// - note: Completions called from remote fetch responses still return on the main thread.
    ///
    public func text(for resourceID: ResourceID, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion) {
        if awaitRemoteFetchIfNeeded {
            return textManager.latestText(forResource: resourceID, completion: completion)
        }
        textManager.cachedText(forResource: resourceID, completion: completion)
    }
}

// MARK: - Text Manager Delegation

extension TextFetcher: TextManagerDelegate {
    
    ///
    /// Called by an instance of TextManager to inform its delegate that Text for a given TextSource with a given Version has been retrieved and cached.
    ///
    func versionIncreased(to version: Version, for textSource: TextSource) {
        notificationManager.notifyReceivers_versionIncreased(to: version, for: textSource)
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension TextFetcher {
        static var test_defaultID: String { defaultID }
        static func test_init() -> TextFetcher { .init() }
        static func test_validID(for sessionID: String) -> String { validID(for: sessionID) }
        var test_textManager: TextManager_TextFetcherInterface { textManager }
        var test_sessionID: String { sessionID }
        var test_notificationManager: TextFetcherNotificationManager { notificationManager }
    }
#endif

// MARK: - Mocking Necessities

protocol TextManager_TextFetcherInterface {
    func setDelegate(to delegate: TextManagerDelegate?)
    func setResourceBundle(to bundle: Bundle)
    func setResourceTimeout(to timeout: TimeInterval)
    func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)?)
    func registerTextSource(_ textSource: TextSource)
    func cachedText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion)
    func latestText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion)
    func clearCaches()
}

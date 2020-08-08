///
///  TextManager.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

///
/// This protocol is intended to be used by a delegate of the VersionManager class.  Classes conforming to this protocol should expect
/// to be notified when a newer version of a Text Source has been retrieved and cached.
///
protocol TextManagerDelegate: class {
    func versionIncreased(to version: Version, for textSource: TextSource)
}

// MARK: - Specification
///
/// This class is intended to manage registered Text Sources.  Utilizing those Text Sources, it has the ability to load text (Strings) from cache, from the bundle, or remotely,
/// with the help of three respective resource interfacers.  Once loaded, the text can either be returned or cached.  Once cached, it's delegate is informed of a Version Increase.
///
class TextManager: TextManager_TextFetcherInterface {
    
    private weak var delegate: TextManagerDelegate?
    
    // Text Interfacers
    private let cacheInterfacer: CachedResourceInterfacer_TextManagerInterface
    private let remoteInterfacer: RemoteResourceInterfacer_TextManagerInterface
    private let bundleInterfacer: BundledResourceInterfacer_TextManagerInterface
    
    // Source Management
    private var textSources: Set<TextSource> = []
    private let versionManager: VersionManager_TextManagerInterface
    
    // Configuration
    private let sessionID: String
    
    ///
    /// - parameter sessionID: A String used to differentiate between one set of resources and another.
    ///
    init(withSessionID sessionID: String) {
        self.sessionID = sessionID
        self.remoteInterfacer = RemoteResourceInterfacer()
        self.bundleInterfacer = BundledResourceInterfacer()
        self.cacheInterfacer = CachedResourceInterfacer(withSessionID: sessionID)
        self.versionManager = VersionManager(withSessionID: sessionID)
        versionManager.setDelegate(to: self)
    }

    #if TESTING
        ///
        /// A convenience initializer for testing, exposing polymorphic overrides for the various components this class heavily depends upon, as needed.
        ///
        init(withSessionID sessionID: String,
             cacheInterfacer: CachedResourceInterfacer_TextManagerInterface,
             remoteInterfacer: RemoteResourceInterfacer_TextManagerInterface = RemoteResourceInterfacer(),
             bundleInterfacer: BundledResourceInterfacer_TextManagerInterface = BundledResourceInterfacer(),
             versionManager: VersionManager_TextManagerInterface)
        {
            self.sessionID = sessionID
            self.cacheInterfacer = cacheInterfacer
            self.remoteInterfacer = remoteInterfacer
            self.bundleInterfacer = bundleInterfacer
            self.versionManager = versionManager
            versionManager.setDelegate(to: self)
        }
    #endif
}

// MARK: - Configuration

extension TextManager {
    
    ///
    /// Sets a weak reference to be called when any relevant delegation methods are needed.
    ///
    /// - parameter delegate: The object reference to be set.
    ///
    func setDelegate(to delegate: TextManagerDelegate?) {
        self.delegate = delegate
    }
    
    ///
    /// This passes the bundle reference into a bundleInterfacer, which will then utilize it in any subsequent loading requests, as well as the versionManager,
    /// which then passes it into its bundleInterfacer.
    ///
    /// - parameter bundle: The Bundle reference to be set.
    ///
    func setResourceBundle(to bundle: Bundle) {
        bundleInterfacer.setBundle(to: bundle)
        versionManager.setResourceBundle(to: bundle)
    }
    
    ///
    /// When text is requested, if a fetch is ongoing, this is the duration that will elapse before the last cached (or bundled) text is returned instead.
    ///
    /// - parameter timeout: The specificed duration (in seconds) to set.
    ///
    func setResourceTimeout(to timeout: TimeInterval) {
        remoteInterfacer.setResourceTimeout(to: timeout)
    }
    
    ///
    /// This first stores a reference to the provided VersionSource.  It then loads (or reloads) cached version values.  It then loads bundled version values, and notifies
    /// of any newer versions that they may contain, provideing a chance for the delegate to cache the associated resources and call back to this class to then cache
    /// the bundled version value here.  Finally, it fetches any remote version values, before notifying of any newer versions they may contain, the same as before.
    ///
    /// - parameter versionSource: The VersionSource to be used in any Version loading or fetching operations.
    /// - parameter completion:    A closure that will be called when the remote version fetch completes.  Likely only useful in testing.
    ///
    func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil) {
        versionManager.setVersionSource(to: versionSource, withCompletion: completion)
    }
    
    ///
    /// This inserts the textSource into the textSources set, then informs the versionManager that the resource has been registered.  If the versionManager determines
    /// that there is a newer version that has not yet been cached, it should call back via the newerVersionDetected(...) method, so that the newer text can be loaded
    /// and cached for later retrieval.
    ///
    /// - parameter textSource: The TextSource to be stored.
    ///
    func registerTextSource(_ textSource: TextSource) {
        textSources.insert(textSource)
        versionManager.resourceRegistered(forID: textSource.identifier)
        if versionManager.versionSource == nil {
            var locatedVersions: [LocationBoundVersion] = []
            for location in textSource.specifiedLocations + [.cache] {
                locatedVersions.append(.init(version: .zero, location: location))
            }
            newerVersionsLocated(locatedVersions, forResource: textSource.identifier)
        }
    }
}

// MARK: - Loading

extension TextManager {
    
    ///
    /// Retrieves a TextSource with matching identifier and uses it to load and return the corresponding cached text, if any.  Should that fail, nil is returned instead.
    ///
    /// - parameter resourceID: The identifier of the Text Source that had been previously registered.
    /// - parameter completion: A closure that will be called when the load completes or fails.
    ///
    func cachedText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {
        guard let textSource = textSources.first(where: { $0.identifier == resourceID }) else {
            return completion(nil, nil)
        }
        
        loadCachedText(forSource: textSource, withVersion: versionManager.cachedVersion(forResource: resourceID), completion: completion)
    }
    
    ///
    /// Retrieves all known Versions for the given resource, and sorts them (ascending).  It then iterates through them, one at a time, until a text value is retrieved
    /// from one of them, at which point the text and its version are returned via the closure.  If no TextSource is found with the provided Resource ID, or if no text
    /// is retrieved for any of the versions, nil is returned instead.
    ///
    /// - parameter resourceID: The identifier of the Text Source that had been previously registered.
    /// - parameter completion: A closure that will be called when the load completes or fails.
    ///
    /// - note: If the latest version is Remote, this may take some time to return.  To provide a cutoff duration to fall back to cached or bundled text,
    /// set a timeout via the setResourceTimeout(...) method.
    ///
    func latestText(forResource resourceID: ResourceID, completion: @escaping TextRequestCompletion) {
        let versionsByLocation = versionManager.allVersions(ofResource: resourceID).byVersion_descending
        attemptTextLoad(forResource: resourceID, withVersions: versionsByLocation, andCompletion: completion)
    }
    
    ///
    /// Attempts to load / retrieve Text for the provided LocationBoundVersions from their respective locations, starting with the first, and working its way toward the last.
    /// Each subsequent load attempt occurs only after the previous completes and returns nil text.  Should any of them succeed, the text and respective version are returned
    /// through the provided closure.  Should all loads fail, or a registered TextSource with the provided ResourceID not be found, nil will be returned instead.
    ///
    /// - parameter resourceID:      The identifier for the TextSource you would like to load.
    /// - parameter locatedVersions: The Location-Bound Versions which may be loaded, ordered by priority.
    /// - parameter completion:      The closure to be called upon task completion.
    ///
    private func attemptTextLoad(forResource resourceID: ResourceID, withVersions locatedVersions: [LocationBoundVersion], andCompletion completion: @escaping TextRequestCompletion) {
        
        var locatedVersions = locatedVersions
        guard let textSource = textSources.first(where: { $0.identifier == resourceID }),
              let locatedVersion = locatedVersions.first
        else { return completion(nil, nil) } // If no matching text source is found, or we have exhausted all versions, we are done
        locatedVersions.removeFirst()
        
        let completeOrReattempt: TextRequestCompletion = { text, version in
            if let text = text {
                completion(text, version)
            } else {
                self.attemptTextLoad(forResource: resourceID, withVersions: locatedVersions, andCompletion: completion) // Continually calls loadTextIfNeeded, until the latest version is loaded, or all options fail
            }
        }
        
        switch locatedVersion.location {
            case .bundle: self.loadBundledText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
            case .remote: self.loadRemoteText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
            case .cache:  self.loadCachedText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
        }
    }
    
    ///
    /// Retrieves the text corresponding with the provided TextSource (or nil) from the bundle, and returns that value through the provided closure.
    ///
    /// - parameter textSource: The Text Source specifying the identifier with which to load the bundled text.
    /// - parameter completion: A closure that will be called when the load completes or fails.
    ///
    private func loadBundledText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) {
        guard let text = bundleInterfacer.text(forSource: textSource) else { return completion(nil, nil) }
        completion(text, version)
    }
    
    ///
    /// Retrieves the text corresponding with the provided TextSource (or nil) from cache, and returns that value through the provided closure.
    ///
    /// - parameter textSource: The Text Source specifying the identifier with which to load the cached text.
    /// - parameter completion: A closure that will be called when the load completes or fails.
    ///
    private func loadCachedText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) {
        guard let text = cacheInterfacer.cachedText(forSource: textSource) else { return completion(nil, nil) }
        completion(text, version)
    }
    
    ///
    /// Retrieves remote text corresponding with the provided TextSource (or nil) via a remoteInterfacer fetch and returns that value through the provided closure.
    ///
    /// - parameter textSource: The Text Source specifying a Remote URL from which to load the remote text
    /// - parameter completion: A closure that will be called when the remote version fetch completes or fails.
    ///
    private func loadRemoteText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) {
        remoteInterfacer.fetch(fromSource: textSource) { text in
            completion(text, version)
        }
    }
}

// MARK: - Saving

extension TextManager {
    
    ///
    /// This first saves the provided string as a txt file within the local cache directory.  It then informs the versionManager that the resource has been cached so that it can
    /// increase and re-cache its local version value.  Finally, it calls out to the class delegate, informing it of the version increase.
    ///
    /// - parameter text:       The string to be cached
    /// - parameter textSource: The associated TextSource
    /// - parameter version:    The version of the text being cached
    ///
    private func cacheText(_ text: String?, forSource textSource: TextSource, withVersion version: Version?) {
        guard let text = text else { return }
        let version = version ?? .zero
        cacheInterfacer.saveToCache(text, forSource: textSource)
        versionManager.resourceCached(forID: textSource.identifier, withVersion: version)
        delegate?.versionIncreased(to: version, for: textSource)
    }
}

// MARK: - Clearing

extension TextManager {
    
    ///
    /// Deletes the entire session's Cache Directory.
    ///
    func clearCaches() {
        cacheInterfacer.clearCaches()
        versionManager.clearCaches()
    }
}

// MARK: - VersionManager Delegation

extension TextManager: VersionManagerDelegate {
    
    ///
    /// Sorts the Location-Bound Versions by Version (descending), and passes them along with the Resource ID, into attemptTextCacheing(...).
    ///
    /// - parameter locatedVersions: The Location-Bound Versions which may be loaded and cached.
    /// - parameter resourceID:      The ID of the resource whose new version has been found.
    ///
    func newerVersionsLocated(_ locatedVersions: [LocationBoundVersion], forResource resourceID: ResourceID) {
        attemptTextCacheing(forResource: resourceID, withVersions: locatedVersions.byVersion_descending)
    }
    
    ///
    /// Attempts to load / retrieve Text for the provided LocationBoundVersions from their respective locations, starting with the first, and working its way toward the last.
    /// Each subsequent load attempt occurs only after the previous completes and returns nil text.  Should any of them succeed, the text and respective version are then cached.
    /// Should all loads fail, or a registered TextSource with the provided ResourceID not be found, no caching will occur.
    ///
    /// - parameter resourceID:      The identifier for the TextSource you would like to load.
    /// - parameter locatedVersions: The Location-Bound Versions which may be loaded and cached, ordered by priority.
    ///
    private func attemptTextCacheing(forResource resourceID: ResourceID, withVersions locatedVersions: [LocationBoundVersion]) {
        
        var locatedVersions = locatedVersions
        guard let textSource = textSources.first(where: { $0.identifier == resourceID }),
              let locatedVersion = locatedVersions.first
        else { return } // If no matching text source has been registed, or we have exhausted all options, we are done
        locatedVersions.removeFirst()
        
        let completeOrReattempt: TextRequestCompletion = { [weak self] text, version in
            if let text = text {
                self?.cacheText(text, forSource: textSource, withVersion: version)
            } else {
                self?.attemptTextCacheing(forResource: resourceID, withVersions: locatedVersions) // Continually calls attemptTextCache, until the latest version is cached, or all options fail
            }
        }
        
        switch locatedVersion.location {
            case .bundle: self.loadBundledText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
            case .remote: self.loadRemoteText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
            case .cache:  self.loadCachedText(forSource: textSource, withVersion: locatedVersion.version, completion: completeOrReattempt)
        }
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension TextManager {
        var test_sessionID: String { sessionID }
        var test_textSources: Set<TextSource> { textSources }
        var test_cacheInterfacer: CachedResourceInterfacer_TextManagerInterface { cacheInterfacer }
        var test_versionManager: VersionManager? { versionManager as? VersionManager }
        var test_delegate: TextManagerDelegate? { delegate }
        func test_setTextSources(_ textSources: Set<TextSource>) { self.textSources = textSources }
        func test_loadBundledText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) { loadBundledText(forSource: textSource, withVersion: version, completion: completion) }
        func test_loadCachedText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) { loadCachedText(forSource: textSource, withVersion: version, completion: completion) }
        func test_loadRemoteText(forSource textSource: TextSource, withVersion version: Version?, completion: @escaping TextRequestCompletion) { loadRemoteText(forSource: textSource, withVersion: version, completion: completion) }
        func test_cacheText(_ cachedText: String?, forSource textSource: TextSource, withVersion version: Version?) { cacheText(cachedText, forSource: textSource, withVersion: version) }
    }
#endif

// MARK: - Mocking Necessities

protocol VersionManager_TextManagerInterface {
    var versionSource: VersionSource? { get }
    func setDelegate(to delegate: VersionManagerDelegate?)
    func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)?)
    func setResourceBundle(to bundle: Bundle)
    func cachedVersion(forResource resourceID: ResourceID) -> Version
    func allVersions(ofResource resourceID: ResourceID) -> [LocationBoundVersion]
    func resourceRegistered(forID resourceID: ResourceID)
    func clearCaches()
    func resourceCached(forID resourceID: ResourceID, withVersion version: Version)
}

protocol CachedResourceInterfacer_TextManagerInterface {
    func cachedText(forSource textSource: TextSource) -> String?
    func saveToCache(_ text: String, forSource textSource: TextSource)
    func clearCaches()
}

protocol RemoteResourceInterfacer_TextManagerInterface {
    func setResourceTimeout(to timeout: TimeInterval)
    func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion)
}

protocol BundledResourceInterfacer_TextManagerInterface {
    func setBundle(to bundle: Bundle)
    func text(forSource textSource: TextSource) -> String?
}

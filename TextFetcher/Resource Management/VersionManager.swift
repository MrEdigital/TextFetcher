///
///  VersionManager.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

///
/// This protocol is intended to be used by a delegate of the VersionManager class.  Classes conforming to this protocol
/// should expect to be notified when newer versions are detected from a particular location, for a particular resource.
/// At that point, it is expected that the corresponding resource be retrieved and cached if needed, and if so a call to
/// the VersionManager then be made via the resourceCached(...) method.
///
protocol VersionManagerDelegate: class {
    func newerVersionsLocated(_ locatedVersions: [LocationBoundVersion], forResource resourceID: ResourceID)
}

// MARK: - Specification
///
/// This class is intended to load and keep track of versions across 3 potential locations:  The App Bundle, the App
/// Filesystem, and Remote.  It loads Version Stores from each location that is configured within a supplied VersionSource.
/// As each is loaded, they are compared to the Cached versions, and if one is found to be of greater value, the delegate
/// is notified and it is expected that the resource will be retrieved and cached.  At that point, it is also expected that
/// the VersionManager would be notified via the resourceCached(...) method, where the Cached version number would subsequently
/// be incremented.
///
class VersionManager: VersionManager_TextManagerInterface {
    
    private weak var delegate: VersionManagerDelegate?
    
    // Version Interfacers
    private let cacheInterfacer: CachedResourceInterfacer
    private let remoteInterfacer: RemoteResourceInterfacer = .init()
    private let bundleInterfacer: BundledResourceInterfacer = .init()
    
    // Version Stores
    private var locationSplitVersionStore: LocationSplitVersionStore = .init()
    
    // Configuration
    private let sessionID: String
    private(set) var versionSource: VersionSource?
    
    /// - parameter sessionID: A String used to differentiate between one set of resources and another.
    ///
    init(withSessionID sessionID: String) {
        self.sessionID = sessionID
        self.cacheInterfacer = .init(withSessionID: sessionID)
    }
}

// MARK: - Configuration

extension VersionManager {

    ///
    /// Sets a weak reference to be called when any relevant delegation methods are needed.
    ///
    /// - parameter delegate: The object reference to be set.
    ///
    func setDelegate(to delegate: VersionManagerDelegate?) {
        self.delegate = delegate
    }

    ///
    /// This first stores a reference to the provided VersionSource.  It then loads (or reloads) cached version values.
    /// It then loads bundled version values, and notifies of any newer versions they may contain, provideing a chance
    /// for the delegate to cache the associated resources and call back to this class to then cache the bundled version
    /// value here.  Finally, it fetches any remote version values, before notifying of any newer versions they may contain,
    /// the same as before.
    ///
    /// - parameter versionSource: The VersionSource to be used in any Version loading or fetching operations.
    /// - parameter completion:    A closure that will be called when the remote version fetch completes.  Likely only useful in testing.
    ///
    func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil) {
        self.versionSource = versionSource
        loadCachedVersions()
        loadBundleVersions()
        fetchRemoteVersions(withCompletion: completion)
    }

    ///
    /// This passes the bundle reference into a bundleInterfacer, which will then utilize it in any subsequent loading
    /// requests.  It then loads bundled version values, and notifies of any newer versions that they may contain, provideing
    /// a chance for the delegate to cache the associated resources and call back to this class to then cache the bundled
    /// version value here.
    ///
    /// - parameter bundle: The Bundle reference to be set.
    ///
    func setResourceBundle(to bundle: Bundle) {
        bundleInterfacer.setBundle(to: bundle)
        loadBundleVersions()
    }
}

// MARK: - Interface

extension VersionManager {

    ///
    /// This returns the cached Version for a given resource.  If none is found, 0.0.0 is returned instead.
    ///
    /// - parameter resourceID: The Resource ID with which the desired Version is associated.
    ///
    func cachedVersion(forResource resourceID: ResourceID) -> Version {
        return locationSplitVersionStore.version(forResource: resourceID, inLocation: .cache) ?? .zero
    }

    ///
    /// This returns all known Versions for a give resource, along with their associated locations.
    /// For each Version that is not found, a value of 0.0.0 is provided in it's place.
    ///
    /// - parameter resourceID: The Resource ID with which the desired Versions are associated.
    ///
    func allVersions(ofResource resourceID: ResourceID) -> [LocationBoundVersion] {
        return locationSplitVersionStore.allVersions(forResource: resourceID)
    }

    ///
    /// This first updates the current VersionStore's value for the provided resourceID with the provided Version,
    /// and then subsequently caches the current VersionStore.
    ///
    /// - parameter resourceID: The ID corresponding to the resource whose version should now be set and stored.
    /// - parameter version:    The version of resource that had just been cached.
    ///
    func resourceCached(forID resourceID: ResourceID, withVersion version: Version) {
        locationSplitVersionStore.setVersion(version, forResource: resourceID, inLocation: .cache)
        saveCurrentVersions()
    }

    ///
    /// Calls broadcastLatestVersionLocation with the provided resourceID.
    ///
    /// - parameter resourceID: The ID of the resource that had presumably just been registered.
    ///
    func resourceRegistered(forID resourceID: ResourceID) {
        broadcastLatestVersionLocation(forID: resourceID)
    }

    ///
    /// Calls clearCachedVersions() on the cacheInterfacer object, and clears out the cached
    /// VersionStore.
    ///
    func clearCaches() {
        cacheInterfacer.clearCachedVersions()
        locationSplitVersionStore.setVersions(nil, forLocation: .cache)
    }
}

// MARK: - Loading

extension VersionManager {

    ///
    /// Loads all cached version values via the cacheInterface into the current Version Store.
    ///
    private func loadCachedVersions() {
        locationSplitVersionStore.setVersions(cacheInterfacer.cachedVersions(), forLocation: .cache)
    }

    ///
    /// Loads all bundled version values via the bundleInterfacer using the current versionSource into the bundled
    /// Version Store, and then calls broadcastAnyNewerVersions.
    ///
    private func loadBundleVersions() {
        locationSplitVersionStore.setVersions(bundleInterfacer.versions(forSource: versionSource), forLocation: .bundle)
        broadcastAnyNewerVersions()
    }

    ///
    /// Fetches remote version values via the remoteInterface using the current versionSourcer into the remote
    /// Version Store, and then calls broadcastAnyNewerVersions.
    ///
    /// - parameter completion: A closure that will be called when the remote fetch completes.
    ///
    private func fetchRemoteVersions(withCompletion completion: (()->Void)? = nil) {
        remoteInterfacer.fetch(fromSource: versionSource, withCompletion: { [weak self] versions in
            if let versions = versions, versions.count > 0 {
                self?.locationSplitVersionStore.setVersions(versions, forLocation: .remote)
                self?.broadcastAnyNewerVersions()
            }
            completion?()
        })
    }
}

// MARK: - Saving

extension VersionManager {

    ///
    /// Passes the current Version Store to the cacheInterfacer via its saveToCache(...) method.
    ///
    private func saveCurrentVersions() {
        cacheInterfacer.saveToCache(locationSplitVersionStore.versionStoreForLocation(.cache))
    }
}

// MARK: - Broadcasting

extension VersionManager {

    ///
    /// Loops through all resources and their Location Bound Versions in the locationSplitVersionStore.  Excluding stale Versions,
    /// the remainder is evaluated, and if more than one new Version exists, newerVersionsLocated(...) is broadcast to the delegate,
    /// passing through the non stale Versions and their corresponding Resource ID.
    ///
    /// - parameter location: The location from which the supplied version store originates.
    ///
    private func broadcastAnyNewerVersions() {
        locationSplitVersionStore.forEachResource { resourceID, locatedVersions in
            let newerVersions = locatedVersions.removingStaleValues()
            if newerVersions.count > 0 {
                self.delegate?.newerVersionsLocated(newerVersions, forResource: resourceID)
            }
        }
    }

    ///
    /// Retrieves the Location Bound Versions for the given resource, excluding stale Versions.  The remainder is evaluated, and if
    /// more than one new Version exists, newerVersionsLocated(...) is broadcast to the delegate, passing through the non stale
    /// Versions and their corresponding Resource ID.
    ///
    /// - parameter resourceID: The identifier of the corresponding TextSource.
    ///
    private func broadcastLatestVersionLocation(forID resourceID: ResourceID) {
        let latestVersions = locationSplitVersionStore.allVersions(forResource: resourceID).removingStaleValues()
        if latestVersions.count > 0 {
            delegate?.newerVersionsLocated(latestVersions, forResource: resourceID)
        }
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension VersionManager {
        var test_sessionID: String { sessionID }
        var test_delegate: VersionManagerDelegate? { delegate }
        var test_versionSource: VersionSource? { versionSource }
        var test_currentVersions: VersionStore { locationSplitVersionStore.versionStoreForLocation(.cache) }
        var test_bundledVersions: VersionStore { locationSplitVersionStore.versionStoreForLocation(.bundle) }
        var test_remoteVersions: VersionStore { locationSplitVersionStore.versionStoreForLocation(.remote) }
        var test_bundleInterfacer: BundledResourceInterfacer { bundleInterfacer }
        var test_cacheInterfacer: CachedResourceInterfacer { cacheInterfacer }
        func test_setVersion(_ version: Version, forResource resourceID: String, inLocation location: ResourceLocation) { locationSplitVersionStore.setVersion(version, forResource: resourceID, inLocation: location) }
        func test_clearAllCaches() { cacheInterfacer.clearCaches() }
        func test_setCurrentVersions(to versions: VersionStore) { locationSplitVersionStore.setVersions(versions, forLocation: .cache) }
        func test_setBundleVersions(to versions: VersionStore) { locationSplitVersionStore.setVersions(versions, forLocation: .bundle) }
        func test_setRemoteVersions(to versions: VersionStore) { locationSplitVersionStore.setVersions(versions, forLocation: .remote) }
        func test_saveCurrentVersions() { saveCurrentVersions() }
        func test_loadCachedVersions() { loadCachedVersions() }
        func test_loadBundleVersions() { loadBundleVersions() }
        func test_fetchRemoteVersions(withCompletion completion: (()->Void)? = nil) { fetchRemoteVersions(withCompletion: completion) }
        func test_broadcastAnyNewerVersions() { broadcastAnyNewerVersions() }
        func test_broadcastLatestVersionLocation(forID resourceID: String) { broadcastLatestVersionLocation(forID: resourceID) }
    }
#endif

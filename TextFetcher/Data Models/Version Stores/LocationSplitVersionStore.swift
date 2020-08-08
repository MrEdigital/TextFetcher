///
///  LocationSplitVersionStore.swift
///  Created on 7/22/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A struct that maintains three location-specific (.cache, .bundle, .remote) VersionStores.
///
struct LocationSplitVersionStore {
    private var cachedVersions: VersionStore = .init()
    private var remoteVersions: VersionStore = .init()
    private var bundledVersions: VersionStore = .init()
}

// MARK: - Getters

extension LocationSplitVersionStore {

    ///
    /// Returns a set containing the Resource IDs (Strings) of all stored Versions.
    ///
    private var allResourceIDs: Set<ResourceID> {
        var resourceIDs: Set<ResourceID> = .init()
        resourceIDs.formUnion(cachedVersions.allResourceIDs)
        resourceIDs.formUnion(remoteVersions.allResourceIDs)
        resourceIDs.formUnion(bundledVersions.allResourceIDs)
        return resourceIDs
    }
    
}

// MARK: - Setters

extension LocationSplitVersionStore {

    ///
    /// Replaces the registered Version Store for the given Location with the given Version Store.
    ///
    /// - parameter versionStore: The VersionStore you would like set.
    /// - parameter location:     The location with which to associated the given VersionStore.
    ///
    mutating func setVersions(_ versionStore: VersionStore?, forLocation location: ResourceLocation) {
        switch location {
            case .cache:  cachedVersions  = versionStore ?? .init()
            case .bundle: bundledVersions = versionStore ?? .init()
            case .remote: remoteVersions  = versionStore ?? .init()
        }
    }

    ///
    /// Replaces the registered Version for the given ResourceID and Location with the given Version.
    ///
    /// - parameter version:    The Version you would like set.
    /// - parameter resourceID: The ResourceID for which you would like the Version set.
    /// - parameter location:   The ResourceLocation of the resource for which you would like the Version set.
    ///
    mutating func setVersion(_ version: Version, forResource resourceID: ResourceID, inLocation location: ResourceLocation) {
        switch location {
            case .cache:  cachedVersions.setVersion(version, forResource: resourceID)
            case .bundle: bundledVersions.setVersion(version, forResource: resourceID)
            case .remote: remoteVersions.setVersion(version, forResource: resourceID)
        }
    }
}

// MARK: - Interface

extension LocationSplitVersionStore {

    ///
    /// Returns the VersionStore associated with a given ResourceLocation.
    ///
    /// - parameter location: The location associated with the desired VersionStore.
    ///
    func versionStoreForLocation(_ location: ResourceLocation) -> VersionStore {
        switch location {
            case .cache:  return cachedVersions
            case .bundle: return bundledVersions
            case .remote: return remoteVersions
        }
    }

    ///
    /// Returns the registered version for a given ResourceID in a given Location.  If no associated
    /// Version has been registered in that Location, nil will be returned instead.
    ///
    /// - parameter resourceID: The ResourceID associated with a desired Version.
    /// - parameter location:   The ResourceLocation associated with a desired Version.
    ///
    func version(forResource resourceID: ResourceID, inLocation location: ResourceLocation) -> Version? {
        return versionStoreForLocation(location).version(forResource: resourceID)
    }

    ///
    /// Returns an array of LocationBoundVersions for a given Resource ID.  For each Version that is not found,
    /// a value of 0.0.0 is provided in it's place.
    ///
    /// - parameter resourceID: The ResourceID of a associated resource.
    ///
    func allVersions(forResource resourceID: ResourceID) -> [LocationBoundVersion] {
        let locations: [ResourceLocation] = [.cache, .bundle, .remote]
        var latestLocations: [LocationBoundVersion] = []
        
        for location in locations {
            if let version = versionStoreForLocation(location).version(forResource: resourceID) {
                latestLocations.append(.init(version: version, location: location))
            } else {
                latestLocations.append(.init(version: .zero, location: location)) // If there is no version, it shouldn't hurt to include one as a fallback, just in case
            }
        }
        
        return latestLocations
    }

    ///
    /// Fires the provided closure one time for each registered resource, passing both
    /// the ResourceID and all associated Versions for each.
    ///
    /// - parameter forEach:         The closure in which to fire.
    /// - parameter resourceID:      The ResourceID of a given Resource.
    /// - parameter locatedVersions: A collection of all versions associated with a given Resource.
    ///
    func forEachResource(_ forEach: (_ resourceID: ResourceID, _ locatedVersions: [LocationBoundVersion]) -> Void) {
        let allResourceIDs = self.allResourceIDs
        for resourceID in allResourceIDs {
            forEach(resourceID, allVersions(forResource: resourceID))
        }
    }
}

// MARK: - Testing

#if TESTING
extension LocationSplitVersionStore {
    var test_allResourceIDs: Set<ResourceID> { allResourceIDs }
    var test_cachedVersions: VersionStore { cachedVersions }
    var test_remoteVersions: VersionStore { remoteVersions }
    var test_bundledVersions: VersionStore { bundledVersions }
}
#endif

///
///  VersionStore.swift
///  Created on 7/21/20  
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// A simple struct containing a store of Versions keyed by ResourceID (Strings used to identify specific Resources).
///
struct VersionStore {
    
    private var resourceVersions: [ResourceID: Version]
    
    ///
    /// Initializes with Data capable of being decoded as JSON into a [String: String] dictionary.
    /// If no data is provided, or should the decode fail, nil will be returned instead.
    ///
    init?(withData data: Data?) {
        guard let data = data,
              let stringVersions = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            return nil
        }
        
        self.init(withStringVersions: stringVersions)
    }
    
    ///
    /// Initializaes with a [String: String] dictionary.  Internally, the values for each key pair
    /// are mapped to Version objects.  Values which fail to map will not be included in the store.
    ///
    init(withStringVersions stringVersions: [ResourceID: String] = [:]) {
        resourceVersions = stringVersions.compactMapValues({ Version(withString: $0) })
    }
}

// MARK: - Getters

extension VersionStore {
    
    ///
    /// Returns the total number of stored Versions.
    ///
    var count: Int { resourceVersions.count }
    
    ///
    /// Returns a set containing the Resource IDs (Strings) of all stored Versions.
    ///
    var allResourceIDs: Set<ResourceID> { .init(resourceVersions.map({ $0.key })) }
    
    ///
    /// Returns the resulting data for a JSONEncoded representation of this object.
    /// Should the encoding process fail, nil will be returned instead.
    ///
    var jsonEncodedData: Data? {
        let stringVersions = resourceVersions.mapValues({ $0.stringValue })
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(stringVersions)
    }
}

// MARK: - Setters

extension VersionStore {
    
    ///
    /// Replaces the registered Version for the given ResourceID with a given Version.
    ///
    /// - parameter version:    The Version you would like set.
    /// - parameter resourceID: The ResourceID for which you would like to set the given Version..
    ///
    mutating func setVersion(_ version: Version, forResource resourceID: ResourceID) {
        resourceVersions[resourceID] = version
    }
}

// MARK: - Interface

extension VersionStore {
    
    ///
    /// Returns the registered version for the given ResourceID.  If no associated
    /// Version has been registered, nil will be returned instead.
    ///
    /// - parameter resourceID: The ResourceID for a desired Version.
    ///
    func version(forResource resourceID: ResourceID) -> Version? {
        return resourceVersions[resourceID]
    }
    
    ///
    /// Fires the provided closure one time for each registered Version, passing both
    /// the ResourceID and Version for each.
    ///
    /// - parameter forEach: The closure in which to fire.
    /// - parameter locatedVersions: A collection of all versions associated with a given Resource.
    /// - parameter resourceID: The ResourceID of a given Resource.
    ///
    func forEachResource(_ forEach: (_ resourceID: ResourceID, _ version: Version) -> Void) {
        
        for (resourceID, version) in resourceVersions {
            forEach(resourceID, version)
        }
    }
}

// MARK: - Testing

#if TESTING
extension VersionStore {
    init(withVersions versions: [ResourceID: Version]) {
        self.resourceVersions = versions
    }
    var test_resourceVersions: [ResourceID: Version] { return resourceVersions }
    var test_resourceVersionsStringified: [ResourceID: String] { return resourceVersions.mapValues({ $0.stringValue }) }
    var test_allVersions: [Version] { return resourceVersions.map({ $0.value }) }
    mutating func test_setResourceVersions(to resourceVersions: [ResourceID: Version]) { self.resourceVersions = resourceVersions }
}
#endif

///
///  LocationBoundVersion.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A simple struct coupling a Version with a ResourceLocation.
///
struct LocationBoundVersion {
    let version: Version
    let location: ResourceLocation
}

// MARK: - Array Getters

extension Array where Element == LocationBoundVersion {

    ///
    /// Returns all stored Ordered Versions, sorted first by version, then by location distance
    /// from the cache, in ascending order (closest to furthest).
    ///
    var byLocation_ascending: Self {
        sorted(by: { $0.version > $1.version }).sorted(by: { $0.location.rawValue < $1.location.rawValue })
    }

    ///
    /// Returns all stored Ordered Versions, sorted first by version, then by location distance
    /// from the cache, in descending order (furthest to closest).
    ///
    var byLocation_descending: Self {
        byLocation_ascending.reversed()
    }

    ///
    /// Returns all stored Ordered Versions, sorted first by distance from the cache desending
    /// (furthest to closest), then by version, in ascending order (smallest to largest).
    ///
    var byVersion_ascending: Self {
        sorted(by: { $0.location.rawValue > $1.location.rawValue }).sorted(by: { $0.version < $1.version })
    }

    ///
    /// Returns all stored Ordered Versions, sorted first by distance from the cache ascending
    /// (closest to furthest), then by version, in descending order (largest to smallest).
    ///
    var byVersion_descending: Self {
        byVersion_ascending.reversed()
    }

    ///
    /// Returns a new instance, with any values less than or equal to the cached value removed.
    ///
    /// - note: Must include a cache-located version, otherwise this simply returns it's self.
    ///
    func removingStaleValues() -> Self {
        guard let cachedValue = first(where: { $0.location == .cache }) else { return self }
        return filter({ $0.version > cachedValue.version })
    }
}

///
///  Version.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A simple struct meant to represent a semantic version (see: https://semver.org ), containing a single unsigned Int each for major, minor, and patch versions.
/// It can be initialized with values for each, or with a String (failing to a value of .zero).  It can return a String representation via stringValue, and is equatable.
///
public struct Version: Equatable {
    
    public let major: UInt
    public let minor: UInt
    public let patch: UInt
    
    public static let zero: Version = .init(major: 0, minor: 0, patch: 0)

    ///
    /// - parameters:
    ///     - major: The major version number.
    ///     - minor: The minor version number.
    ///     - patch: The patch number.
    ///
    public init(major: UInt, minor: UInt, patch: UInt) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    ///
    /// - parameter string: A string matching the Semantic Versioning format of "Major.Minor.Patch".  (ex: "0.5.12")
    /// - returns: A valid Version object, containing either the String's specified values or, should the pattern not be met, Version.zero.
    ///
    public init?(withString string: String) {
        let components: [String.SubSequence] = string.split(separator: ".")
        guard components.count == 3,
              let major = UInt(components[0]),
              let minor = UInt(components[1]),
              let patch = UInt(components[2])
        else {
            return nil
        }
        
        self.init(major: major, minor: minor, patch: patch)
    }
}

// MARK: - Alt Values

extension Version {

    ///
    /// - returns: A String representation of the Value.  (ex: "1.2.3")
    ///
    public var stringValue: String {
        return "\(major).\(minor).\(patch)"
    }
}

// MARK: - Equality / Comparitors

public extension Version {
    
    static func ==(_ lhs: Version, _ rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
    
    static func !=(_ lhs: Version, _ rhs: Version) -> Bool {
        return !(lhs == rhs)
    }
    
    static func >=(_ lhs: Version, _ rhs: Version) -> Bool {
        return lhs > rhs || lhs == rhs
    }
    
    static func >(_ lhs: Version, _ rhs: Version) -> Bool {
        return (lhs.major > rhs.major) ||
               (lhs.major == rhs.major && lhs.minor > rhs.minor) ||
               (lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch > rhs.patch)
    }
    
    static func <(_ lhs: Version, _ rhs: Version) -> Bool {
        return rhs > lhs
    }
    
    static func <=(_ lhs: Version, _ rhs: Version) -> Bool {
        return rhs > lhs || lhs == rhs
    }
}

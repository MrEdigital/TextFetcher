///
///  TextSource.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A struct that is used to locate and retrieve remote and bundled Text, keyed with an identifier.
///
public struct TextSource: Hashable {
    
    public let identifier: String
    let bundleFile: BundleFile?
    let remoteFile: RemoteFile?
    
    public init(identifier: ResourceID, bundleFile: BundleFile?, remoteFile: RemoteFile?) {
        self.identifier = identifier
        self.bundleFile = bundleFile
        self.remoteFile = remoteFile
    }
}

extension TextSource {
    
    ///
    /// Returns an array indicating which locations have been specified. (ie: Bundle, Remote, Both, or None)
    ///
    var specifiedLocations: [ResourceLocation] {
        var specifiedLocations: [ResourceLocation] = []
        if remoteFile != nil { specifiedLocations.append(.remote) }
        if bundleFile != nil { specifiedLocations.append(.bundle) }
        return specifiedLocations
    }
}


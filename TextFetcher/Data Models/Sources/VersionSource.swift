///
///  VersionSource.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A struct that is used to locate and retrieve remote and bundled Version Stores.
///
public struct VersionSource {
    let bundleFile: BundleFile?
    let remoteFile: RemoteFile
    
    public init(bundleFile: BundleFile? = nil, remoteFile: RemoteFile) {
        self.bundleFile = bundleFile
        self.remoteFile = remoteFile
    }
}

///
///  BundleFile.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A struct containing values necessary to locate and retrieve a remote file.
///
public struct RemoteFile: Hashable {
    let urlString: String
    
    public init(urlString: String) {
        self.urlString = urlString.replacingOccurrences(of: " ", with: "%20")
    }
}

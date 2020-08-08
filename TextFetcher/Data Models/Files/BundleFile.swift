///
///  BundleFile.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

// MARK: - Specification
///
/// A struct containing values necessary to locate and retrieve a file from within an Application Bundle.
///
public struct BundleFile: Hashable {
    let fileName: String
    let fileExtension: String
    
    public init(fileName: String, fileExtension: String) {
        self.fileName = fileName
        self.fileExtension = fileExtension
    }
}

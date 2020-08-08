///
///  BundledResourceManager.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// A class intended to provide easy loading of Version and Text files from within a specifieds Bundle.
///
class BundledResourceInterfacer: BundledResourceInterfacer_TextManagerInterface {
    private var bundle: Bundle = .main
}

// MARK: - Configuration

extension BundledResourceInterfacer {
    
    ///
    /// Sets the local bundle reference to the supplied reference value.
    ///
    /// - parameter bundle: The Bundle reference to be set.
    ///
    func setBundle(to bundle: Bundle) {
        self.bundle = bundle
    }
}

// MARK: - Retrieval

extension BundledResourceInterfacer {
    
    ///
    /// Searches the Bundle for a resource matching the versionSource.bundleFile values, decodes it into a [String: String] dictionary,
    /// maps it to [String: Version] and returns the result, or nil, should any of that fail.
    ///
    /// - parameter versionSource: The VersionSource specifying bundle details needed to locate and load the bundled versions.
    /// - returns: The loaded, decoded, mapped version values, or nil, should they fail to load or decode.
    ///
    func versions(forSource versionSource: VersionSource?) -> VersionStore? {
        guard let versionSource = versionSource else { return nil }
        
        if let bundleFile = versionSource.bundleFile,
           let path = bundle.path(forResource: bundleFile.fileName, ofType: bundleFile.fileExtension),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        {
            return VersionStore(withData: data)
        }

        return nil
    }
    
    ///
    /// Searches the Bundle for a resource matching the textSource.bundleFile values, loads its String value, and returns the result, or nil,
    /// should any of that fail.
    ///
    /// - parameter textSource: The TextSource specifying bundle details needed to locate and load the bundled text.
    /// - returns: The loaded, decoded text, or nil, should it fail to load or decode. 
    ///
    func text(forSource textSource: TextSource) -> String? {
        
        if let bundleFile = textSource.bundleFile,
           let path = bundle.path(forResource: bundleFile.fileName, ofType: bundleFile.fileExtension),
           let text = try? String(contentsOf: URL(fileURLWithPath: path))
        {
            return text
        }
        
        return nil
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension BundledResourceInterfacer {
        var test_bundle: Bundle { return bundle }
    }
#endif

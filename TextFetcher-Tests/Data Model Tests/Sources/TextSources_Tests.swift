///
///  TextSources_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// TextSources Unit Tests
///
class TextSources_Tests: XCTestCase {}

// MARK: - Tests...
///
/// Covering the following variables:
///
///     var specifiedLocations: [ResourceLocation]
///
extension TextSources_Tests {
    
    // MARK: - T - Specified Locations
    ///
    /// Version Unit Test
    ///
    /// Tests the variable:
    ///
    ///      var specifiedLocations: [ResourceLocation]
    ///
    /// The following value is expected:
    /// 1. If remoteFile and bundleFile are both nil, the resulting array should be empty.
    /// 2. If remoteFile is not nil, .remote should be included in the resulting array.
    /// 3. If bundleFile is not nil, .bundle should be included in the resulting array.
    /// 4. If neither are nil, the resulting array should contain both.
    ///
    func test_specifiedLocations() {
        
        var textSource: TextSource
          
        // Behavior #1:
            textSource = .init(identifier: "", bundleFile: nil, remoteFile: nil)
            XCTAssertTrue(textSource.specifiedLocations.isEmpty)
        
        // Behavior #2:
            textSource = .init(identifier: "", bundleFile: .init(fileName: "", fileExtension: ""), remoteFile: nil)
            XCTAssertEqual(textSource.specifiedLocations.count, 1)
            XCTAssertTrue(textSource.specifiedLocations.contains(.bundle))
            
        // Behavior #3:
            textSource = .init(identifier: "", bundleFile: nil, remoteFile: .init(urlString: ""))
            XCTAssertEqual(textSource.specifiedLocations.count, 1)
            XCTAssertTrue(textSource.specifiedLocations.contains(.remote))
                
        // Behavior #4:
            textSource = .init(identifier: "", bundleFile: .init(fileName: "", fileExtension: ""), remoteFile: .init(urlString: ""))
            XCTAssertEqual(textSource.specifiedLocations.count, 2)
            XCTAssertTrue(textSource.specifiedLocations.contains(.bundle))
            XCTAssertTrue(textSource.specifiedLocations.contains(.remote))
        
    }
}



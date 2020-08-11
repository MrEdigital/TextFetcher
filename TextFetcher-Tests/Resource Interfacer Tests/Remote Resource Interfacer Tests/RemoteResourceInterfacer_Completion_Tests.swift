///
///  RemoteResourceInterfacer_Completion_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// RemoteResourceInterfacer Unit Tests - Completion
///
class RemoteResourceInterfacer_Completion_Tests: XCTestCase {
    
    var interfacer: RemoteResourceInterfacer!
    
    override func setUp() {
        super.setUp()
        
        interfacer = .init()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}

// MARK: - Tests...
///
/// Covers the following functions:
///
///     private func registerCompletion(_ completion: @escaping TextFetchCompletion, for textSource: TextSource)
///     private func clearCompletions(for textSource: TextSource)
///     private func registeredCompletions(for textSource: TextSource) -> [TextFetchCompletion]
///     private func fireCompletions(for textSource: TextSource, with text: String?)
///
extension RemoteResourceInterfacer_Completion_Tests {

    // MARK: - T - Register Completions
    ///
    /// Tests the function:
    ///
    ///     private func registerCompletion(_ completion: @escaping TextFetchCompletion, for textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. The provided completion will be wrapped in an array and set into the fetchCompletions dictionary using the provided TextSource's identifier as a key.
    /// 2. If an array in that position already exists, it will be appended to it instead.
    ///
    func test_registerCompletion() {
        let textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: nil)
        var completions: [TextFetchCompletion]?
        
        // Pre Behavior:
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNil(completions)
        
        // Behavior #1:
            interfacer.test_registerCompletion({_ in }, for: textSource)
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNotNil(completions)
            XCTAssertEqual(completions!.count, 1)
        
        // Behavior #2:
            interfacer.test_registerCompletion({_ in }, for: textSource)
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNotNil(completions)
            XCTAssertEqual(completions!.count, 2)
    }
    
    // MARK: - T - Clear Completions
    ///
    /// Tests the function:
    ///
    ///     private func clearCompletions(for textSource: TextSource)
    ///
    /// The following behavior is expected:
    /// 1. Using the provided TextSource's identifier as a key, the corresponding value is removed from the fetchCompletions dictionary.
    ///
    func test_clearCompletions() {
        
        let textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: nil)
        var completions: [TextFetchCompletion]?
        
        // Pre Behavior:
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNil(completions)
        
            interfacer.test_clearCompletions(for: textSource) // Should Do Nothing
            XCTAssertNil(completions)
        
        // Behavior #1:
            interfacer.test_registerCompletion({_ in }, for: textSource)
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNotNil(completions)
            XCTAssertEqual(completions!.count, 1)
        
            interfacer.test_clearCompletions(for: textSource)
            completions = interfacer.test_fetchCompletions[textSource.identifier]
            XCTAssertNil(completions)
    }
    
    // MARK: - T - Registered Completions
    ///
    /// Tests the function:
    ///
    ///     private func registeredCompletions(for textSource: TextSource) -> [TextFetchCompletion]
    ///
    /// The following behavior is expected:
    /// 1. Should return an array containing any closures that have been registered to the fetchCompletions dictionary using the provided TextSource's identifier as a key.
    ///
    func test_registeredCompletions() {
        
        let textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: nil)
        var completions: [TextFetchCompletion]
        
        // Pre Behavior:
            completions = interfacer.test_registeredCompletions(for: textSource)
            XCTAssertEqual(completions.count, 0)
        
        // Behavior #1 - 1:
            interfacer.test_registerCompletion({_ in }, for: textSource)
            completions = interfacer.test_registeredCompletions(for: textSource)
            XCTAssertEqual(completions.count, 1)
        
        // Behavior #1 - 2:
            interfacer.test_registerCompletion({_ in }, for: textSource)
            completions = interfacer.test_registeredCompletions(for: textSource)
            XCTAssertEqual(completions.count, 2)
    }
    
    // MARK: - T - Fire Completions
    ///
    /// Tests the function:
    ///
    ///     private func fireCompletions(for textSource: TextSource, with text: String?)
    ///
    /// The following behavior is expected:
    /// 1. Closures are pulled from the fetchCompletions dictionary using the provided TextSource's identifier as a key.
    /// 2. Each closure is called with the provided string value passed in.
    ///
    func test_fireCompletions() {
        
        let textSourceA = TextSource(identifier: "abc", bundleFile: nil, remoteFile: nil)
        let textSourceB = TextSource(identifier: "def", bundleFile: nil, remoteFile: nil)
        
        let stringsToPass: [String] = ["asdfsf", "sdfdsf"]
        var passedStrings: [String] = []
        
        // Setup
        
            for _ in 1 ... 3 {
                interfacer.test_registerCompletion({ string in
                    passedStrings.append(string ?? "")
                }, for: textSourceA)
            }
            
            for _ in 1 ... 3 {
                interfacer.test_registerCompletion({ string in
                    passedStrings.append(string ?? "")
                }, for: textSourceB)
            }
        
        // Behavior #1 - 1:
        
            interfacer.test_fireCompletions(for: textSourceA, with: stringsToPass[0])
        
            XCTAssertNil(interfacer.test_fetchCompletions[textSourceA.identifier])
            XCTAssertEqual(passedStrings.count, 3)
        
            for passedString in passedStrings {
                XCTAssertEqual(passedString, stringsToPass[0])
            }
        
        // Behavior #1 - 1:
        
            passedStrings.removeAll()
            interfacer.test_fireCompletions(for: textSourceB, with: stringsToPass[0])
        
            XCTAssertNil(interfacer.test_fetchCompletions[textSourceB.identifier])
            XCTAssertEqual(passedStrings.count, 3)
        
            for passedString in passedStrings {
                XCTAssertEqual(passedString, stringsToPass[0])
            }
    }
}

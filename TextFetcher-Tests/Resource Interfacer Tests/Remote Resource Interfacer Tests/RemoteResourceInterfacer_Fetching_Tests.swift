///
///  RemoteResourceInterfacer_Fetching_Tests.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import XCTest
import OHHTTPStubs
@testable import TextFetcher

// MARK: - Setup / Cleanup...
///
/// RemoteResourceInterfacer Unit Tests - Fetching
///
class RemoteResourceInterfacer_Fetching_Tests: XCTestCase {
    
    var interfacer: RemoteResourceInterfacer!
    
    override func setUp() {
        super.setUp()
        
        interfacer = .init()
        
        // Stub for Versions
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.s), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.s.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        })
        
        // Stub for Versions - Slow
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Versions.m), response: { _ in
            let stringifiedVersions = TestingResources.BundleFileContents.Versions.m.test_resourceVersionsStringified
            guard let data = try? JSONEncoder().encode(stringifiedVersions) else {
                return HTTPStubsResponse()
            }
            let response = HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
            response.responseTime = 1 // Delays 1 second
            return response
        })

        // Stub for Texts
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Texts.s), response: { _ in
            let text: String = TestingResources.BundleFileContents.Texts.s
            guard let data = text.data(using: .utf8) else {
                return HTTPStubsResponse()
            }
            return HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        })

        // Stub for Texts - Slow
        stub(condition: isHost(TestingResources.Endpoints.serverAddress) && isPath(TestingResources.Endpoints.Texts.m), response: { _ in
            let text: String = TestingResources.BundleFileContents.Texts.m
            guard let data = text.data(using: .utf8) else {
                return HTTPStubsResponse()
            }
            let response = HTTPStubsResponse(data: data, statusCode: 200, headers: nil)
            response.responseTime = 1 // Delays 1 second
            return response
        })
    }
    
    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }
}

// MARK: - Tests...
///
/// Covering the following functions:
///
///     func fetch(fromSource versionSource: VersionSource?, withCompletion completion: @escaping VersionFetchCompletion)
///     func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion)
///
extension RemoteResourceInterfacer_Fetching_Tests {
    
    // MARK: T - Fetch From Version Source
    ///
    /// RemoteResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func fetch(fromSource versionSource: VersionSource?, withCompletion completion: @escaping VersionFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If an invalid URL, or nil VersionSource, is passed within the TextSource it should complete with nil immediately.
    /// 2. If a resourse is found, it should be decoded and mapped, and returned through the closure on the main thread.
    /// 3. If it is not found, or cannot decode / map, it should return nil on the main thread.
    /// 4. If additional calls are made before the fetch returns, prior requests are invalidated and cancelled, completing with nil.
    ///
    func test_fetchFromVersionSource() {
        var urlString: String
        var versionSource: VersionSource
        var exp: XCTestExpectation
        
        // Behavior #1 - 1:

            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: nil) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(versions)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #1 - 2:

            versionSource = VersionSource(bundleFile: nil, remoteFile: RemoteFile(urlString: ""))
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(versions)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
            
        // Behavior #2:
        
            urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.s
            versionSource = VersionSource(bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNotNil(versions)
                XCTAssertEqual(versions?.test_resourceVersions, TestingResources.BundleFileContents.Versions.s.test_resourceVersions)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
                
        // Behavior #3:
        
            urlString = "https://" + TestingResources.Endpoints.serverAddress + "/sfdsf/sdfsfgf.jspn"
            versionSource = VersionSource(bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(versions)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
            
        // Behavior #4:
        
            urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Versions.m
            versionSource = VersionSource(bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            
            let exp1 = expectation(description: "Waiting on (Stubbed) Remote Fetch 1")
            let exp2 = expectation(description: "Waiting on (Stubbed) Remote Fetch 2")
            let exp3 = expectation(description: "Waiting on (Stubbed) Remote Fetch 3")
        
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(versions)
                exp1.fulfill()
            }
            
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(versions)
                exp2.fulfill()
            }
            
            interfacer.fetch(fromSource: versionSource) { versions in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNotNil(versions)
                XCTAssertEqual(versions?.test_resourceVersions, TestingResources.BundleFileContents.Versions.m.test_resourceVersions)
                exp3.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
    }
    
    // MARK: - T - Fetch From Text Source
    ///
    /// RemoteResourceInterfacer Unit Test
    ///
    /// Tests the function:
    ///
    ///     func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion)
    ///
    /// The following behavior is expected:
    /// 1. If an invalid URL or nil RemoteFile is passed within the TextSource it should complete with nil immediately.
    /// 2. If a resourse is found, it should be decoded and returned through the closure on the main thread.
    /// 3. If it is not found, or cannot decode, it should return nil on the main thread.
    /// 4. If additional calls are made before the fetch returns, they should be queued, they should not trigger additional fetches, and should all be fired upon return.
    /// 5. If the ResourceInterfacer is released before the fetch returns, registered completions will not (can not) be called, but the original completion will be.
    ///
    func test_fetchFromTextSource() {
        
        var urlString: String
        var textSource: TextSource
        var exp: XCTestExpectation
        
        // Behavior #1:

            textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: nil)
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(text)
                exp.fulfill()
            }
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
        
        // Behavior #2:
        
            urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Texts.s
            textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(text, TestingResources.BundleFileContents.Texts.s)
                exp.fulfill()
            }
            
            XCTAssertEqual(interfacer.test_fetchCompletions[textSource.identifier]?.count, 1)
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
            
            XCTAssertNil(interfacer.test_fetchCompletions[textSource.identifier])
            
        // Behavior #3:

            urlString = "https://" + TestingResources.Endpoints.serverAddress + "/sfdsf/sdfsfgf.txt"
            textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertNil(text)
                exp.fulfill()
            }
            
            XCTAssertEqual(interfacer.test_fetchCompletions[textSource.identifier]?.count, 1)
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
            
            XCTAssertNil(interfacer.test_fetchCompletions[textSource.identifier])
            
        // Behavior #4:

            urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Texts.m
            textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            
            let exp1 = expectation(description: "Waiting on (Stubbed) Remote Fetch 1")
            let exp2 = expectation(description: "Waiting on (Stubbed) Remote Fetch 2")
            let exp3 = expectation(description: "Waiting on (Stubbed) Remote Fetch 3")
        
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(text, TestingResources.BundleFileContents.Texts.m)
                exp1.fulfill()
            }
        
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(text, TestingResources.BundleFileContents.Texts.m)
                exp2.fulfill()
            }
        
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(text, TestingResources.BundleFileContents.Texts.m)
                exp3.fulfill()
            }
        
            XCTAssertEqual(interfacer.test_fetchCompletions[textSource.identifier]?.count, 3)
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
            
            XCTAssertNil(interfacer.test_fetchCompletions[textSource.identifier])
            
        // Behavior #5:

            urlString = "https://" + TestingResources.Endpoints.serverAddress + TestingResources.Endpoints.Texts.m
            textSource = TextSource(identifier: "abc", bundleFile: nil, remoteFile: RemoteFile(urlString: urlString))
            
            exp = expectation(description: "Waiting on (Stubbed) Remote Fetch")
            interfacer.fetch(fromSource: textSource) { text in
                XCTAssertTrue(Thread.isMainThread)
                XCTAssertEqual(text, TestingResources.BundleFileContents.Texts.m)
                XCTAssertNil(self.interfacer)
                exp.fulfill()
            }
        
            interfacer = nil
            
            waitForExpectations(timeout: 5) { error in
                XCTAssertNil(error)
            }
    }
}

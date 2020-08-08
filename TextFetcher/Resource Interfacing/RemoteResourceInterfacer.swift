///
///  RemoteResourceInterfacer.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// A class intended to provide easy loading of Version and Text files over the internet.
///
class RemoteResourceInterfacer: RemoteResourceInterfacer_TextManagerInterface {
    
    private var versionFetchingUrlSession = URLSession(configuration: .default)
    private var fetchCompletions: [String: [TextFetchCompletion]] = [:]
    private var timeout: TimeInterval = 10
}

// MARK: - Configuration

extension RemoteResourceInterfacer {
    
    ///
    /// When text is requested, if a fetch is ongoing, this is the duration that will elapse before completing with a value of nil.
    ///
    /// - parameter timeout: The specificed duration to set.
    ///
    func setResourceTimeout(to timeout: TimeInterval) {
        self.timeout = timeout
    }
}

// MARK: - Fetching

extension RemoteResourceInterfacer {
    
    ///
    /// Retrieves the remoteFile URL from the VersionSource, invalidates and cancels any prior requests, then forms a new request with that url.
    /// On response, it will decode and map the data into [String: Version] form and return the result, or nil, should any of that fail.
    ///
    /// - parameter versionSource: The VersionSource used to specify the RemoteFile's URL.
    /// - parameter completion:    The closure used to return the decoded Versions, or nil, should anything fail, or timeout.
    ///
    /// - note: Returns on the main thread.
    ///
    func fetch(fromSource versionSource: VersionSource?, withCompletion completion: @escaping VersionFetchCompletion) {
        
        guard let url = URL(string: versionSource?.remoteFile.urlString ?? "") else {
            return completion(nil)
        }
        
        versionFetchingUrlSession.invalidateAndCancel()
        versionFetchingUrlSession = URLSession(configuration: .default)
        
        versionFetchingUrlSession.dataTask(with: url) { data, response, error in
            
            let versions: VersionStore? = {
                return VersionStore(withData: data)
            }()
            
            DispatchQueue.main.async {
                completion(versions)
            }
        }.resume()
    }
    
    ///
    /// Retrieves the remoteFile URL from the TextSource, and registers the completion closure to be called upon completion.  If there was already
    /// at least 1 closure registered, the function immediately returns at this point.  If this was the first closure registered, however, a URLSession
    /// is created and used to form a new request with the given url.  On response, it will decode the data as UTF-8 into a String value and return
    /// the result, or nil, should any of that fail.
    ///
    /// - parameter textSource: The TextSource used to specify the RemoteFile's URL.
    /// - parameter completion: The closure used to return the decoded text, or nil, should anything fail, or timeout.
    ///
    /// - note: Returns on the main thread.
    ///
    func fetch(fromSource textSource: TextSource, withCompletion completion: @escaping TextFetchCompletion) {
        
        guard let url = URL(string: textSource.remoteFile?.urlString ?? "") else {
            return completion(nil)
        }
        
        registerCompletion(completion, for: textSource)
        guard registeredCompletions(for: textSource).count == 1 else {
            return
        }
        
        let urlSessionConfig: URLSessionConfiguration = .default
        urlSessionConfig.timeoutIntervalForResource = timeout
        let urlSession = URLSession(configuration: urlSessionConfig)
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            
            let text: String? = {
                if let data = data {
                    return String(data: data, encoding: .utf8)
                }
                return nil
            }()
            
            DispatchQueue.main.async {
                guard let self = self else { return completion(text) }
                self.fireCompletions(for: textSource, with: text)
            }
        }.resume()
    }
}

// MARK: - Completion

extension RemoteResourceInterfacer {
    
    ///
    /// Inserts the provided completion into the fetchCompletions store using the provided TextSource's identifier as a key.
    ///
    /// - parameter completion: The closure to be registered / stored.
    /// - parameter textSource: The TextSource whose identifier is used for storing and retrieving the closure.
    ///
    private func registerCompletion(_ completion: @escaping TextFetchCompletion, for textSource: TextSource) {
        fetchCompletions[textSource.identifier] = registeredCompletions(for: textSource) + [completion]
    }
    
    ///
    /// Removes all closures from the fetchCompletions store for the given TextSource.
    ///
    /// - parameter textSource: The TextSource whose identifier is used to locate and clear any registered closures.
    ///
    private func clearCompletions(for textSource: TextSource) {
        fetchCompletions.removeValue(forKey: textSource.identifier)
    }
    
    ///
    /// Returns all closures from the fetchCompletions store for the given TextSource.
    ///
    /// - parameter textSource: The TextSource whose identifier is used to retrieve and return any registered closures.
    /// - returns: Any registered closures for the given TextSource.
    ///
    private func registeredCompletions(for textSource: TextSource) -> [TextFetchCompletion] {
        return fetchCompletions[textSource.identifier] ?? []
    }
    
    ///
    /// Calls and removes each closure from the fetchCompletions store for the given TextSource, with the given text.
    ///
    /// - parameter textSource: The TextSource whose identifier is used to retrieve and call any registered closures.
    /// - parameter text:       The String value to be passed into each closure as it is called.
    ///
    private func fireCompletions(for textSource: TextSource, with text: String?) {
        var completions = registeredCompletions(for: textSource)
        clearCompletions(for: textSource)
        
        while let completion = completions.popLast() {
            completion(text)
        }
    }
}

// MARK: - Testing Accessors

#if TESTING
    extension RemoteResourceInterfacer {
        var test_timeout: TimeInterval { timeout }
        var test_fetchCompletions: [String: [TextFetchCompletion]] { fetchCompletions }
        func test_registerCompletion(_ completion: @escaping TextFetchCompletion, for textSource: TextSource) { registerCompletion(completion, for: textSource) }
        func test_clearCompletions(for textSource: TextSource) { clearCompletions(for: textSource) }
        func test_registeredCompletions(for textSource: TextSource) -> [TextFetchCompletion] { registeredCompletions(for: textSource) }
        func test_fireCompletions(for textSource: TextSource, with cachedText: String?) { fireCompletions(for: textSource, with: cachedText) }
    }
#endif

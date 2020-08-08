///
///  ResourceInterfacing.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///


///
/// A completion block intended to be called when a Version fetch operation has completed
///
/// - parameter versions: The resulting version store or nil, should anything go wrong
///
typealias VersionFetchCompletion = (_ versions: VersionStore?) -> Void

///
/// A completion block intended to be called when a Text request operation has completed
///
/// - parameter text:    The resulting text or nil, should anything go wrong
/// - parameter version: The version associated with the text
///
public typealias TextRequestCompletion = (_ text: String?, _ version: Version?) -> Void

///
/// A completion block intended to be called when an internal Text fetch operation has completed
///
/// - parameter text: The resulting text or nil, should anything go wrong
///
typealias TextFetchCompletion = (_ text: String?) -> Void

///
///  Resources.swift
///  Created on 7/22/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Foundation

// MARK: - Specification
///
/// The location of a Resource.  The rawVersion represents its distance from the Cache.
/// The cache is null distance from itself, so its value is -1.  The bundle is adjascent,
/// so its value is 0, and remote sources are set to 1.  These values are intended to be used
/// for sorting by distance, ascending or descending.
///
enum ResourceLocation: Int {
    case cache = -1
    case bundle = 0
    case remote = 1
}

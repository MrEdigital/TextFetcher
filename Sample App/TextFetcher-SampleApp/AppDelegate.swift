///
///  AppDelegate.swift
///  Created on 7/25/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

import Cocoa
import SwiftUI
import TextFetcher

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    override init() {
        super.init()
        
        TextFetcher.default.setVersionSource(to: SampleAppTextSource.versionSource)
        TextFetcher.default.registerTextSource(fromProvider: SampleAppTextSource.text1)
        TextFetcher.default.registerTextSource(fromProvider: SampleAppTextSource.text2)
        TextFetcher.default.registerTextSource(fromProvider: SampleAppTextSource.text3)
    }
}
    
///
/// An enum defining text sources to be utilized within this app.
///
/// It extends TextSourceProvider, a protocol provided by TextFetcher to be used with various convenience calls, allowing
/// the passage of enum cases where a TextSource would otherwise be required.
///
enum SampleAppTextSource: String, TextSourceProvider, CaseIterable {
    
    case text1 = "Text1"
    case text2 = "Text2"
    case text3 = "Text3"
    
    private static let remotePath: String = "https://raw.githubusercontent.com/MREdigital/TextFetcher/master/Example Resources/Versioned/"
    
    private var bundleFile: BundleFile? {
        switch self {
            case .text1: return .init(fileName: "Text1", fileExtension: "txt")
            case .text2: return .init(fileName: "Text2", fileExtension: "txt")
            case .text3: return .init(fileName: "Text3", fileExtension: "txt")
        }
    }
    
    private var remoteFile: RemoteFile {
        switch self {
            case .text1: return .init(urlString: Self.remotePath + "text1.txt")
            case .text2: return .init(urlString: Self.remotePath + "text2.txt")
            case .text3: return .init(urlString: Self.remotePath + "text3.txt")
        }
    }
    
    static var versionSource: VersionSource {
        return .init(bundleFile: .init(fileName: "TextVersions", fileExtension: "json"), remoteFile: .init(urlString: remotePath + "TextVersions.json"))
    }
    
    var textSource: TextSource {
        return .init(identifier: rawValue, bundleFile: bundleFile, remoteFile: remoteFile)
    }
}



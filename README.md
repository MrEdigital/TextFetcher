# TextFetcher

![language](https://img.shields.io/badge/language-swift-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/TextFetcher.svg?style=flat)](http://cocoapods.org/pods/TextFetcher)
![CI Status](https://img.shields.io/badge/build-passing-success.svg)
[![Coverage Status](https://img.shields.io/badge/coverage-100%25-success.svg)](https://github.com/MREdigital/TextFetcher)
[![Platform](https://img.shields.io/cocoapods/p/TextFetcher.svg?style=flat)](http://cocoapods.org/pods/TextFetcher)
[![License](https://img.shields.io/cocoapods/l/TextFetcher.svg?style=flat)](http://cocoapods.org/pods/TextFetcher)
[![Twitter](https://img.shields.io/badge/twitter-@ericreedy-blue.svg)](http://twitter.com/ericreedy)

Hoping to spend all your time focusing on the intended purpose of that app you're building, and not how to manage licenses, policies, or other various texts?  Well boy are you in luck!  :)

TextFetcher is a simple library for fetching, caching, and retrieving versionable bundled or remote text files with ease!

## Description

TextFetcher maintains a file cache in your apps's documents directory which it populates with text files and version json, both local and remote.  Which text files are pulled and cached depend on the versions retrieved from an optional VersionSource.  The latest versions of text are always prefered, but older versions are considered a reasonable fallback.

## Installation

TextFetcher is available through [CocoaPods](http://cocoapods.org). To install, simply add the following line to your Podfile:

```ruby
pod "TextFetcher"
```

And run:

`$ pod install`

## Usage

- [Initialization](#Initialization)
- [Configuration](#Configuration)
- [Versioning](#Versioning)
- [Text Registration](#Text-Registration)
- [Text Retrieval](#Text-Retrieval)
- [Notifications](#Notifications)
- [Conveniences](#Conveniences)
- [Potential Improvements](#Potential-Improvements)

## Initialization

TextFetcher's primary class provides a single static default instance which should accomodate nearly every use case.  However, it maintains a distinct local cache per Session ID.  So in the case where multiple distinct and separate caches are necessary, a public initializer is provided as well.

#### Interface(s):

```swift
public static let `default`: TextFetcher = .init()
public init(withSessionID sessionID: String)
```
#### Example(s):

```swift
TextFetcher.default.doSomething(...)

// Or in the case that multiple distinct and separate caches are necessary, you might do this instead:

let textFetcherA = TextFetcher(withSessionID: "SomeIdentifierA")
textFetcherA.doSomething(...)

let textFetcherB = TextFetcher(withSessionID: "SomeIdentifierB")
textFetcherB.doSomething(...)
```

## Configuration

TextFetcher provides two public configuration calls.  One for Resource Bundle, and one for Resource Timeout.  The Resource Bundle setting specifies an App Bundle in which to search for any BundleFiles resulting from a VersionSource or a TextSource.  (see: [Versioning](#Versioning)/[Text Registration](#Text-Registration))  The Resource Timeout setting specifies the amount of time before a text request which is awaiting a remote fetch will be allowed before failing and falling back to a more local version. (see: [Text Retrieval](#Text-Retrieval))

#### Interface(s):

```swift
public func setResourceBundle(to bundle: Bundle) 
public func setResourceTimeout(to timeout: TimeInterval)
```

#### Example(s):

```swift
TextFetcher.default.setResourceBundle(to: Bundle(for: MyViewController.self))
TextFetcher.default.setResourceTimeout(to: 1)
```

## Versioning

To enable versioning in TextFetcher, you first create a VersionSource.  To create a VersionSource you must provide a RemoteFile specification, and optionally, a BundleFile specification.

#### Interface(s):

```swift
public struct VersionSource {
    public init(bundleFile: BundleFile? = nil, remoteFile: RemoteFile)
}
public struct BundleFile {   
    public init(fileName: String, fileExtension: String)
}
public struct RemoteFile {
    public init(urlString: String)
}
```

#### Example(s):

```swift
let bundleFile: BundleFile = .init(fileName: "Versions", fileExtension: "json")
let remoteFile: RemoteFile = .init(urlString: "http://www.domain.tld/path/file.extension")
let versionSource: VersionSource = .init(bundleFile: bundleFile, remoteFile: remoteFile))
```

Once created, you set it into the TextFetcher instance usig the following method:

#### Interface(s):

```swift
public func setVersionSource(to versionSource: VersionSource, withCompletion completion: (()->Void)? = nil)
```

#### Example(s):

```swift
TextFetcher.default.setVersionSource(to: versionSource)
```

Once set, the library will attempt to retrieve and decode each corresponding file.  The resulting pairings are then used to determine the versions of any registered TextSources by using their identifiers as a key to retrieve their corresponding versions.  The json format for a Version file might thereby look something like this:

```json
{
    "Text1": "1.2.3",
    "Text2": "123.456.789",
    "Text3": "0.0.1",
}
```

Where "Text1", "Text2", and "Text3" would correspond with the identifiers of three different registered TextSources.

## Text Registration

For each text you would like fetched, cached, and at some point, retrieved, you start by creating a TextSource for each.  To create a TextSource you must provide a BundleFile specification and/or a RemoteFile specification, as well as a String identifier which can be used for later retrieval, and associated with a Version as its key value (see: [Versioning](#Versioning)).

#### Interface(s):

```swift
public struct TextSource {
    public init(identifier: String, bundleFile: BundleFile?, remoteFile: RemoteFile?)
}
public struct BundleFile {   
    public init(fileName: String, fileExtension: String)
}
public struct RemoteFile {
    public init(urlString: String)
}
```

#### Example(s):

```swift
let eulaBundleFile: BundleFile = .init(fileName: "EULA", fileExtension: "txt")
let eulaRemoteFile: RemoteFile = .init(urlString: "http://www.domain.tld/path/file.extension")
let eulaTextSource: TextSource = .init(identifier: "eula", bundleFile: eulaBundleFile, remoteFile: eulaRemoteFile)
```

Once created, you register the TextSource with TextFetcher using one of the two following methods:

#### Interface(s):

```swift
public func registerTextSource(_ textSource: TextSource)

// convenience accessor(s):
public func registerTextSource(fromProvider textSourceProvider: TextSourceProvider)
```

#### Example(s):

```swift
TextFetcher.default.registerTextSource(eulaTextSource)
```

Once registered, the library will attempt to retrieve and cache the corresponding text, starting with the latest version.  Should that fail, it will fall back to the next version.  If there are more than one latest version, it will always prefer the most local version.  If no versions exist for the source, it will always load the most local file specification, falling back as needed.

## Text Retrieval

To retrieve text from TextFetcher, assuming a TextSource has been registered with valid File specifications, you can simply call one of the following functions, which will immediately return whichever value had been cached.  There may be times when a text has not finished being fetched, however, and you are willing to await its retrieval.  In such cases setting awaitRemoteFetchIfNeeded to true will wait for that process to finish (or attempt it again if needed), before returning the resulting value.  If the latest version has already been cached, however, setting it to true will have no effect.

#### Interface(s):

```swift
public func text(for resourceID: String, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion)

// convenience accessor(s):
public func text(for textSource: TextSource, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion)
public func text(for textSourceProvider: TextSourceProvider, awaitRemoteFetchIfNeeded: Bool = false, completion: @escaping TextRequestCompletion)

// typealias:
public typealias TextRequestCompletion = (_ text: String?, _ version: Version?) -> Void
```

#### Example(s):

```swift
TextFetcher.default.text(for: "Text1", awaitRemoteFetchIfNeeded: true) { text, version in
    print("Text retrieved: \(text ?? "None"), with Version: \(version?.stringValue ?? "No Version specified")")
}
```

## Notifications

There may be times when it is useful to be informed when a TextSource's version has been increased.  For example, if your end user license agreement has incremented, you could block the UI until it is accepted.  To receive such notifications, you first need to conform to the TextFetcherNotificationReceiver protocol:

#### Interface(s)

```swift
public protocol TextFetcherNotificationReceiver: class {
    func versionIncreased(to version: Version, for textSource: TextSource)
}
```

#### Example(s)

```swift
class MyViewController: UIViewController, TextFetcherNotificationReceiver {
    ...
  
    func versionIncreased(to version: Version, for textSource: TextSource) {
        if textSource.identifier == "eula" {
            setNeedsToAcceptEULA(to: true)
            presentEula()
        }
    }
}
```

Next, you manage the class's notification registration with TextFetcher via the following meethod:

#### Interface(s)

```swift
public func addNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
public func removeNotificationReceiver(_ notificationReceiver: TextFetcherNotificationReceiver)
```

#### Example(s)

```swift
TextFetcher.default.addNotificationReceiver(self)
```

Once this is done, any version increases will trigger the versionIncreased(to:for:) call in your registered class.  Note that receiver references are weakly retained, so the removeNotificationReceiver is really only offered for special cases where a class may simply wish to stop listening for such things.

## Conveniences

You may notice various alternate methods throughout which receive a TextSourceProvider where a TextSource would usually be required.  TextSourceProvider is a public protocol whose only requirement is that an object must contain a TextSource getter.

#### Interface(s)

```swift
public protocol TextSourceProvider {
    var textSource: TextSource { get }
}
```

The reason this has been included is because I wanted it to be easy to manage TextSources via Enum values (or some other structured approach), such as:

#### Example(s)

```swift
enum TextType: String, TextSourceProvider, CaseIterable {
    
    case text1 = "Text1"
    case text2 = "Text2"
    
    static var versionSource: VersionSource { ... }    
    var textSource: TextSource { ... }
}
```

With behavior such as:

#### Example(s)

```swift
// Registration
TextType.allCases.forEach {
    TextFetcher.default.registerTextSource(fromProvider: $0)
}

// Retrieval
TextFetcher.default.text(for: TextType.text1) { text, version in
    print("Text retrieved: \(text ?? "None"), with Version: \(version?.stringValue ?? "No Version specified")")
}
```

## Potential Improvements

#### High Priority

#### Low Priority

- Re-fetch remote Versions if they did not initially return.  (Currently requires a re-set of the VersionSource)
- Versions do not currently support values which begin with any number of zeros.  (Eg: “1.0.001” would collapse into “1.0.1”)

## License

This project is available under [The MIT License](http://opensource.org/licenses/MIT).  
Copyright © 2020, [Eric Reedy](mailto:eric@madcapstudios.com). See [LICENSE](LICENSE) file.

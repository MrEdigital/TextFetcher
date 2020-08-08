///
///  UML.swift
///  Created on 7/21/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///


///
///   Here are a few flow UMLs covering the most important behavior of the Text Fetcher.  Creating UMLs and updating them as you go is a great way to ensure your behavior functions properly, all the way through, no matter
///   how many sources, classes, etc, it happens to contain.  I wouldn't necessarily recommend creating them as Swift comments, as I have here, but it is sort of nice having them baked in cleanly to the project itself.
///


///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––    TextFetcher  Flows    ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///              [ TextFetcher ]                             TextManager                                 VersionManager                     |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       TextFetcher
///       public func text(withID resourceID: String, completion: TextFetchCompletion)
///
///                (START)
///                                  text(withID:)  ----------------⫸ text(withID:)
///                                 1 - loadText(forSource:)
///                                 2 - loadCachedText(forSource:)  ---------------------------------------------------------------⫸  Return - text
///                                           ⩔ ------------------------------------------------------------------------------------------- ↩︎
///                                 3 - Return - text
///   ⫷-------------------------------------------------------------------- ↩︎
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///              [ TextFetcher ]                             TextManager                                 VersionManager                     |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       TextFetcher
///       public func setVersionSource(_ versionSource: VersionSource)
///
///                (START)
///            setVersionSource(to:)  ------------------------o--------------------------⫸   setVersionSource(to:)
///                                                                  ⩔
///                                                           Set - versionSource
///                                                           1 - loadCachedValues()  -------------⫸  Return - cachedVersions ⩓⩔
///                                                                    ⩔ -------------------------------- ↩︎
///                                                           Set - cachedVersions
///                                                           2 - loadBundleValues()  -------------------------------------------------------⫸  Return -  bundledVersions
///                                                                                     ⩔ ------------------------------------------ ↩︎
///                                                           broadcastNewerVersions(in: bundledVersions, from: .bundle) [see broadcastAnyNewerVersions flow]
///                                                           3 - fetchRemoteValues --------------------------------------------------------------------------------------------------⫸  Cancel prior URLSession if needed
///                                                                                                                                   Fire URLSession
///                                                                                                                                   Async Return - remoteVersions
///                                                                                    ⩔ ---------------------------------------------------------------------------------------------- ↩︎
///                                                           broadcastNewerVersions(in: remoteVersions, from: .remote) [see broadcastAnyNewerVersions flow]
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///              [ TextFetcher ]                             TextManager                                 VersionManager                     |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       TextFetcher
///       public func registerTextSource(_ textSource: TextSource)
///
///                (START)
///            registerTextSource(_:)  -------⫸  registerTextSource(_:)
///                                 1 - insert into textSources
///                                 2 - inform version manager  ---------⫸  resourceRegistered(forID:)
///                                                           broadcastIfNewerVersion(forID: resourceID, with: bundledVersions[resourceID], from: .bundle)
///                                                           broadcastIfNewerVersion(forID: resourceID, with: remoteVersions[resourceID], from: .remote)
///                                                           [see broadcastIfNewerVersion flow]
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///              [ TextFetcher ]                             TextManager                                 VersionManager                     |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       TextFetcher
///       public func setResourceBundle(to bundle: Bundle)
///
///                (START)
///            setResourceBundle(to:)  ---⫸   setResourceBundle(to:)  ----------------------------------------------------------------------------------------------------------⫸  setBundle(to:)
///                                                                                                                Set - bundle
///                                                     ------⫸  setResourceBundle(to:) --------------------------------------------------------------⫸  setBundle(to:)
///                                                                                                                Set - bundle
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///              [ TextFetcher ]                             TextManager                                 VersionManager                     |                       Cache                                       Bundle                                         Remote   
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       TextFetcher
///       public func setResourceTimeout(to timeout: TimeInterval)
///
///                (START)
///            setResourceTimeout(to:)  ---⫸   setResourceTimeout(to:)  -------------------------------------------------------------------------------------------------------------------------------------------⫸  setResourceTimeout(to:)
///                                                                                                                                   Set - timeout
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––    VersionManager Flows    –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///               TextFetcher                                TextManager                              [ VersionManager ]                  |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       VersionManager
///       func broadcastNewerVersions(in versions: Versions?, from location: ResourceLocation)
///            with: ResourceLocation.bundle
///
///                                                                (START)
///                                                          broadcastAnyNewerVersions(in: versions, from: .bundle)
///                                                          1 - for each new version ...
///                                                          broadcastIfNewerVersion(forID: resourceID, with: version, from: location)
///                                                    ⩔------------⩔------------⩔---------------------------- ↩︎ ---------------- ↩︎ -------------- ↩︎
///                                 newerVersionDetected(version, resourceID, location)  ------------------------------------------------------------------------⫸ Return - text
///                                            ⩔ ----------------------------------------------------------------------------------------------------------------------------- ↩︎
///                                 1 - cacheText(text, textSource, version)
///                                  ↳ ------------------------------------------------------------------------------------------------⫸  saveToCache(text)
///                                                                                          (encode / write to disk)
///                                  ↳ ------------------------------------⫸  2 - resourceCached(resourceID, version)
///                                                          3 - update cached versions
///                                                          4 - saveCacheValues()  -----------------------⫸  saveToCache(versions)
///                                                                                          (encode / write to disk)
///                                  delefate?.versionIncreased(to: version, for: textSource)
///           notificationCenter.notifyReceivers_versionIncreased() ⫷-------------------------------------- ↵
///   ⫷-------------------------------------------------------------------------------- ↵
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///               TextFetcher                                TextManager                              [ VersionManager ]                  |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       VersionManager
///       func broadcastAnyNewerVersions(in versions: Versions?, from location: ResourceLocation)
///            with: ResourceLocation.remote
///
///                                                                (START)
///                                                          broadcastAnyNewerVersions(in: versions, from: .remote)
///                                                          for each version:  broadcastIfNewerVersion() [see broadcastIfNewerVersion flow]
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///               TextFetcher                                TextManager                              [ VersionManager ]                  |                       Cache                                       Bundle                                         Remote
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///
///       VersionManager
///       func broadcastIfNewerVersion(forID resourceID: String, with version: Version?, from location: ResourceLocation)
///            with: ResourceLocation.remote
///
///                                                                (START)
///                                                          broadcastIfNewerVersion(forID: resourceID, with: version, from: location)
///                                                    ⩔------------⩔------------⩔---------------------------- ↩︎ ---------------- ↩︎ -------------- ↩︎
///                                 newerVersionDetected(version, resourceID, location)  ----------------------------------------------------------------------------------------------------------------⫸ Register Completion
///                                                                                                                                      Fire URLSession if needed
///                                                                                                                                      Async Return - remoteText
///                                              ⩔ -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ↩︎
///                                1 - cacheText(remoteText, textSource, version)
///                                      ↳ ----------------------------------------------------------------------------------------⫸  saveToCache(text)
///                                                                                          (encode / write to disk)
///                                      ↳ -----------------------------⫸  2 - resourceCached(resourceID, version)
///                                                          3 - update cached versions
///                                                          4 - saveCacheValues()  -----------------------⫸  saveToCache(versions)
///                                                                                          (encode / write to disk)
///
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
///   –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––


///  Useful Symbols: ↵ ↲ ↩︎ ↳ ↪︎ ↰ ↱ ↴ ↶ ↷ ⟲ ⤶ ⥰ ⥹ ⥻ ⥺ ⤵︎⤷⤥ ⤹ ⫸ ⩔ ⫷

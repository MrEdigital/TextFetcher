#
#  Be sure to run `pod spec lint TextFetcher.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
    spec.name          = "TextFetcher"
    spec.version       = "1.0.0"
    spec.summary       = "A library for retrieving, caching, and returning versionable bundled or remote text files."
    spec.description   = "TextFetcher is a library for retrieving, caching, and returning versionable bundled or remote text files."
    spec.homepage      = "https://github.com/MREdigital/TextFetcher"
    spec.license       = "MIT"
    spec.author        = { "Eric Reedy" => "eric@madcapstudios.com" }
    spec.source        = { :git => "https://github.com/MREdigital/TextFetcher.git", :tag => "#{spec.version}" }
    spec.source_files  = "TextFetcher", "TextFetcher/**/*.{h,m,swift}"
    spec.exclude_files = "TextFetcher/Exclude"
    spec.requires_arc  = true
    spec.swift_version = "5.0"
    spec.ios.deployment_target     = "12.0"
    spec.osx.deployment_target     = "10.15"
    spec.tvos.deployment_target    = "13.0"
    spec.watchos.deployment_target = "6.2"

end

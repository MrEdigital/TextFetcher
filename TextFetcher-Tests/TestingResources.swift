///
///  Global.swift
///  Created on 7/27/20
///  Copyright © 2020 Eric Reedy. All rights reserved.
///

@testable import TextFetcher

///
/// A simple nested static struct containing various values to be used throughout this bundle's unit tests.
///
struct TestingResources {
    private init() {}
    
    struct Endpoints {
        private init() {}
        
        static let serverAddress: String = "stubbedserver.com"

        struct Versions {
            private init() {}

            static let s: String = "/texts/versions_small.json"
            static let m: String = "/texts/versions_medium.json"
            static let l: String = "/texts/versions_large.json"
        }
        
        struct Texts {
            private init() {}
            
            static let s: String = "/texts/text_small.txt"
            static let m: String = "/texts/text_medium.txt"
            static let l: String = "/texts/text_large.txt"
        }
    }

    struct BundleFileNames {
        private init() {}

        struct Versions {
            private init() {}

            static let s: String = "TestVersions_small"
            static let m: String = "TestVersions_medium"
            static let l: String = "TestVersions_large"
            static let `extension`: String = "json"
        }
        
        struct Texts {
            private init() {}
            
            static let s: String = "TestText_small"
            static let m: String = "TestText_medium"
            static let l: String = "TestText_large"
            static let `extension`: String = "txt"
        }
    }
    
    struct BundleFileContents {
        private init() {}
        
        struct Versions {
            private init() {}
        
            /// An assortment of Versions whose values are the smallest of those provided
            static let s: VersionStore = .init(withVersions: ["Test1":    .init(major: 1,   minor: 2,   patch: 3),
                                                              "Test2":    .init(major: 123, minor: 456, patch: 789),
                                                              "Test3":    .init(major: 0,   minor: 0,   patch: 1),
                                                              "TestText": .init(major: 1,   minor: 0,   patch: 0)])
            
            /// An assortment of Versions whose values are greater than the smallest, but less than the largest, of those provided
            static let m: VersionStore = .init(withVersions: ["Test1":    .init(major: 1,   minor: 2,   patch: 4),
                                                              "Test2":    .init(major: 123, minor: 578, patch: 789),
                                                              "Test3":    .init(major: 0,   minor: 6,   patch: 1),
                                                              "TestText": .init(major: 20,  minor: 0,   patch: 0)])
                                
            /// An assortment of Versions whose values are the largest of those provided
            static let l: VersionStore = .init(withVersions: ["Test1":    .init(major: 1,   minor: 2,   patch: 5),
                                                              "Test2":    .init(major: 123, minor: 999, patch: 789),
                                                              "Test3":    .init(major: 7,   minor: 0,   patch: 1),
                                                              "TestText": .init(major: 999, minor: 0,   patch: 0)])
        }
        
        struct Texts {
            private init() {}
            
            static let s: String = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n
            """

            static let m: String = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Varius duis at consectetur lorem donec massa. Egestas diam in arcu cursus euismod quis viverra nibh cras. Viverra aliquet eget sit amet tellus cras. Et tortor consequat id porta nibh venenatis cras sed. Etiam dignissim diam quis enim lobortis scelerisque. Nec tincidunt praesent semper feugiat nibh sed pulvinar proin. Quisque non tellus orci ac auctor augue mauris. Libero enim sed faucibus turpis in. Ut venenatis tellus in metus. Quam elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Eros donec ac odio tempor orci dapibus ultrices in iaculis. Nibh sed pulvinar proin gravida hendrerit. Sapien et ligula ullamcorper malesuada proin libero nunc. Non enim praesent elementum facilisis leo. Luctus venenatis lectus magna fringilla urna porttitor rhoncus dolor. Scelerisque viverra mauris in aliquam sem. Pellentesque id nibh tortor id aliquet.

            Turpis tincidunt id aliquet risus. Mattis vulputate enim nulla aliquet porttitor. Eros donec ac odio tempor orci dapibus ultrices in iaculis. Adipiscing diam donec adipiscing tristique risus nec feugiat in. Magna sit amet purus gravida quis blandit turpis cursus. Vitae purus faucibus ornare suspendisse sed nisi. Quis blandit turpis cursus in. Arcu odio ut sem nulla pharetra diam sit amet nisl. Amet consectetur adipiscing elit duis tristique. Elementum integer enim neque volutpat ac tincidunt vitae semper. Lacus vel facilisis volutpat est velit egestas dui. Amet massa vitae tortor condimentum. Non quam lacus suspendisse faucibus interdum posuere lorem ipsum dolor. Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Scelerisque eu ultrices vitae auctor. Amet consectetur adipiscing elit ut aliquam purus sit. Auctor neque vitae tempus quam pellentesque. Vulputate ut pharetra sit amet aliquam id diam. Auctor eu augue ut lectus arcu bibendum at varius.\n
            """

            static let l: String = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Maecenas accumsan lacus vel facilisis volutpat est velit. In nisl nisi scelerisque eu. Sit amet venenatis urna cursus eget. Nibh cras pulvinar mattis nunc. Sed pulvinar proin gravida hendrerit lectus a. Enim neque volutpat ac tincidunt vitae semper quis lectus. Nulla facilisi morbi tempus iaculis urna. Tortor consequat id porta nibh. Feugiat in ante metus dictum at. Turpis massa tincidunt dui ut ornare lectus sit amet est. Adipiscing diam donec adipiscing tristique risus nec. In egestas erat imperdiet sed euismod. Blandit libero volutpat sed cras ornare arcu dui vivamus arcu. Convallis tellus id interdum velit laoreet id donec. Sodales neque sodales ut etiam sit amet nisl. Urna condimentum mattis pellentesque id nibh tortor id. Lacinia at quis risus sed vulputate odio ut enim. Aliquet lectus proin nibh nisl condimentum id venenatis.

            Nunc pulvinar sapien et ligula ullamcorper malesuada proin libero. Egestas integer eget aliquet nibh. Urna nec tincidunt praesent semper feugiat nibh. Eleifend mi in nulla posuere sollicitudin aliquam. Massa eget egestas purus viverra accumsan in nisl. Felis imperdiet proin fermentum leo. Nunc consequat interdum varius sit amet. Sit amet venenatis urna cursus eget. Adipiscing tristique risus nec feugiat in fermentum posuere. Tellus in metus vulputate eu scelerisque felis imperdiet. In metus vulputate eu scelerisque felis imperdiet. Risus in hendrerit gravida rutrum quisque non tellus orci ac. Mattis pellentesque id nibh tortor id aliquet lectus proin nibh. Scelerisque viverra mauris in aliquam sem fringilla ut.

            In metus vulputate eu scelerisque felis imperdiet. Iaculis at erat pellentesque adipiscing commodo elit at. Dui ut ornare lectus sit. Ac tincidunt vitae semper quis lectus nulla. Mauris vitae ultricies leo integer malesuada nunc vel risus. Sit amet mattis vulputate enim nulla. Pretium lectus quam id leo in. Odio aenean sed adipiscing diam donec adipiscing tristique. Tellus in metus vulputate eu scelerisque felis. Ac turpis egestas sed tempus urna et pharetra. Fames ac turpis egestas maecenas pharetra convallis posuere morbi. Eget nunc scelerisque viverra mauris in aliquam sem fringilla ut. Sollicitudin ac orci phasellus egestas. Pulvinar pellentesque habitant morbi tristique senectus et netus. Velit egestas dui id ornare arcu odio ut.

            Tortor at risus viverra adipiscing at in tellus integer feugiat. Id aliquet risus feugiat in ante metus dictum. Netus et malesuada fames ac turpis egestas integer. Consectetur adipiscing elit ut aliquam. Sed elementum tempus egestas sed. Proin fermentum leo vel orci porta non pulvinar neque. Gravida in fermentum et sollicitudin. Libero justo laoreet sit amet cursus sit amet dictum sit. Nunc eget lorem dolor sed viverra ipsum nunc. Enim tortor at auctor urna nunc id cursus. Nunc eget lorem dolor sed.

            Non diam phasellus vestibulum lorem sed. Vel risus commodo viverra maecenas accumsan lacus vel facilisis volutpat. Pulvinar elementum integer enim neque volutpat. Velit euismod in pellentesque massa placerat duis ultricies. Amet consectetur adipiscing elit duis tristique sollicitudin. Enim facilisis gravida neque convallis a cras semper auctor. Libero volutpat sed cras ornare arcu dui. Id porta nibh venenatis cras sed felis eget. Turpis in eu mi bibendum neque. Nunc sed augue lacus viverra vitae congue eu consequat ac. Etiam tempor orci eu lobortis elementum nibh tellus molestie. Cursus eget nunc scelerisque viverra mauris in.

            Elementum curabitur vitae nunc sed velit dignissim sodales. Pharetra vel turpis nunc eget. Dui id ornare arcu odio ut sem. In massa tempor nec feugiat nisl pretium. Et malesuada fames ac turpis egestas maecenas pharetra convallis. Enim facilisis gravida neque convallis a cras semper auctor neque. Vitae congue eu consequat ac felis donec et odio. Tortor pretium viverra suspendisse potenti nullam ac. Rutrum tellus pellentesque eu tincidunt tortor. Nec feugiat in fermentum posuere urna nec tincidunt. Malesuada fames ac turpis egestas sed tempus urna. Amet consectetur adipiscing elit duis tristique sollicitudin nibh. Sed adipiscing diam donec adipiscing tristique. Feugiat nisl pretium fusce id velit. Pulvinar neque laoreet suspendisse interdum consectetur. At risus viverra adipiscing at. Duis ut diam quam nulla porttitor massa id neque aliquam. Ut enim blandit volutpat maecenas volutpat blandit. Sapien et ligula ullamcorper malesuada proin libero nunc consequat interdum. Iaculis urna id volutpat lacus laoreet non curabitur gravida arcu.\n
            """
        }
    }
}

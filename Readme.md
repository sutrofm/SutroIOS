Rdio Party for iOS
==================

[![CircleCI](https://circleci.com/gh/gabek/RdioPartyIOS.svg?style=svg&circle-token=340c87efe41ee094cdc5276434bed780643b3b13)](https://circleci.com/gh/gabek/RdioPartyIOS)

The iOS [Rdio Party](http://rdioparty.com/) client aims to be a
functional front-end to the Rdio Party service. Written in Swift,
powered by [Firebase](https://www.firebase.com/docs/ios/api/) and the
[Rdio iOS SDK](http://www.rdio.com/developers/docs/libraries/ios/).

-   List available rooms, visually indicating ones that have activity.
-   Be able to view and contribute to a room's chat.
-   Add to a room's track queue.
-   Vote on queued tracks.
-   Play back, and sync, with the currently played track in the party.

### Build

-   Update to Xcode 6.3 Beta. Required to support [Swift
    1.2](https://developer.apple.com/swift/blog/?id=22)
-   Update to the most recent [Cocoapods
    0.36](http://blog.cocoapods.org/CocoaPods-0.36/) that supports
    Swift.

        gem install cocoapods
        pod install

### Dependencies

-   Notice the [Rdio iOS
    SDK](http://www.rdio.com/developers/docs/libraries/ios/) is not
    included in the Podfile as I've bundled in a beta build that fixes
    some issues and supports additional features. Once this version of
    the sdk is released publicly we can use Cocoapods to track this
    dependency as well.
    -   Currently AFNetworking and AFOAuth2Manager are dependancies of
        the Rdio SDK to support OAuth2.
-   [SDWebImage](https://github.com/rs/SDWebImage) is used for async
    image loading and local caching.
-   [SlackTextViewController](https://github.com/slackhq/SlackTextViewController)
    is a nice drop-in UIViewController subclass that gives a nice input
    box and the translation required for *bottom-up* UITableView usage.
-   [MLPAutoCompleteTextField](https://github.com/EddyBorja/MLPAutoCompleteTextField)
    is a simple UITextField subclass that displays a dropdown list of
    items that are provided by the RdioSearchDelegate. This is more of a
    shortcut, and building something from scratch would be nice.

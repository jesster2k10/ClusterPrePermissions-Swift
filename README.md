# PrePermissions
![PrePermissions](http://i.imgur.com/TZMEpqJ.png)

![Cocoapods](https://img.shields.io/cocoapods/v/AFNetworking.svg) ![Build](https://img.shields.io/travis/USER/REPO.svg) ![Swift](https://img.shields.io/badge/swift-3.0-orange.svg) ![Platform](https://img.shields.io/badge/platform-ios8+-pink.svg)

PrePermissions is the swift counterpart for the Objcetive-C [ClusterPrePermissions](https://github.com/rsattar/ClusterPrePermissions) framework. PrePermissions works by showing the user a custom `UIAlertController` before it asks them for permissions. It essentially wraps the standard permission alrert with a `UIAlertController` asking the user for permissions twice. This reduces the positbility of the user accidentally hitting `Not Now` and having to manually go into settings to re-enable permissions.

##### Supported Permissions:
- Photo Library
- Contacts
- Camera
- Microphone
- Push Notifications
- Events 
- Location

## Demo

## Requirments

- iOS 8.0+
- Swift 3.0+

## Installation

### Cocoapods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

``` bash
$ gem install cocoapods
```
To integrate `PrePermissions` into your project using Cocoapods, just add it in your `Podfile`.

``` ruby
# For latest release in cocoapods
pod 'PerPermissions'

# Latest on develop
pod 'PerPermissions', :git => 'https://github.com/jesster2k10/PerPermissions.git', :branch => 'develop'
```

And run `pod install`

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh) using the following command:

``` bash
$ brew update
$ brew install carthage
```

To integrate `PrewPermissions` into your project using Carthage, add it to your `Cartfile`:

``` ruby
github "jesster2k10/PrewPermissions" 
```

And run `cathage update`

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate Alamofire into your project manually. 

Just drag all the files from the `/Sources/` directory into your project and copy if needed.

## Contribution

- If you've found a bug, please open an issue.
- If you've a feature request, please open a pull request
- Please check any closed issues before you open a new one!

## Lisence

PrePermissons is released under the MIT License. Read the `LISENCE` for details.

<img src="/Development/Resources/Assets.xcassets/AppIcon.appiconset/Icon.png" height="128">

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkudit%2FColor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kudit/Color)

# Color.swiftpm
Color simplifies color objects into a standard syntax that can be used cross platform and adds basic Codable and string representation and conversion for HTML colors and hexadecimal colors.

The primary goals are to be easily maintainable by multiple individuals and be able to be used across all platforms.

This is actively maintained so if there is a feature request or change, we will strive to address within a week.

## Features

- [x] Named CSS colors.
- [x] Hexadecimal colors.
- [x] Allows consistent API usage with SwiftUI Color, NSColor, and UIColor so code can be platform agnostic.
- [x] Adds `.magenta`, `.lightGray`, and `.darkGray` to the standard named colors and ensures `.pink` is available on all platforms.
- [x] Has preset color lists that can be iterated.

## Requirements

- iOS 15+ (15 required for .brown, .cyan, .indigo, .mint, and .teal, 15.2+ minimum required for Swift Playgrounds support)
- macOS 12+ (macOS 11 required for cgColor conversions, macOS 12 minimum for .brown, .cyan, .indigo, .mint, and .teal)
- macCatalyst 15.0+
- tvOS 15.0+ (15 required for .brown, .cyan, .indigo, .mint, and .teal)
- watchOS 8.0+ (UI only supported on watchOS 8.0+)
- visionOS 1.0+
- Theoretically should work with Linux, Windows, and Vapor, but haven't tested.  If you would like to help, please let us know.

## Known Issues
None

## Installation
Install by adding this as a package dependency to your code.  This can be done in Xcode or Swift Playgrounds!

### Swift Package Manager

#### Swift 5
```swift
dependencies: [
    .package(url: "https://github.com/kudit/Color.git", from: "1.0.0"),
    /// ...
]
```

You can try these examples in a Swift Playground by adding package: https://github.com/kudit/Color

## Usage
First make sure to import the framework:
```swift
import Color
```

Here are some usage examples.

### Create a color from a hex string.
```swift
let color: Color = "#ff0000" // should create a red color
```

### Create a color from a named CSS string.
```swift
let color: Color = "red" // should create a red color
```

### Get a list of rainbow primary colors.
```swift
let colors: [Color] = .rainbow
```

All these tests can be demonstrated using the previews in the file DemoViews.swift which can be viewed in Xcode Previews or in Swift Playgrounds!

## Contributing
If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.

## Donations
This was a lot of work.  If you find this useful particularly if you use this in a commercial product, please consider making a donation to http://paypal.me/kudit

## Contributors
The complete list of people who contributed to this project is available [here](https://github.com/kudit/Color/graphs/contributors).
A big thanks to everyone who has contributed! 🙏

<img src="/Development/Resources/Assets.xcassets/AppIcon.appiconset/Icon.png" height="128">

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fkudit%2FColor%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/kudit/Color)

# Color.swiftpm
Color simplifies color objects into a standard syntax that can be used cross platform and adds basic Codable and string representation and conversion for HTML colors and hexadecimal colors.

The primary goals are to be easily maintainable by multiple individuals, employ a consistent API that can be used across all platforms, and to be maintainable using Swift Playgrounds on iPad and macOS.  APIs are typically present even on platforms that don't support all features so that availability checks do not have to be performed in external code, and where irrelevant, code can simply return optionals.

This is actively maintained so if there is a feature request or change, we will strive to address within a week.


## Features
- Can develop and modify without Xcode using Swift Playgrounds on iPad!
- String initialization with the following formats:
	- Named CSS/HTML colors (case insensitive, ex: "LightSteelBlue")
	- Hexadecimal colors (3 or 6 character format, case insensitive, ex: "#c3a", "#cc33aa", "#C0FFEE")
	- CSS rgb/a colors (case insensitive, space insensitive, values out of 255 but extended colors beyond this are supported, optional alpha parameter should be between 0.0 and 1.0, eg: "rgb(255, 0,0)", "rgb(238, 130, 238, 0.2)")
- Allows consistent API usage with SwiftUI Color, NSColor, and UIColor so code can be platform agnostic.
- Adds `.magenta`, `.lightGray`, and `.darkGray` to the standard named colors and ensures `.pink` is available on all platforms.
- Ability to get lighter and darker colors from a base color.
- Ability to determine if colors are "light" or "dark" to ensure contrasting colors are used.
- Has preset color lists that can be iterated like `[Color].rainbow`.
- Standard color names for DOT signage colors.


## Requirements
- iOS 11+ (15 required for .brown, .cyan, .indigo, .mint, and .teal, 15.2+ minimum required for Swift Playgrounds support)
- macOS 10.5+ (macOS 11 required for cgColor conversions, macOS 12 minimum for .brown, .cyan, .indigo, .mint, and .teal)
- macCatalyst 13+ (first version available)
- tvOS 11+ (15 required for .brown, .cyan, .indigo, .mint, and .teal)
- watchOS 4+ (UI only supported on watchOS 8+)
- visionOS 1+
- Theoretically should work with Linux, Windows, and Vapor, but haven't tested.  If you would like to help, please let us know.


## Known Issues
*See CHANGELOG.md for known issues and roadmap*
Due to the way SwiftUI Color stores values, an alpha value of "0.2" is stored as "0.20000000298023224" which is wrong, so when exporting as css string, this will round decimals to 7 places.  This does mean that alpha values cannot have more than 7 digits of precision, but typically alpha values will be nice numbers so this will usually be the correct behavior for expected results.
Note: versions previous to 1.2.0 could be iterated in lists directly.  Identifiable conformance removed to be more compatible and silence Xcode 16 warnings so in order to iterate in SwiftUI List or ForEach, add `id: \.pretty` to the iterator.


## Installation
Install by adding this as a package dependency to your code.  This can be done in Xcode or Swift Playgrounds!

### Swift Package Manager

#### Swift 5+
You can try these examples in a Swift Playground by adding package: `https://github.com/kudit/Color`

If the repository is private, use the following link to import: `https://<your-PAT-string>@github.com/kudit/Color.git`

Or you can manually enter the following in the Package.swift file:
```swift
dependencies: [
    .package(url: "https://github.com/kudit/Color.git", from: "1.0.0"),
]
```


## Usage
First make sure to import the framework:
```swift
import Color
```

Here are some usage examples.

### Get the version of Color that is imported.
```swift
let version = Color.version
```

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

All these tests can be demonstrated using previews or by running the app executable that is bundled in the Development folder of the module.


## Contributing
If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality yourself and want others to use it too, please submit a pull request.


## Donations
This was a lot of work.  If you find this useful particularly if you use this in a commercial product, please consider making a donation to http://paypal.me/kudit


## License
Feel free to use this in projects, however, please include a link back to this project and credit somewhere in the app.  Example Markdown and string interpolation for the version:
```swift
Text("Open Source projects used include [Color](https://github.com/kudit/Color) v\(Color.version)
```


## Contributors
The complete list of people who contributed to this project is available [here](https://github.com/kudit/Color/graphs/contributors).
A big thanks to everyone who has contributed! 🙏

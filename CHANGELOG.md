# ChangeLog

NOTE: Version needs to be updated in the following places:
- [ ] Xcode project version (in build settings - normal and watch targets should inherit)
- [ ] Package.swift iOSApplication product displayVersion.
- [ ] Color.version constant (must be hard coded since inaccessible in code)
- [ ] Update changelog and tag with matching version in GitHub.

TODO: Update tab view to use backport version that can extend content into safe area but still respects safe area for scrolling and clearing.

v1.1.4 10/14/2024 Updated Compatibility to good version 1.3.15

v1.1.3 8/19/2024 Updated so that we can use `.accentColorAsset` to fix issues with tvOS using color.

*PASSES ALL SWIFTPACKAGEINDEX TESTS*
v1.1.2 8/14/2024 Updated Compatibility version to 1.3.6.

*PASSES ALL SWIFTPACKAGEINDEX TESTS - but Compatibility does not*
v1.1.1 8/13/2024 Updated Compatibility version to 1.3.5.

v1.1.0 8/13/2024 Standardized Package.swift, CHANGELOG.md, README.md, and LICENSE.txt files.  Standardized deployment targets.  Changed from `.fixedBrown` to `.brownFixed` so only have to add suffix.  Also added `.brownBackport` to get the native `.brown` or `.brownFixed` if not available. (same for all the iOS 15 color additions).  Backed up the compatibility versions so can use in Device so that we don't have to re-code a `Color(hex:)` function.  Fixed background tint in icon to match better.

*PASSES ALL SWIFTPACKAGEINDEX TESTS*
v1.0.6 7/16/2024 Fixing issues with linux version of Color missing some things.  Added manual conversion from HSB to RGB for storage.  Added conversion  from RGB to HSB as well as static function on KuColor.

v1.0.5 7/15/2024 Not sure why SwiftPackageIndex wasn't picking up the update to Compatibility to fix Linux and watchOS support... Forced package minimum to Compatibility 1.0.17 to hopefully fix this.  May also have been Package.resolved was using the older version (test in Swift Playgrounds in the future to make sure Package.resolved gets updated).  Moved Demo color list to ColorUI rather than in MyApp so can be used elsewhere and exposes the Compatibility version.

v1.0.4 7/15/2024 Updated Compatibility to fix watchOS and Linux support.  Updated icon for new themeing.  Re-worked demo app for better compatibility on various platforms and clearing safe areas.  UI works on watchOS now.  Fixed contrastingColor in watchOS and visionOS for primary and secondary colors.

v1.0.3 7/14/2024 Updated Compatibility version to fix Linux support.  Added improved tinting view.  Rounded colorset tests view.  Improved Pretty test view to have panels and better example cases.  Was completely missing NSColor support and was only using SwiftUI color.  Added scratch code for NSColor support for macOS but doesn't work with extended color space which causes issues.  Fixed lightness test for macOS light gray.

v1.0.2 7/11/2024 Updated Compatibility version which supports older versions.  Updated so playgrounds can run while the package supports older iOS versions.

v1.0.1 7/11/2024 Made changes from 0 and 1 to .zero and .one constants.  Created fallback versions of named colors so can fallback when the named colors are not present.  Re-worked to update Compatibility for watchOS and tvOS compatibility.  Increased minimum tvOS and watchOS and macOS to match iOS requirement.  Moved colorLogging debug statements onto the main thread so can check the current colorLogging state.  Raised minimum iOS to 15.2 since that is usually what Compatibility will need.

v1.0 7/7/2024 Initial code and features pulled from KuditFrameworks.  Broke code up into separate files for clarity since this is all now contained in this module.  Depends on Compatibility for string and threading and debugging and testing functions.


## Bugs to fix:
Known issues that need to be addressed.
- [ ] Get UI working on tvOS (looks okay but paging doesn't seem to work in tvOS).
- [ ] Page indicators are nearly invisible when in light mode on iOS.

## Roadmap:
Planned features and anticipated API changes.  If you want to contribute, this is a great place to start.
- [ ] Add ability to search named colors view and sort by Name or by Hue.
    - [ ] Add toggle to color tests CSS Named Colors list to order Alphabetically vs ordering .sort { $0.hue < $1.hue }
- [ ] No planned new features

## Proposals:
This is where proposals can be discussed for potential movement to the roadmap.
- [ ] Add additional colorsets:
    - https://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors
        Create this as a separate package that leverages this but can include additional Crayola information.
    - https://www.swatchtool.com/copic
- [ ] Obfuscate KuColor as the basis?

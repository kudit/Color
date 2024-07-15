# ChangeLog

NOTE: Version needs to be updated in the following places:
- [ ] Xcode project version (in build settings - normal and watch targets should inherit)
- [ ] Package.swift iOSApplication product displayVersion.
- [ ] Color.version constant (must be hard coded since inaccessible in code)
- [ ] Tag with matching version in GitHub.

VisionOS contrast not working

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
- [ ] No planned new features

## Proposals:
This is where proposals can be discussed for potential movement to the roadmap.

- [ ] Obfuscate KuColor as the basis?

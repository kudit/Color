//
//  ColorTests.swift
//  ColorTests
//
//  Created by Ben Ku on 7/13/26.
//

// Swift Testing requires Swift 5.9. Keeping the imports and suite behind this
// compiler check lets the Swift 5.8 package manifest remain usable by older
// clients while current SwiftPM and Xcode installations run the tests.
#if compiler(>=5.9) && canImport(Color) && canImport(Testing)
import Color
import Testing

#if canImport(SwiftUI)
import SwiftUI
// Use SwiftUI's concrete color on Apple platforms because `KuColor` is a
// protocol and cannot itself be initialized or decoded by a test.
private typealias TestColor = SwiftUI.Color
#else
// The package supplies its own concrete `Color` value on platforms without
// SwiftUI, allowing the same behavioral tests to cover server toolchains.
private typealias TestColor = Color.Color
#endif

#if canImport(Foundation) && !(os(WASM) || os(WASI))
import Foundation
#endif

/// Verifies the public, platform-independent color behaviors that clients rely
/// on for parsing, display, and persistence.
@Suite("Color parsing and persistence")
struct ColorTests {
    /// Confirms that common CSS and hexadecimal inputs normalize to stable
    /// strings, including shorthand expansion and case-insensitive names.
    @Test("CSS names and hexadecimal strings parse consistently")
    func parsesCSSAndHexStrings() {
        let named = TestColor(string: "LightSteelBlue")
        let shortHex = TestColor(string: "#c3a")
        let longHex = TestColor(string: "#CC33AA")

        #expect(named?.hexString == "#B0C4DE")
        #expect(shortHex?.hexString == "#CC33AA")
        #expect(longHex?.hexString == "#CC33AA")
    }

    /// Ensures alpha survives both accepted hexadecimal forms and is included
    /// in the canonical string used for storage and interchange.
    @Test("Alpha values survive hexadecimal parsing")
    func preservesHexAlpha() {
        let shortHexWithAlpha = TestColor(string: "#c3a8")
        let longHexWithAlpha = TestColor(string: "#CC33AA88")

        #expect(shortHexWithAlpha?.hexString == "#CC33AA88")
        #expect(longHexWithAlpha?.hexString == "#CC33AA88")
    }

    /// Guards the failable initializer so malformed values do not silently
    /// produce a color that could later be persisted as valid input.
    @Test("Invalid color strings are rejected")
    func rejectsInvalidStrings() {
        #expect(TestColor(string: "not-a-color") == nil)
        #expect(TestColor(string: "#12") == nil)
    }

#if canImport(Foundation) && !(os(WASM) || os(WASI))
    /// Verifies that the library's public Codable implementation round-trips
    /// through JSON using its stable string representation rather than a
    /// platform-specific archived color object.
    @Test("Codable colors round-trip through JSON")
    func roundTripsCodableColor() throws {
        let original = TestColor(string: "rgba(255,57,46,0.3)")!
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(TestColor.self, from: encoded)

        #expect(decoded.stringValue == original.stringValue)
    }
#endif
}
#endif

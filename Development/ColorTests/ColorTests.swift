//
//  ColorTestsSuite.swift
//  ColorTestsSuite
//
//  Created by Ben Ku on 7/13/26.
//

// Swift Testing requires Swift 5.9. This target is only a bridge to the
// reusable Compatibility Test values shipped by the Color module, ensuring
// Xcode/CI and the in-app test UI execute identical checks.
#if compiler(>=5.9) && canImport(Color) && canImport(Testing)
import Color
import Compatibility
import Testing

#if canImport(SwiftUI)
import SwiftUI
/// Selects SwiftUI's concrete color type so the bridge can reach the module's reusable tests without ambiguity.
private typealias TestedColor = SwiftUI.Color
#else
/// Selects the package's fallback concrete color type on platforms where SwiftUI is unavailable.
private typealias TestedColor = Color.Color
#endif

/// Bridges each ordered Color test section into Swift Testing without duplicating the behavioral assertions.
@Suite("Color Tests")
struct ColorTestsSuite {
    /// Runs one reusable test while retaining its section name in Swift Testing's argument report.
    @Test(
        "Reusable Color test",
        .serialized,
        arguments: await MainActor.run {
            TestedColor.tests.flatMap { section, tests in
                tests.map { (section: section, test: $0) }
            }
        }
    )
    @MainActor
    @available(iOS 13, macOS 12, tvOS 13, watchOS 6, *)
    func reusableColorTest(section: String, test: TestCase) async throws {
        // Execute the shared closure directly so thrown failures retain Swift
        // Testing's native context while the section argument identifies its group.
        _ = section
        try await test.execute()
    }
}
#endif

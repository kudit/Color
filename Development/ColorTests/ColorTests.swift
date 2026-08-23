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
import CompatibilityTesting
import Testing

/// Presents every reusable Color `TestCase` as its own named Swift Testing argument.
@Suite("Color Tests")
struct ColorTestsSuite {
    /// Runs the same ordered reusable tests used by Compatibility's in-app test UI.
    @Test(
        "Reusable Color test",
        .serialized,
        arguments: await MainActor.run {
            ModuleTestEntry.entries(for: ColorKit.self, tests: ColorKit.tests)
        }
    )
    @MainActor
    @available(iOS 13, macOS 12, tvOS 13, watchOS 6, *)
    func reusableColorTest(_ entry: ModuleTestEntry) async throws {
        try await entry.execute()
    }
}
#endif

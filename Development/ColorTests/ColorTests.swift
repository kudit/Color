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

/// Bridges each ordered Color test section into Swift Testing without duplicating the behavioral assertions.
@Suite("Color Tests")
struct ColorTestsSuite {
    /// Runs one reusable test while retaining its section name in Swift Testing's argument report.
    @Test(
        "Reusable Color test",
        .serialized,
        arguments: await MainActor.run {
            ColorKit.tests.flatMap { section, tests in
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

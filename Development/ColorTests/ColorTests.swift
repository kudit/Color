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
import CompatibilityTesting
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

/// Runs Compatibility's reusable module tests inside Color's existing package test target.
/// This keeps the app test plan focused on one test bundle while preserving the same named
/// test entries and coverage that Compatibility runs in its own test target.
@Suite("Compatibility Module Test Entries")
struct CompatibilityTestsSuite {
    /// Converts Compatibility's ordered reusable tests into individually reported Swift Testing cases.
    @Test(
        "Compatibility Module Test",
        arguments: await MainActor.run {
            ModuleTestEntry.entries(
                for: Compatibility.self,
                tests: Compatibility.tests
            )
        }
    )
    @MainActor
    @available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
    func moduleTest(entry: ModuleTestEntry) async throws {
        // Execute the framework-provided entry so Color and Compatibility share one test definition.
        try await entry.execute()
    }
}
#endif

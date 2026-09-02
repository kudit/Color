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

/// Bridges every registered module test entry into Swift Testing without duplicating assertions.
@Suite("Module Tests")
struct ColorTestsSuite {
    /// Runs one reusable module test while retaining its module and section in the argument report.
    @Test(
        "Reusable module test",
        .serialized,
        arguments: await ColorKit.testEntries()
    )
    @MainActor
    @available(iOS 13, macOS 12, tvOS 13, watchOS 6, *)
    func moduleTest(entry: ModuleTestEntry) async throws {
        // Swift Testing invokes this method once per argument; the adapter preserves the
        // original TestCase execution mode and reports the originating module and section.
        try await entry.execute()
    }
}
#endif

//
//  ColorUITests.swift
//  ColorUITests
//
#if canImport(XCTest)
import XCTest

/// Exercises the sample application through its public UI so app-level wiring is covered in addition
/// to the package's Swift Testing catalog.
final class ColorUITests: XCTestCase {
    private let tabs = [
        (name: "Demo", identifier: "color.demo"),
        (name: "Colorset", identifier: "color.colorset"),
        (name: "HSV", identifier: "color.hsv"),
        (name: "Pretty", identifier: "color.pretty"),
        (name: "Named CSS", identifier: "color.namedColors"),
        (name: "Tinting", identifier: "color.tinting"),
        (name: "Contrast", identifier: "color.contrast"),
        (name: "Coding", identifier: "color.coding"),
        (name: "Rainbow", identifier: "color.rainbow"),
        (name: "Radial Compatibility", identifier: "color.radialCompatibility"),
        (name: "All Tests", identifier: "color.allTests")
    ]
    /// Launches the demo, visits the representative Color screens, and verifies that the reusable
    /// module-test catalog is visible to users. Stable tab labels keep this test independent of layout.
    @MainActor
    func testColorDemoAndAllTestsScreen() async throws {
        let app = XCUIApplication()
        // Disable persisted tab selection so the test always starts at the demo screen and remains
        // deterministic when it is run repeatedly from Xcode or Command-U.
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchEnvironment["TESTING"] = "1"
        app.launch()

        for tab in tabs {
            let destination = app.descendants(matching: .any)[tab.identifier]
            let tabElement = try await visibleSidebarTab(named: tab.name, in: app)
            XCTAssertNotNil(tabElement, "The \(tab.name) tab should be visible in the sample app.")
            tabElement?.tap()
            let rendered = await waitForElement(destination, timeout: 10)
            XCTAssertTrue(rendered, "The \(tab.name) screen should render after selecting its tab.")
        }

        // The module heading is the user-visible proof that ColorKit's registered test catalog was
        // discovered and rendered rather than merely compiling in the test bundle.
        // macOS may expose SwiftUI's nested module heading outside the accessibility container attached
        // to the tab content, so search the complete tree for the versioned Color heading.
        let colorHeading = app.descendants(matching: .any).matching(
            NSPredicate(format: "label CONTAINS[c] %@ AND label CONTAINS[c] %@", "Color", "1.5")
        ).firstMatch
        let headingRendered = await waitForElement(colorHeading, timeout: 10)
        XCTAssertTrue(headingRendered, "The All Tests screen should display Color's module heading.")
    }

    /// Resolves sidebar destinations across macOS SwiftUI accessibility-role variations.
    @MainActor
    private func visibleSidebarTab(named name: String, in app: XCUIApplication) async throws -> XCUIElement? {
        let candidates = [app.buttons[name], app.staticTexts[name], app.descendants(matching: .any)[name]]
        for candidate in candidates where candidate.exists && candidate.isHittable { return candidate }
        let sidebar = app.outlines.firstMatch.exists ? app.outlines.firstMatch : app.scrollViews.firstMatch
        guard sidebar.exists else { return nil }
        for _ in 0..<3 {
            sidebar.swipeUp()
            try? await Task.sleep(nanoseconds: 150_000_000)
            for candidate in candidates where candidate.exists && candidate.isHittable { return candidate }
        }
        return nil
    }

    /// Polls without XCTest's blocking wait API, keeping UI-test diagnostics free of main-thread warnings.
    @MainActor
    private func waitForElement(_ element: XCUIElement, timeout: TimeInterval) async -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if element.exists { return true }
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        return element.exists
    }
}
#endif

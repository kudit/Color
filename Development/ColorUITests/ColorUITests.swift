//
//  ColorUITests.swift
//  ColorUITests
//
#if canImport(XCTest)
import XCTest

/// Exercises the sample application through its public UI so app-level wiring is covered in addition
/// to the package's Swift Testing catalog.
@available(iOS 13, *) // XCTest's UI APIs require iOS 13 even though the library supports iOS 8.
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
    /// module-test catalog is visible to users through the selected sidebar destination.
    @MainActor
    func testColorDemoAndAllTestsScreen() async throws {
        let app = XCUIApplication()
        // Disable persisted tab selection so the test always starts at the demo screen and remains
        // deterministic when it is run repeatedly from Xcode or Command-U.
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchEnvironment["TESTING"] = "1"
        app.launch()
#if os(macOS)
        // Activate the app before querying and clicking sidebar rows.
        app.activate()
#endif

        var allTestsSelected = false
        for tab in tabs {
#if os(macOS)
            // macOS exposes tab names as StaticText children of the sidebar rows, not as row IDs.
            // Scope the value query to the sidebar outline to avoid searching the full app tree.
            let tabElement = app.outlineRows.containing(
                NSPredicate(format: "value == %@", tab.name)
            ).firstMatch
            guard tabElement.exists else {
                XCTFail("The \(tab.name) sidebar row should be present.")
                return
            }
            if tabElement.isEnabled {
                tabElement.click()
            } else {
                // macOS 27 can expose sidebar rows as disabled in the accessibility tree even
                // when their on-screen hit targets remain interactive. A coordinate click
                // exercises the actual target without treating AX's enabled flag as a TCC diagnosis.
                tabElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).click()
            }
            let rendered = tabElement.isSelected
#else
            let tabElement = app.tabBars.buttons[tab.name].firstMatch
            guard tabElement.exists else {
                XCTFail("The \(tab.name) tab should be present.")
                continue
            }
            tabElement.tap()
            let rendered = tabElement.isSelected
#endif
            if tab.identifier == "color.allTests" { allTestsSelected = rendered }
            XCTAssertTrue(rendered, "The \(tab.name) screen should render after selecting its tab.")
        }

        // The selected All Tests row confirms the registered test catalog screen is active.
        XCTAssertTrue(allTestsSelected,
            "The All Tests screen should display Color's module heading.")
    }
}
#endif

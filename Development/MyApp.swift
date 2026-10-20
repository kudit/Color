#if canImport(SwiftUI)
import SwiftUI
#if canImport(Color) // since this is needed in XCode but is unavailable in Playgrounds.
import Color
#endif

// The SwiftUI App lifecycle starts at iOS/tvOS 14, macOS 11, and watchOS 7.
@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
@main
struct MyApp: App {
    init() {
        // Register the highest-level Color module once at startup so
        // Compatibility support reports include Color and its dependencies.
        Application.track(ColorKit.self)
    }

    var body: some Scene {
        WindowGroup {
            ColorTestView()
        }
    }
}

#if swift(>=5.9)
// README examples
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
#Preview("ColorTest") {
    ColorTestView()
}
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
#Preview("Demo") {
    SimpleDemoRainbowView()
}
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
#Preview("Rainbow Colors") {
    RadialStack {
        Group {
            ForEach([Color].rainbow, id: \.self) { color in
                Circle().fill(color)
            }
        }
        .frame(size: 80)
    }
}
#endif
#endif

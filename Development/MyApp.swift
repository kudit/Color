#if canImport(SwiftUI)
import SwiftUI
#if canImport(Color) // since this is needed in XCode but is unavailable in Playgrounds.
import Color
#endif

@available(iOS 15, macOS 12, tvOS 17, watchOS 8, *)
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ColorTestView()
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Spacer()
                        Text("Color v\(Color.version) © \(String(Date.now.year)) Kudit LLC").font(.caption) // (C\(Compatibility.version))
                    }.padding()
                }
        }
    }
}
#if swift(>=5.9)
// README examples
@available(iOS 13, macOS 11, tvOS 13, watchOS 7, *)
#Preview("ColorTest") {
    ColorTestView()
}
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Demo") {
    SimpleDemoRainbowView()
}
#endif
#endif

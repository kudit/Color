#if canImport(SwiftUI)
import SwiftUI
#if canImport(Color)
import Color
#endif
import Compatibility

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottomTrailing) {
#if os(watchOS) || os(tvOS)
                ScrollView {
                    ColorTestView()
                }
#else
                ColorTestView()
#endif
                Text("Color v\(Color.version) © 2024 Kudit LLC").font(.caption).padding().backport.foregroundStyle(.white)
            }
        }
    }
}
#if swift(>=5.9)
// README examples
#Preview("Demo") {
    SimpleDemoView()
}
#endif
#endif

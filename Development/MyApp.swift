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
            ColorTestView()
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Spacer()
                        Text("Color v\(Color.version) © 2024 Kudit LLC").font(.caption) // (C\(Compatibility.version))
                    }.padding()
                }
        }
    }
}
#if swift(>=5.9)
// README examples
#Preview("ColorTest") {
    ColorTestView()
}
#Preview("Demo") {
    SimpleDemoRainbowView()
}
#endif
#endif

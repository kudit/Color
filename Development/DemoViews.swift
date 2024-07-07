//
//  SimpleDemoView.swift
//  ParticleEffects
//
//  Created by Ben Ku on 5/8/24.
//

#if canImport(SwiftUI)
import SwiftUI
#if canImport(Color)
import Color
#endif

struct SimpleDemoView: View {
    var body: some View {
        List {
            ForEach([Color].rainbow) { color in
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Demo")
                    Spacer()
                }
                .foregroundColor(color)
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

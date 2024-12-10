//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`
    @MainActor
    public static var colorLogging = false

    @available(iOS 13, tvOS 13, watchOS 6, *)
    public var color: any KuColor {
        let type = KuColor.DefaultColorType.self
        switch self {
        case .OFF:
            return type.gray
        case .ERROR:
            return type.red
        case .WARNING:
            return type.yellow
        case .NOTICE:
            return type.blue
        case .DEBUG:
            return type.green
        case .SILENT: // should not typically be used
            return type.black
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, tvOS 13, watchOS 6, *)
public extension Color {
    /// Use this instead of .accentColor so that the color actually appears in tvOS and can properly be used.
    static var accentColorAsset: Color {
#if os(tvOS)
        Color("AccentColor")
#else
        .accentColor
#endif
    }
}

@available(iOS 13, tvOS 13, watchOS 6, *)
#Preview {
    Color.brownBackport
}


@available(iOS 13, tvOS 13, watchOS 6, *)
public extension Backport where Content: View {
    /// Adds an action to perform when this view recognizes a tap gesture.
    ///
    /// Use this method to perform the specified `action` when the user clicks
    /// or taps on the view or container `count` times.
    ///
    /// > Note: If you create a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// In the example below, the color of the heart images changes to a random
    /// color from the `colors` array whenever the user clicks or taps on the
    /// view twice:
    ///
    ///     struct TapGestureExample: View {
    ///         let colors: [Color] = [.gray, .red, .orange, .yellow,
    ///                                .green, .blue, .purple, .pink]
    ///         @State private var fgColor: Color = .gray
    ///
    ///         var body: some View {
    ///             Image(systemName: "heart.fill")
    ///                 .resizable()
    ///                 .frame(width: 200, height: 200)
    ///                 .foregroundColor(fgColor)
    ///                 .onTapGesture(count: 2) {
    ///                     fgColor = colors.randomElement()!
    ///                 }
    ///         }
    ///     }
    ///
    /// ![A screenshot of a view of a heart.](SwiftUI-View-TapGesture.png)
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - action: The action to perform.
    func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        Group {
            if #available(iOS 14, macOS 11, tvOS 16, watchOS 7, *) {
                content.onTapGesture(count: count, perform: action)
            } else if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
                // Fallback on earlier versions
                content.onLongPressGesture(minimumDuration: 0.01, pressing: { _ in }) {
                    action()
                }
            } else {
                // Fallback on earlier versions
                // ignore for earlier tvOS since we won't be supporting tvOS <17 realistically anyways.
                content
            }
        }
    }
}

#endif



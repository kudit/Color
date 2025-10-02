//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if (os(WASM) || os(WASI))
/// Backport of main that does nothing since threads are not supported on WASM
public func main(_ closure: @Sendable @escaping () -> Void) {
    closure()
}
#endif



public extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`
#if !(os(WASM) || os(WASI))
    @MainActor
#endif
    static var colorLogging = false

    @available(iOS 13, tvOS 13, watchOS 6, *)
    var color: any KuColor {
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

#endif



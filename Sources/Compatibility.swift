//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if (os(WASM) || os(WASI))
#if canImport(WASILibc) // either include from library or use fallback implementation
import WASILibc
#else
public func floor(_ value: Double) -> Int {
    return value >= 0 ? Int(value) : Int(value) - 1
}
#endif
#endif


public extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`
#if !(os(WASM) || os(WASI))
    @MainActor
#endif
    static var colorLogging = false

#if !(os(WASM) || os(WASI))
    // TODO: Change this to generic type matching protocol instead of boxed any type?
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
#else
    var color: Color {
        switch self {
        case .OFF:
            return .gray
        case .ERROR:
            return .red
        case .WARNING:
            return .yellow
        case .NOTICE:
            return .blue
        case .DEBUG:
            return .green
        case .SILENT: // should not typically be used
            return .black
        }
    }
#endif
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



//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if compiler(>=6.0) && canImport(Synchronization)
import Synchronization
private let colorLoggingState = Mutex(false)
#endif

public extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`.
    ///
    /// Swift 6 uses `Synchronization.Mutex` so synchronous color parsing can read this
    /// configuration from any actor without making the parsing APIs MainActor-isolated.
#if compiler(>=6.0) && canImport(Synchronization)
    static var colorLogging: Bool {
        get { colorLoggingState.withLock { $0 } }
        set { colorLoggingState.withLock { $0 = newValue } }
    }
#elseif compiler(>=6.0)
    // Compatibility fallback for Swift 6 toolchains that do not ship Synchronization.
    // Current supported Swift 6 toolchains use the mutex-backed implementation above.
    nonisolated(unsafe) static var colorLogging = false
#else
    static var colorLogging = false
#endif

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


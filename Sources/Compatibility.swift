//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if compiler(>=6.0) && canImport(Synchronization)
import Synchronization

// Protect the synchronous logging preference without imposing MainActor isolation on color parsing.
@available(iOS 18, macOS 15, tvOS 18, watchOS 11, visionOS 2, *)
private let colorLoggingState = Mutex(false)
#endif
#if compiler(>=6.0)
// Provide a synchronous fallback for Swift 6 runtimes older than Mutex's platform availability.
private nonisolated(unsafe) var colorLoggingFallback = false
#endif

public extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`.
    ///
    /// Swift 6 uses `Synchronization.Mutex` where available, allowing synchronous parsing
    /// to read this setting safely from any actor without requiring `main { ... }` wrappers.
#if compiler(>=6.0) && canImport(Synchronization)
    static var colorLogging: Bool {
        get {
            if #available(iOS 18, macOS 15, tvOS 18, watchOS 11, visionOS 2, *) {
                return colorLoggingState.withLock { $0 }
            }
            return colorLoggingFallback
        }
        set {
            if #available(iOS 18, macOS 15, tvOS 18, watchOS 11, visionOS 2, *) {
                colorLoggingState.withLock { $0 = newValue }
            } else {
                colorLoggingFallback = newValue
            }
        }
    }
#elseif compiler(>=6.0)
    // Preserve synchronous access on Swift 6 platforms without the Synchronization module.
    // These older toolchains lack the mutex primitive, so the unchecked storage is the compatible fallback.
    nonisolated(unsafe) static var colorLogging = false
#else
    static var colorLogging = false
#endif

    // TODO: Change this to generic type matching protocol instead of boxed any type?
	@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
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

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
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

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
#Preview {
    Color.brownBackport
}

#endif

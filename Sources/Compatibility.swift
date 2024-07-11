//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

import Foundation

import Compatibility

extension DebugLevel {
    /// Set this to `true` to log failed color parsing notices when returning `nil`
    @MainActor
    public static var colorLogging = false

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
#Preview {
    Color.brown
}
#endif

//
//  File.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

import Foundation

#if canImport(Compatiblity)
import Compatibility

extension DebugLevel {
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
#endif

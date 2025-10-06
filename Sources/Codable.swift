//
//  Codable.swift
//  Color
//
//  Created by Ben Ku on 11/3/24.
//

#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(Foundation) && !(os(WASM) || os(WASI))
public extension KuColor {
    // MARK: Codable
    // Kudit Codable conformance (simplified) based off of
    //https://gist.github.com/ConfusedVorlon/276bd7ac6c41a99ea0514a34ee9afc3d?permalink_comment_id=4096859#gistcomment-4096859
    init(from decoder: Decoder) throws {
//        debug("INITING COLOR FROM DECODER…")
        if let data = try? Data(from: decoder) {
//            debug("Found data")
            // likely data representation of UIColor
#if canImport(UIKit)
            guard let color = UIColor(data) else {
                throw DecodingError.dataCorruptedError(
                    in: try decoder.singleValueContainer(),
                    debugDescription: "Invalid Color Data"
                )
            }
            //        let data = try container.decode(Data.self)
            //        guard let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            //            throw DecodingError.dataCorruptedError(
            //                in: container,
            //                debugDescription: "Invalid color"
            //            )
            //        }
            //        wrappedValue = color
            //
            //        else if let data = try? UIColor
            //        } else if let data = try? Data(from: decoder), let uiColor = UIColor(data)
            //
            //        }
            
            // convert in case this is actually a SwiftUI Color initing from a UIColor as in ShoutIt legacy data
            self.init(color: color)
            return
#else
            throw DecodingError.dataCorruptedError(
                in: try decoder.singleValueContainer(),
                debugDescription: "Decoding color from data is not supported without UIKit."
            )
#endif
        } else if let string = try? String(from: decoder) {
//            debug("Decoded string: \(string)")
            guard let color = Self(string: string) else {
                debug("Unable to decode color string: \(string)", level: .WARNING)
                throw DecodingError.dataCorruptedError(
                    in: try decoder.singleValueContainer(),
                    debugDescription: "Invalid Color String \"\(string)\""
                )
            }
            self.init(color: color)
            return
        } else {
            debug("Could not decode color")
            throw DecodingError.dataCorruptedError(
                in: try decoder.singleValueContainer(),
                debugDescription: "Could not decode Color"
            )
        }
        //        self.init(string: string)!
        // TODO: check to see if we can value decode this?  • Unable to decode Color data: Foundation.(unknown context at $181152d90).JSONDecoderImpl
        //decoder.singleValueContainer().decode()
//        debug("Unalbe to decode Color data: \(String(describing: decoder))")
//        throw CustomError("Unable to decode Color data: \(String(describing: decoder))")
    }
    
    // for coding
    func encode(to encoder: Encoder) throws {
        try stringValue.encode(to: encoder)
    }
}

#if compiler(>=5.9) && canImport(Combine)
@available(iOS 13, tvOS 13, watchOS 6, *)
extension CloudStorage where Value: KuColor {
    public init(wrappedValue: Value, _ key: String) {
        self.init(
            keyName: key,
            syncGet: { Value(string: CloudStorageSync.shared.string(for: key), defaultColor: wrappedValue) },
            syncSet: { newValue in CloudStorageSync.shared.set(newValue.stringValue, for: key) })
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
public struct CodingDemoView: View {
    @State private var jsonString: String = ([Color(string: "rgba(255,57,46,0.3)", defaultColor: .black),.accentColor,.primary,.secondary,.background,]+[Color].rainbow).asJSON()
    public init() {
        // TODO: #warning("Extract this into tests")
//        let testMap = [
//            "transparentWhite": Color.white.opacity(0.9),
//            "rgbWhite": Color(red: 1, green: 1, blue: 1, opacity: 1),
//            "systemWhite": Color.white,
//            "fixedWhite": Color.whiteFixed,
//            "nearlyWhite": Color(red: 1, green: 1, blue: 1, opacity: 0.9),
//        ]
//        var tested = [String]()
//        for (key, value) in testMap {
//            tested += [key]
//            for (altKey, altValue) in testMap {
//                guard !tested.contains(altKey) else {
//                    continue
//                }
//                debug("Equality test \(key)(\(value.pretty)) == \(altKey)(\(altValue.pretty)): \(value.pretty == altValue.pretty)")
//            }
//        }
//        debug("Initial STRING: \(Color.red.pretty)")
//        #warning("REMOVE after determining why this outputs a hex string instead of pretty.  Need to add custom string convertible.")
    }
    public var colors: [Color] {
        guard let colors = try? [Color](fromJSON: jsonString) else {
            return .dotColors
        }
        return colors
    }
    public var colorStrings: [String] {
        guard let colors = try? [String](fromJSON: jsonString) else {
            return [Color].dotColors.map(\.stringValue)
        }
        return colors
    }
    public var body: some View {
        List {
            TextField("JSON String", text: $jsonString)
                .disableSmartQuotes() // prevent converting quotes to "smart" quotes which breaks parsing.
            Text("RoundTripped: \(colors.asJSON())")
            ForEach(colors, id: \.self) { color in
                PrettySwatch(source: color.stringValue)
            }
//            ForEach(colorStrings, id: \.self) { colorString in
//                PrettySwatch(source: colorString)
//            }
        }
    }
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Coding") {
    CodingDemoView()
}
#endif
#endif

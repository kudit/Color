//
//  CSSColors.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

// MARK: - CSS/String intialization
import Compatibility

public extension KuColor {
    // MARK: Parsing and Rendering
    static var namedColorMap: [String:String] {[
        "AliceBlue":"#F0F8FF",
        "AntiqueWhite":"#FAEBD7",
        "Aqua":"#00FFFF",
        "Aquamarine":"#7FFFD4",
        "Azure":"#F0FFFF",
        "Beige":"#F5F5DC",
        "Bisque":"#FFE4C4",
        "Black":"#000000",
        "BlanchedAlmond":"#FFEBCD",
        "Blue":"#0000FF",
        "BlueViolet":"#8A2BE2",
        "Brown":"#A52A2A",
        "BurlyWood":"#DEB887",
        "CadetBlue":"#5F9EA0",
        "Chartreuse":"#7FFF00",
        "Chocolate":"#D2691E",
        "Coral":"#FF7F50",
        "CornflowerBlue":"#6495ED",
        "Cornsilk":"#FFF8DC",
        "Crimson":"#DC143C",
        "Cyan":"#00FFFF",
        "DarkBlue":"#00008B",
        "DarkCyan":"#008B8B",
        "DarkGoldenRod":"#B8860B",
        "DarkGray":"#A9A9A9",
        "DarkGreen":"#006400",
        "DarkKhaki":"#BDB76B",
        "DarkMagenta":"#8B008B",
        "DarkOliveGreen":"#556B2F",
        "DarkOrange":"#FF8C00",
        "DarkOrchid":"#9932CC",
        "DarkRed":"#8B0000",
        "DarkSalmon":"#E9967A",
        "DarkSeaGreen":"#8FBC8F",
        "DarkSlateBlue":"#483D8B",
        "DarkSlateGray":"#2F4F4F",
        "DarkTurquoise":"#00CED1",
        "DarkViolet":"#9400D3",
        "DeepPink":"#FF1493",
        "DeepSkyBlue":"#00BFFF",
        "DimGray":"#696969",
        "DodgerBlue":"#1E90FF",
        "FireBrick":"#B22222",
        "FloralWhite":"#FFFAF0",
        "ForestGreen":"#228B22",
        "Fuchsia":"#FF00FF",
        "Gainsboro":"#DCDCDC",
        "GhostWhite":"#F8F8FF",
        "Gold":"#FFD700",
        "GoldenRod":"#DAA520",
        "Gray":"#808080",
        "Green":"#008000",
        "GreenYellow":"#ADFF2F",
        "HoneyDew":"#F0FFF0",
        "HotPink":"#FF69B4",
        "IndianRed":"#CD5C5C",
        "Indigo":"#4B0082",
        "Ivory":"#FFFFF0",
        "Khaki":"#F0E68C",
        "Lavender":"#E6E6FA",
        "LavenderBlush":"#FFF0F5",
        "LawnGreen":"#7CFC00",
        "LemonChiffon":"#FFFACD",
        "LightBlue":"#ADD8E6",
        "LightCoral":"#F08080",
        "LightCyan":"#E0FFFF",
        "LightGoldenRodYellow":"#FAFAD2",
        "LightGray":"#D3D3D3",
        "LightGreen":"#90EE90",
        "LightPink":"#FFB6C1",
        "LightSalmon":"#FFA07A",
        "LightSeaGreen":"#20B2AA",
        "LightSkyBlue":"#87CEFA",
        "LightSlateGray":"#778899",
        "LightSteelBlue":"#B0C4DE",
        "LightYellow":"#FFFFE0",
        "Lime":"#00FF00",
        "LimeGreen":"#32CD32",
        "Linen":"#FAF0E6",
        "Magenta":"#FF00FF",
        "Maroon":"#800000",
        "MediumAquaMarine":"#66CDAA",
        "MediumBlue":"#0000CD",
        "MediumOrchid":"#BA55D3",
        "MediumPurple":"#9370DB",
        "MediumSeaGreen":"#3CB371",
        "MediumSlateBlue":"#7B68EE",
        "MediumSpringGreen":"#00FA9A",
        "MediumTurquoise":"#48D1CC",
        "MediumVioletRed":"#C71585",
        "MidnightBlue":"#191970",
        "MintCream":"#F5FFFA",
        "MistyRose":"#FFE4E1",
        "Moccasin":"#FFE4B5",
        "NavajoWhite":"#FFDEAD",
        "Navy":"#000080",
        "OldLace":"#FDF5E6",
        "Olive":"#808000",
        "OliveDrab":"#6B8E23",
        "Orange":"#FFA500",
        "OrangeRed":"#FF4500",
        "Orchid":"#DA70D6",
        "PaleGoldenRod":"#EEE8AA",
        "PaleGreen":"#98FB98",
        "PaleTurquoise":"#AFEEEE",
        "PaleVioletRed":"#DB7093",
        "PapayaWhip":"#FFEFD5",
        "PeachPuff":"#FFDAB9",
        "Peru":"#CD853F",
        "Pink":"#FFC0CB",
        "Plum":"#DDA0DD",
        "PowderBlue":"#B0E0E6",
        "Purple":"#800080",
        "RebeccaPurple":"#663399",
        "Red":"#FF0000",
        "RosyBrown":"#BC8F8F",
        "RoyalBlue":"#4169E1",
        "SaddleBrown":"#8B4513",
        "Salmon":"#FA8072",
        "SandyBrown":"#F4A460",
        "SeaGreen":"#2E8B57",
        "SeaShell":"#FFF5EE",
        "Sienna":"#A0522D",
        "Silver":"#C0C0C0",
        "SkyBlue":"#87CEEB",
        "SlateBlue":"#6A5ACD",
        "SlateGray":"#708090",
        "Snow":"#FFFAFA",
        "SpringGreen":"#00FF7F",
        "SteelBlue":"#4682B4",
        "Tan":"#D2B48C",
        "Teal":"#008080",
        "Thistle":"#D8BFD8",
        "Tomato":"#FF6347",
        "Turquoise":"#40E0D0",
        "Violet":"#EE82EE",
        "Wheat":"#F5DEB3",
        "White":"#FFFFFF",
        "WhiteSmoke":"#F5F5F5",
        "Yellow":"#FFFF00",
        "YellowGreen":"#9ACD32"]}
    
    /**
     KF: Creates a Color from the given string in #HEX format, named CSS string, rgb(), or rgba() format.  Important to have named parameter string: to differentiate from SwiftUI Color(_:String) init for a named color in an asset bundle.
     
     - Parameter string: The string to be converted.
     
     - Returns: A new color or`nil` if we cannot parse the string.
     */
    init?(string: String) {
        var source = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if source.contains("#") {
            // decode hex
            source = source.removing(characters: "#").uppercased()
            
            // String should be 6 or 3 characters
            guard source.count == 6 || source.count == 3 else {
                main {
                    debug("Unknown color string: \(string)", level: DebugLevel.colorLogging ? .WARNING : .SILENT)
                }
                return nil
            }
            let shortForm = (source.count == 3)
            
            // Separate into r, g, b substrings
            var range = NSRange(location: 0, length: (shortForm == true ? 1 : 2))
            var rString = source.substring(with: range)
            range.location += range.length
            var gString = source.substring(with: range)
            range.location += range.length
            var bString = source.substring(with: range)
            
            // expand short form
            if shortForm {
                rString += rString
                gString += gString
                bString += bString
            }
            
            // Scan values
            var r: UInt64 = 0
            var g: UInt64 = 0
            var b: UInt64 = 0
            Scanner(string: rString).scanHexInt64(&r)
            Scanner(string: gString).scanHexInt64(&g)
            Scanner(string: bString).scanHexInt64(&b)
            
            self.init(red: Double(r)/255.0, green: Double(g)/255.0, blue: Double(b)/255.0, alpha: 1.0)
        } else if source.contains("rgba(") || source.contains("rgb(") {
            // css rgb color style
            let includesAlpha = string.contains("rgba(")
            
            // decode RGBA
            source = source.replacingOccurrences(of: ["rgba(","rgb(",")"," "], with: "")
            
            // Separate into components by removing commas and spaces
            let components = source.components(separatedBy: ",")
            if (components.count != 4 && includesAlpha) || (components.count != 3 && !includesAlpha) {
                main {
                    debug("Invalid color string: \(string)", level: DebugLevel.colorLogging ? .DEBUG : .SILENT)
                }
                return nil
            }
            
            let componentValues = components.map { Double($0) }

//            debug("Strings: \(components)\nDoubles: \(componentValues)")
            
            // make sure cast succeeded
            for value in componentValues {
                guard value != nil else {
                    main {
                        debug("Could not parse rgb value: \(string)", level: DebugLevel.colorLogging ? .DEBUG : .SILENT)
                    }
                    return nil
                }
            }
            
            // Create the color
            var alphaValue:Double = 1.0
            if includesAlpha {
                // componentValues[3] may be nil if Double(stringValue) didn't parse properly
                guard let componentAlpha = componentValues[3] else {
                    main {
                        debug("Could not parse alpha value: \(components[3]) (original string: \(string)", level: !DebugLevel.colorLogging ? .SILENT : .DEBUG)
                    }
                    return nil
                }
//                debug("Component Alpha: \(componentAlpha)")
                alphaValue = componentAlpha
            }
            // determine if 0—1 double value or a 255 number
            if components[0].contains(".") || components[1].contains(".") || components[2].contains(".") {
                self.init(red: Double(componentValues[0]!),
                          green: Double(componentValues[1]!),
                          blue: Double(componentValues[2]!),
                          alpha: alphaValue)
            } else {
                self.init(red: Double(componentValues[0]!)/255.0,
                          green: Double(componentValues[1]!)/255.0,
                          blue: Double(componentValues[2]!)/255.0,
                          alpha: alphaValue)
            }
            // convert to dynamic/symantic representation if this is one
            for (dynamic, fixed) in Self.fixedMap {
                if fixed.pretty == self.pretty {
                    self = dynamic as! Self
                    return
                }
            }
        } else {
            // check for HTML/CSS named colors.
            // might be a CSS color string
            for (colorName, hex) in Self.namedColorMap {
                if colorName.lowercased() == source { // source is already lowercased above
                    self.init(string: hex)
                    return
                }
            }
            main {
                debug("Unknown named color: \(string)", level: !DebugLevel.colorLogging ? .SILENT : .NOTICE)
            }
            return nil
        }
    }
    
    /// Returns a string in the form rgba(R,G,B,A) (should be URL safe as well). Will drop the alpha if it is 1.0 and do rgb(R,G,B) in double numbers from 0 to 255.
    var cssString: String {
        let components = rgbaComponents
        let eightBits = "\(Int(components.red*255.0)),\(Int(components.green*255.0)),\(Int(components.blue*255.0))"
        // the way alpha is stored, "0.2" could end up "0.20000000298023224" which is wrong.  This does mean that cannot have more than 7 digits of precision, but typically alpha values will be nice numbers so probably okay in practice.
        let fixedAlpha = Double(components.alpha).precision(7)
//        debug("Alpha: \(components.alpha) -> fixed:\(fixedAlpha)")
        let opaque = fixedAlpha == 1.0
        let alphaComponentString = opaque ? "" : ",\(fixedAlpha)"
        let string = "rgb\(opaque ? "" : "a")(\(eightBits)\(alphaComponentString))"
        return string
    }
    
    var hexString: String {
        let components = rgbaComponents
        var r = components.red
        var g = components.green
        var b = components.blue
        
        // Fix range if needed
        if r < 0.0 { r = 0.0 }
        if g < 0.0 { g = 0.0 }
        if b < 0.0 { b = 0.0 }
        
        if r > 1.0 { r = 1.0 }
        if g > 1.0 { g = 1.0 }
        if b > 1.0 { b = 1.0 }
        
        // Convert to hex string between 0x00 and 0xFF (rounding so very close to FF goes to FF rather than being floored to FE).
        return String(format: "#%02X%02X%02X", Int(round(r * 255.0)), Int(round(g * 255.0)), Int(round(b * 255.0)))
    }
    /// Returns the "nicest" version of the color that we can.  If there is a named color, we use that.  If HEX is available, use that, otherwise, use rgb or rgba versions if there is extended color space or alpha..
    var pretty: String {
        // this will fail if we're using an extended color space...
        // alpha, convert to hex and make sure converting back gets the same numbers (otherwise, it's probably an extended color space).  Also make sure that the color accuracy works with 256 mapping otherwise we want to use css for the increased fidelity.
        guard alphaComponent == 1.0, let hexColor = Self(string: hexString), hexColor.cssString == self.cssString else {
//            debug("Unable to convert color \(self) to hexString \(self.hexString) and back.", level: .ERROR)
            return cssString
        }
        // if we get here, we have a simple hex string.  If this happens to be a named color, use that instead of the hex for clarity and human readability.
        // we should show named color names if available
        if let colorName = Self.namedColorMap.firstKey(for: hexString) {
            return colorName
        } else {
            return hexString
        }
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Coding") {
    CodingDemoView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Named Colors") {
    NamedColorsListTestView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Pretty Text") {
    ColorPrettyTestView()
}
#endif

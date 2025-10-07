//
//  Color.swift
//  
//
//  Created by Ben Ku on 9/26/16.
//  Copyright © 2016 Kudit, LLC. All rights reserved.
//

@available(iOS 13, tvOS 13, watchOS 6, *)
public extension Color {
    /// The version of the Color Library since cannot get directly from Package.swift.
    static let version: Version = "1.3.20"
}
@_exported import Compatibility

// http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/

// have to define context for WASM 6.2 and we suspect CGFloat is unavailable in 6.2 due to errors.
#if ((os(WASM) || os(WASI)) || !canImport(CoreGraphics)) && compiler(>=6.2)
// Make sure CGFloat is available
public typealias CGFloat = Double
#endif

// DoubleConvertible may not be implemented in CGFloat if the architecture doesn't use a Double underlying.  This guarantees that CGFloat conforms.
#if canImport(Foundation) && compiler(>=6.0)
extension CGFloat: @retroactive DoubleConvertible {}
#else
extension CGFloat: DoubleConvertible {}
#endif
public extension CGFloat {
    var doubleValue: Double {
        return Double(self)
    }
}

public extension CGFloat {
    static let zero = CGFloat(0.0)
    static let one = CGFloat(1.0)
    static let dynamicAlpha = CGFloat(0.999998)
    static let symanticAlpha = CGFloat(0.999997)
    
    /// Snaps the value to the range 0.0—1.0
    var snapped: CGFloat {
        if self < 0.0 { return 0.0 }
        if self > 1.0 { return 1.0 }
        return self
    }
    
    /// Scales a 0.0->1.0 value to an integer between 0 and 255
    var hexIntSnapped: Int {
        return Int((Double(self.snapped) * .eightBits).rounded())
    }
}

public extension Double {
    static let eightBits = 255.0
}

public extension UInt64 {
    var eightBitToDouble: Double {
        return Double(self) / .eightBits
    }
}

// Does conform to Identifiable but can't add for older iOS    @available(iOS 13, tvOS 13, watchOS 6, *)
// Conforms to Codable and Comparable but can't add here due to Xcode 16 warnings.  Must add anywhere we conform to KuColor.
public protocol KuColor: Equatable, Hashable {
    /// usually 0-1 double values but SwiftUI supports extended colors beyond 0-1 for extended color spaces.
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
    func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
    func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
    func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool
        
    // named colors
    associatedtype UnderlyingColorType: KuColor // cannot use Self because UIColor is non-final.  But apparently Swift compiler can infer this type without having to manually define it! :)
    static var black: UnderlyingColorType { get }
    static var blue: UnderlyingColorType { get }
    // availability is primarily for SwiftUI Color availability.  NSColor and UIColor are custom defined so technically can be available earlier.
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    static var brown: UnderlyingColorType { get }
    static var brownBackport: UnderlyingColorType { get }
    static var clear: UnderlyingColorType { get }
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    static var cyan: UnderlyingColorType { get }
    static var cyanBackport: UnderlyingColorType { get }
    static var gray: UnderlyingColorType { get }
    static var green: UnderlyingColorType { get }
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    static var indigo: UnderlyingColorType { get }
    static var indigoBackport: UnderlyingColorType { get }
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    static var mint: UnderlyingColorType { get }
    static var mintBackport: UnderlyingColorType { get }
    static var orange: UnderlyingColorType { get }
    static var pink: UnderlyingColorType { get }
    static var purple: UnderlyingColorType { get }
    static var red: UnderlyingColorType { get }
    @available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
    static var teal: UnderlyingColorType { get }
    static var tealBackport: UnderlyingColorType { get }
    static var white: UnderlyingColorType { get }
    static var yellow: UnderlyingColorType { get }
    // Kudit Added
    static var magenta: UnderlyingColorType { get }
    static var lightGray: UnderlyingColorType { get }
    static var darkGray: UnderlyingColorType { get }
    // Symantic Colors
    @available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
    static var accentColor: UnderlyingColorType { get }
    static var accentColorBackport: UnderlyingColorType { get }
    @available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
    static var primary: UnderlyingColorType { get }
    static var primaryBackport: UnderlyingColorType { get }
    @available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
    static var secondary: UnderlyingColorType { get }
    static var secondaryBackport: UnderlyingColorType { get }
    /// will typically be a contrasting color to the primary color (if primary is white, should be black, if black should be white).
    static var background: UnderlyingColorType { get }
}

// the LosslessStringConvertible extension does not work for KuColor since a color may be initialized by a string but the corresponding unlabelled init function is not the one we want since it returns an optional.
public extension KuColor {
    init(string: String?, defaultColor: Self) {
        guard let string else {
            self = defaultColor
            return
        }
        guard let color = Self(string: string) else {
            self = defaultColor
            return
        }
        self = color
    }
    
    /// Returns `self` as the `UnderlyingColorType` (typically for internal usage).
    var underlying: UnderlyingColorType {
        return self as! UnderlyingColorType // should always succeed...
    }

    /// Returns `self` as `Self` type  (Used for initializing colors when converting a fixed version match to the dynamic/symantic variant and for conditional logic when dealing with dynamic/symantic colors.)
    var symantic: Self? {
        // convert to dynamic/symantic representation if this is one
        for (symantic, fixed) in Self.fixedMap {
            if fixed.stringValue == self.stringValue {
                return symantic as? Self
            }
        }
        return nil
    }
    
    // Fallback color values for platforms that don't support colors or symantic colors
    static var blackFixed: Self { Self(red: .zero, green: .zero, blue: .zero, alpha: .one) }
    static var blueFixed: Self { Self(red: .zero, green: 112/255, blue: .one, alpha: .dynamicAlpha) }
    static var brownFixed: Self { Self(red: 162/255, green: 132/255, blue: 94/255, alpha: .dynamicAlpha) }
    static var clearFixed: Self { Self(red: .zero, green: .zero, blue: .zero, alpha: .zero)}
    static var cyanFixed: Self { Self(red: 50/255, green: 173/255, blue: 230/255, alpha: .dynamicAlpha)}
    static var grayFixed: Self { Self(red: 142/255, green: 142/255, blue: 147/255, alpha: .dynamicAlpha)}
    static var lightGrayFixed: Self { Self(red: 203/255, green: 203/255, blue: 204/255, alpha: .dynamicAlpha)}
    static var darkGrayFixed: Self { Self(red: 81/255, green: 81/255, blue: 82/255, alpha: .dynamicAlpha)}
    static var greenFixed: Self { Self(red: 52/255, green: 199/255, blue: 89/255, alpha: .dynamicAlpha)}
    static var indigoFixed: Self { Self(red: 88/255, green: 86/255, blue: 214/255, alpha: .dynamicAlpha)}
    static var magentaFixed: Self { Self(red: .one, green: .zero, blue: .one, alpha: .dynamicAlpha)}
    static var mintFixed: Self { Self(red: .zero, green: 199/255, blue: 190/255, alpha: .dynamicAlpha)}
    static var orangeFixed: Self { Self(red: .one, green: 149/255, blue: .zero, alpha: .dynamicAlpha)}
    static var pinkFixed: Self { Self(red: .one, green: 45/255, blue: 85/255, alpha: .dynamicAlpha)}
    static var purpleFixed: Self { Self(red: 175/255, green: 82/255, blue: 222/255, alpha: .dynamicAlpha)}
    static var redFixed: Self { Self(red: .one, green: 59/255, blue: 48/255, alpha: .dynamicAlpha)}
    static var tealFixed: Self { Self(red: 48/255, green: 176/255, blue: 199/255, alpha: .dynamicAlpha)}
    static var whiteFixed: Self { Self(red: .one, green: .one, blue: .one, alpha: .one)}
    static var yellowFixed: Self { Self(red: .one, green: 204/255, blue: .zero, alpha: .dynamicAlpha)}
    static var accentColorFixed: Self { Self(red: .zero, green: 112/255, blue: .one, alpha: .symanticAlpha) }
    static var primaryFixed: Self { Self(red: .zero, green: .zero, blue: .zero, alpha: .symanticAlpha)}
    static var secondaryFixed: Self { Self(red: 81/255, green: 81/255, blue: 82/255, alpha: .symanticAlpha)}
    static var backgroundFixed: Self { Self(red: .one, green: .one, blue: .one, alpha: .symanticAlpha)}

    static var fixedMap: [UnderlyingColorType: Self] {
        [
            Self.black: .blackFixed,
            Self.blue: .blueFixed,
            Self.brownBackport: .brownFixed,
            Self.clear: .clearFixed,
            Self.cyanBackport: .cyanFixed,
            Self.gray: .grayFixed,
            Self.lightGray: .lightGrayFixed,
            Self.darkGray: .darkGrayFixed,
            Self.green: .greenFixed,
            Self.indigoBackport: .indigoFixed,
            Self.magenta: .magentaFixed,
            Self.mintBackport: .mintFixed,
            Self.orange: .orangeFixed,
            Self.pink: .pinkFixed,
            Self.purple: .purpleFixed,
            Self.red: .redFixed,
            Self.tealBackport: .tealFixed,
            Self.white: .whiteFixed,
            Self.yellow: .yellowFixed,
            Self.accentColorBackport: .accentColorFixed,
            Self.primaryBackport: .primaryFixed,
            Self.secondaryBackport: .secondaryFixed,
            Self.background: .backgroundFixed,
        ]
    }
    
    static var swiftNameMap: [UnderlyingColorType: String] {
        [
            Self.black: "black",
            Self.blue: "blue",
            Self.brownBackport: "brown",
            Self.clear: "clear",
            Self.cyanBackport: "cyan",
            Self.gray: "gray",
            Self.lightGray: "lightGray",
            Self.darkGray: "darkGray",
            Self.green: "green",
            Self.indigoBackport: "indigo",
            Self.magenta: "magenta",
            Self.mintBackport: "mint",
            Self.orange: "orange",
            Self.pink: "pink",
            Self.purple: "purple",
            Self.red: "red",
            Self.tealBackport: "teal",
            Self.white: "white",
            Self.yellow: "yellow",
            Self.accentColorBackport: "accentColor",
            Self.primaryBackport: "primary",
            Self.secondaryBackport: "secondary",
            Self.background: "background",
        ]
    }

    static var brownBackport: UnderlyingColorType {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
            Self.brown
        } else {
            // Fallback on earlier versions
            .brownFixed
        }
    }

    static var cyanBackport: UnderlyingColorType {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
            Self.cyan
        } else {
            // Fallback on earlier versions
            .cyanFixed
        }
    }
    
    static var indigoBackport: UnderlyingColorType {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
            Self.indigo
        } else {
            // Fallback on earlier versions
            .indigoFixed
        }
    }
    
    static var mintBackport: UnderlyingColorType {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
            Self.mint
        } else {
            // Fallback on earlier versions
            .mintFixed
        }
    }
    
    static var tealBackport: UnderlyingColorType {
        if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
            Self.teal
        } else {
            // Fallback on earlier versions
            .tealFixed
        }
    }

    static var accentColorBackport: UnderlyingColorType {
        if #available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *) {
            Self.accentColor
        } else {
            // Fallback on earlier versions
            .accentColorFixed
        }
    }
    static var primaryBackport: UnderlyingColorType {
        if #available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *) {
            Self.primary
        } else {
            // Fallback on earlier versions
            .primaryFixed
        }
    }
    static var secondaryBackport: UnderlyingColorType {
        if #available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *) {
            Self.secondary
        } else {
            .secondaryFixed
        }
    }

    /// conversion from HSB to RGB
    static func convert(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if saturation == 0 { return (brightness, brightness, brightness) } // Achromatic grey
        
        let angle = (hue >= 360 ? 0 : hue)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i.doubleValue // Factorial part of h // need doubleValue for WASM
        
        let p = brightness * (1 - saturation)
        let q = brightness * (1 - (saturation * f))
        let t = brightness * (1 - (saturation * (1 - f)))
        
        switch(i) {
        case 0:
            return (brightness, t, p)
        case 1:
            return (q, brightness, p)
        case 2:
            return (p, brightness, t)
        case 3:
            return (p, q, brightness)
        case 4:
            return (t, p, brightness)
        default:
            return (brightness, p, q)
        }
    }
    
    static func convert(red: CGFloat, green: CGFloat, blue: CGFloat) -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        //hsb.saturation = 1.0
        //_ = getWhite(&hsb.brightness, alpha: nil)
        
        // attempt to convert from RGBA
        // based off of https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce
        let r = red
        let g = green
        let b = blue
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        
        let v = max
        let delta = max - min
        
        guard delta > 0.00001 else {
            //print("Delta \(self) too small \(min) | \(max)")
            // hue difference is negligable, so likely a grayscale color
            return (0, 0, max) }
        guard max > 0 else {
            //print("Max \(self) too small \(max)")
            return (-1, 0, v) } // Undefined, achromatic grey
        let s = delta / max
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }
        
        var h = hue(max, delta) * 60 // In degrees
        // make sure not less than 0 and then scale to 0-1
        h = (h < 0 ? h+360 : h) / 360
        return (h,s,v)
    }
}

public extension KuColor where UnderlyingColorType == Self {
    static var defaultDarkModeBackgroundFixed: Self {
        #if os(macOS)
        let color = "#272A24" // close, but not quite...
        #else
        let color = "#1C1C1E"
        #endif
        return .init(string: color, defaultColor: .black )
    }
}

#if os(macOS) // NOT available in macCataylst canImport(AppKit)
// TODO: Make this a protocol for adding this automatically for NSColor and UIColor without duplicating code.
import AppKit
//extension NSColor: Identifiable {
//    public var id: String {
//        self.pretty
//    }
//}
#if canImport(Foundation) && compiler(>=6.0)
extension NSColor: KuColor, @retroactive Codable {}
#else
extension NSColor: KuColor, Codable {}
#endif
extension NSColor {
    public func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // Make sure doesn't crash with extended colorspace colors.
        if let color = self.usingColorSpace(.extendedSRGB), color != self { // no change
            return color.getRed(red, green: green, blue: blue, alpha: alpha)
        }
        let _: Void = getRed(red, green: green, blue: blue, alpha: alpha)
        return true
    }
    
    public func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        let _: Void = getWhite(white, alpha: alpha)
        return true
    }
    
    public func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        let _: Void = getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
        return true
    }
    
    public static var indigo: NSColor {
        return .systemIndigo
    }

    public static var mint: NSColor {
        return .systemMint
    }

    public static var pink: NSColor {
        return .systemPink
    }

    public static var teal: NSColor {
        return .systemTeal
    }
    
    public static var accentColor: NSColor {
        return .controlAccentColor
    }
    
    public static var primary: NSColor {
        return .labelColor
    }
    
    public static var secondary: NSColor {
        return .secondaryLabelColor
    }
    
    public static var background: NSColor {
        return .windowBackgroundColor
    }
}
public extension KuColor {
    var nsColor: NSColor {
        let components = rgbaComponents
        return NSColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
}
public extension NSColor {
    // for coding assistance
    func asData() throws -> Data {
        return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
    convenience init?(_ data: Data) {
        guard let c = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) else {
            return nil
        }
        // init with values
        self.init(red: c.redComponent, green: c.greenComponent, blue: c.blueComponent, alpha: c.alphaComponent)
    }
}
#endif

#if canImport(UIKit)
import UIKit
//extension UIColor: Identifiable {
//    public var id: String {
//        self.pretty
//    }
//}
#if compiler(>=6.0)
extension UIColor: @retroactive Codable {}
#else
extension UIColor: Codable {}
#endif
extension UIColor: KuColor {
    public static var indigo: UIColor {
#if !os(watchOS)
        if #available(iOS 13, macOS 12, tvOS 13, *) {
            return .systemIndigo
        }
#endif
        return .indigoFixed
    }
    
    public static var mint: UIColor {
#if !os(watchOS)
        if #available(iOS 15, macOS 12, tvOS 15, *) {
            return .systemMint
        }
#endif
        return .mintFixed
    }
    
    public static var pink: UIColor {
#if os(watchOS)
        return .pinkFixed
#else
        return .systemPink
#endif
    }
    
    public static var teal: UIColor {
#if os(watchOS)
        return .tealFixed
#else
        return .systemTeal
#endif
    }
    
    public static var accentColor: UIColor {
#if !os(watchOS)
        if #available(iOS 15, tvOS 15, *) {
            return .tintColor
        }
#endif
        // Fallback on earlier versions
        return .accentColorFixed
    }
    
    public static var primary: UIColor {
#if !os(watchOS)
        if #available(iOS 13, tvOS 13, *) {
            return .label
        }
#endif
        // Fallback on earlier versions
        return .primaryFixed
    }
    
    public static var secondary: UIColor {
#if !os(watchOS)
        if #available(iOS 13, tvOS 13, *) {
            return .secondaryLabel
        }
#endif
        // Fallback on earlier versions
        return .secondaryFixed
    }
    
    public static var background: UIColor {
#if !os(watchOS) && !os(tvOS)
        if #available(iOS 13, *) {
            return .systemBackground
        }
        return .backgroundFixed
#else
        return .black
#endif
    }
}
public extension KuColor {
    var uiColor: UIColor {
        let components = rgbaComponents
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
}
public extension UIColor {
    // for coding assistance
    func asData() throws -> Data {
        return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }
    convenience init?(_ data: Data) {
        guard let c = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return nil
        }
        // init with values
        self.init(red: c.redComponent, green: c.greenComponent, blue: c.blueComponent, alpha: c.alphaComponent)
    }
}
#endif

#if canImport(SwiftUI)
import SwiftUI
@available(iOS 13, tvOS 13, watchOS 6, *)
//extension Color: Identifiable {
//    public var id: String {
//        self.pretty
//    }
//}
public extension KuColor {
    @available(iOS 13, tvOS 13, watchOS 6, *)
    typealias DefaultColorType = Color
}
#if compiler(>=6.0)
@available(iOS 13, tvOS 13, watchOS 6, *)
extension Color: @retroactive Codable {}
#else
@available(iOS 13, tvOS 13, watchOS 6, *)
extension Color: Codable {}
#endif
@available(iOS 13, tvOS 13, watchOS 6, *)
extension Color: KuColor {
    // available in UIColor but not SwiftUI.Color
    public static var lightGray: Color {
        return .lightGrayFixed
    }
    
    // available in UIColor but not SwiftUI.Color
    public static var darkGray: Color {
        return .darkGrayFixed
    }
    
    // available in UIColor but not SwiftUI.Color
    public static var magenta: Color {
        return .magentaFixed
    }
    
    public static var background: Color {
#if os(macOS)
        if #available(macOS 12, *) {
            return Color(nsColor: .background)
        }
#elseif canImport(UIKit)
        if #available(iOS 15, tvOS 15, watchOS 8, *) {
            return Color(uiColor: .background)
        }
#endif
        // Fallback on earlier versions
        // return primaryBackport.contrastingColor // can't use this since contrastingColor relies on this background color.  Return default for watchOS and tvOS
        return .black
    }
    
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: red, green: green, blue: blue, opacity: alpha)
//        if alpha == 1 {
//#warning("REMOVE")
//            let copy = self
//            Task {
//                if copy.alphaComponent != 1 {
//                    debug("After init, alpha \(alpha) -> is \(copy.alphaComponent)")
//                }
//            }
//        }
    }
    
    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.init(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    public func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
//        if rgba != black {
//            // try using defined values first from above
//            red?.pointee = rgba.red
//            green?.pointee = rgba.green
//            blue?.pointee = rgba.blue
//            alpha?.pointee = rgba.alpha
//            return true
//        }

        // check for built-in dynamic and symantic colors that need fixed replacements (if this already is a fixed replacement, don't delegate)
        if let fixedReplacement = Color.fixedMap[self], fixedReplacement != self {
            // system values can't get RGBA so use the fixed versions instead
//            debug("Mapped value for \(debugString) to fixed replacement version.")
            return fixedReplacement.getRed(red, green: green, blue: blue, alpha: alpha)
        }
        
        // not dynamic/symantic color
        if #available(iOS 14, macOS 11, tvOS 14, watchOS 8, *) {
            guard let cgColor = cgColor, let components = cgColor.components, components.count >= 3 else {
                return false
            }
            red?.pointee = components[0]
            green?.pointee = components[1]
            blue?.pointee = components[2]
            alpha?.pointee = cgColor.alpha
            return true
        } else {
            return false
        }
    }
    
    public func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // TODO: Do we want to pull from RGB or HSV and calculate white number?
        if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
            guard let cgColor = cgColor, let components = cgColor.components, components.count == 2 else {
                return false
            }
            white?.pointee = components[0]
            alpha?.pointee = cgColor.alpha
            return true
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    public func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // SwiftUI color will almost guaranteed not be in HSB color space so return false so we can convert from RGB
        return false
//        guard let cgColor = cgColor, let components = cgColor.components, components.count >= 3 else {
//            return false
//        }
//
//        hue?.pointee = components[0]
//        saturation?.pointee = components[1]
//        brightness?.pointee = components[2]
//        alpha?.pointee = 1.0 // SwiftUI colors do not support Alpha Channel
//        return true
    }
}
#elseif canImport(UIKit)
public extension KuColor {
    typealias DefaultColorType = UIColor // default to UIColor if for some reason we can't import SwiftUI
}
#else // Add in functions to make sure KuColor functions work even in non-UI environments for conversion and coding.
public extension KuColor {
    typealias DefaultColorType = Color
}
// create a Color struct that can be used to store color data
public struct Color: KuColor, Codable {
    // Provide missing color support manually using fixed versions
    public static var black: Color = .blackFixed
    public static var blue: Color = .blueFixed
    public static var brown: Color = .brownFixed
    public static var clear: Color = .clearFixed
    public static var cyan: Color = .cyanFixed
    public static var green: Color = .greenFixed
    public static var indigo: Color = .indigoFixed
    public static var mint: Color = .mintFixed
    public static var orange: Color = .orangeFixed
    public static var pink: Color = .pinkFixed
    public static var purple: Color = .purpleFixed
    public static var red: Color = .redFixed
    public static var teal: Color = .tealFixed
    public static var white: Color = .whiteFixed
    public static var yellow: Color = .yellowFixed
    public static var magenta: Color = .magentaFixed
    public static var gray: Color = .grayFixed
    public static var lightGray: Color = .lightGrayFixed
    public static var darkGray: Color = .darkGrayFixed
    // symantic
    public static var accentColor: Color = .accentColorFixed
    public static var primary: Color = .primaryFixed
    public static var secondary: Color = .secondaryFixed
    public static var background: Color = .backgroundFixed
    
    // all values should be 0-1
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat
    
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        // do calculations to convert to RGB
        let (red, green, blue) = Self.convert(hue: hue, saturation: saturation, brightness: brightness)
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
        
    // functions to get around native implementation change with no return
    public func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        if let red {
            red.pointee = self.red
        }
        if let green {
            green.pointee = self.green
        }
        if let blue {
            blue.pointee = self.blue
        }
        if let alpha {
            alpha.pointee = self.alpha
        }
        return true
    }
    
    public func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        if let white {
            white.pointee = (red + green + blue) / 3
        }
        if let alpha {
            alpha.pointee = self.alpha
        }
        return true
    }
    
    public func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // use KuColor calculations of HSB
        let components = hsbComponents
        if let hue {
            hue.pointee = components.hue
        }
        if let saturation {
            saturation.pointee = components.saturation
        }
        if let brightness {
            brightness.pointee = components.brightness
        }
        if let alpha {
            alpha.pointee = self.alpha
        }
        return true
    }
}
#endif

public extension KuColor {
    // MARK: Get RGB Colors
    /// returns the RGBA values of the color if it can be determined and black-clear if not.
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        get {
            // TODO: Store in cache so we don't have to re-calculate?
            var rgba = (red: CGFloat.zero, green: CGFloat.zero, blue: CGFloat.zero, alpha: CGFloat.zero)

            // Checking fixedMap is not necessary here since this is done in the getRed(,green:,etc in SwiftUI.Color since other colors should be able to get their RGBA values.

            if getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha) {
                return rgba
            }
            var white = CGFloat.zero
            var alpha = CGFloat.zero
            if getWhite(&white, alpha: &alpha) {
                rgba.red = white // assign brightness to RGB
                rgba.green = white // assign brightness to RGB
                rgba.blue = white // assign brightness to RGB
                rgba.alpha = alpha // same alpha
            }
            //print("Unable to get rgba components of \(self)")
            return rgba
        }
    }
    /// Red component value between 0 and 1
    var redComponent: CGFloat {
        return rgbaComponents.red
    }
    /// Green component value between 0 and 1
    var greenComponent: CGFloat {
        return rgbaComponents.green
    }
    /// Blue component value between 0 and 1
    var blueComponent: CGFloat {
        return rgbaComponents.blue
    }
    /// Alpha component value between 0 and 1
    var alphaComponent: CGFloat {
        return rgbaComponents.alpha
    }
    
    var hsbComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        //print("\(self) HSB COMPONENTS")
        var hsb = (hue: CGFloat.zero, saturation: CGFloat.zero, brightness: CGFloat.zero)
        // Try to use native conversions if possible
        if getHue(&hsb.hue, saturation: &hsb.saturation, brightness: &hsb.brightness, alpha: nil) {
            return hsb
        }
        // fallback to internal conversions
        let rgbaComponents = self.rgbaComponents
        return Self.convert(red: rgbaComponents.red, green: rgbaComponents.green, blue: rgbaComponents.blue)
    }
    var hueComponent: CGFloat {
        return hsbComponents.hue
    }
    var saturationComponent: CGFloat {
        return hsbComponents.saturation
    }
    var brightnessComponent: CGFloat {
        return hsbComponents.brightness
    }
    
    /// can use to convert between KuColor protocol objects like UIColor or SwiftUI Color.
    init(color: any KuColor) {
        self.init(red: color.redComponent, green: color.greenComponent, blue: color.blueComponent, alpha: color.alphaComponent)
    }
}

#if canImport(SwiftUI)
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("HSV Conversion") {
    HSVConversionTestView()
}
#endif


// MARK: - Comparisons

// adding equatable conformance for colors
public func ==(lhs: some KuColor, rhs: some KuColor) -> Bool {
    debug("Equating lhs to rhs using stringValue")
    return lhs.stringValue == rhs.stringValue // this is so dynamic/semantic values work as well by comparing >1 alpha values.
}
// default hue comparison of colors
/// by default, colors are compared based off of hue, then saturation, then brightness to allow for creating sorted colors.
public func <(lhs: some KuColor, rhs: some KuColor) -> Bool {
    guard lhs.hueComponent == rhs.hueComponent else {
        return lhs.hueComponent < rhs.hueComponent
    }
    guard lhs.saturationComponent == rhs.saturationComponent else {
        return lhs.saturationComponent < rhs.saturationComponent
    }
    return lhs.brightnessComponent < rhs.brightnessComponent
}
public extension Array where Element: KuColor, Element.UnderlyingColorType == Element {
    /// Default comparison sort since we can't have KuColor conform to Comparable.
    func sorted() -> Self {
        return self.sorted(by: <)
    }
}

public extension KuColor {
    // Converted values for testing/comparing
    var hsvConverted: Self {
        let hsb = self.hsbComponents
        return Self(hue: hsb.hue, saturation: hsb.saturation, brightness: hsb.brightness, alpha: self.alphaComponent)
    }
    var rgbConverted: Self {
        let rgba = self.rgbaComponents
        return Self(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }
    var cssConverted: Self {
        return Self(string: self.cssString, defaultColor: Self(red: 0, green: 0, blue: 0, alpha: 0))
    }
#if canImport(CoreGraphics)
    init(cgColor: CGColor) {
        guard let components = cgColor.components, components.count == 4 else {
            debug("Unable to get components from CGColor")
            self = Self.black as! Self
            return
        }
        let redComponent = components[0]
        let greenComponent = components[1]
        let blueComponent = components[2]
        let alphaComponent = components[3]
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alphaComponent)
    }
    @available(iOS 13, tvOS 13, watchOS 6, *)
    var cgColorBackport: CGColor {
        return CGColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alphaComponent)
    }
#endif
}

public extension KuColor {
    // MARK: brightness qualifiers
    var isDark: Bool {
        if hueComponent == 0 && saturationComponent == 1 {
            return brightnessComponent < 0.5
        } else {
            return brightnessComponent < 0.5 || redComponent + greenComponent + blueComponent < 1.5 // handle "pure" colors
        }
    }
    var isLight: Bool {
        return !isDark
    }
    
    // MARK: Highlighting Colors
    private func _colorWithBrightness(multiplier: CGFloat) -> Self {
        var hsb = hsbComponents
        //print("HSB: \(hsb)")
        // make sure alpha component is not preserved if this is a dynamic color
        var alphaComponent = self.alphaComponent
        if symantic != nil {
            alphaComponent = 1
        }
        hsb.brightness *= multiplier
        return Self(hue: hsb.hue, saturation: hsb.saturation, brightness: hsb.brightness, alpha: alphaComponent)
    }
    
    var darkerColor: Self {
        return _colorWithBrightness(multiplier: 0.5)
    }
    
    var lighterColor: Self {
        return _colorWithBrightness(multiplier: 2)
    }
    // https://dallinjared.medium.com/swiftui-tutorial-contrasting-text-over-background-color-2e7af57c1b20
    /// Returns the luminance value which is `0.2126*red + 0.7152*green + 0.0722*blue`
    var luminance: CGFloat {
        return 0.2126 * self.redComponent + 0.7152 * self.greenComponent + 0.0722 * self.blueComponent
    }
    /// returns either white or black depending on the base color to make sure it's visible against the background.  In the future we may want to change this to some sort of vibrancy.  Note, if you're using this on accentColor on a view that has changed the tint, will give a contrassting color for the Asset color named "AccentColor" and not the actual color value since actual color values can't be read.
    var contrastingColor: Self {
        // check for symantic colors
        if self.underlying == Self.primaryBackport || self.underlying == Self.secondaryBackport {
            return Self.background as! Self
        }
        if self.underlying == Self.accentColorBackport && self != Self.accentColorFixed {
            // pull from assets rather than from the color which will just return a blue color
            #if os(macOS)
            if let nsColor = NSColor(named: "AccentColor") {
                return Self(color: nsColor).contrastingColor
            }
            #elseif canImport(UIKit)
            if let uiColor = UIColor(named: "AccentColor") {
                return Self(color: uiColor).contrastingColor
            }
            #endif
            return Self.accentColorFixed.contrastingColor
        }
        //        return isDark ? .white : .black
        return (luminance < 0.6 ? Self.white : Self.black) as! Self
    }
}

#if canImport(SwiftUI)

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Color Tinting") {
    ColorTintingTestView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Lightness Tests") {
    ContrastingTestView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 7, *)
#Preview("All Tests") {
    ColorTestView()
}

#endif

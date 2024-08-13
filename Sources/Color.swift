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
    static let version: Version = "1.1.0"
}
import Compatibility

// http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/

public extension CGFloat {
    static let zero = CGFloat(0.0)
    static let one = CGFloat(1.0)
}

// Does conform to Identifiable but can't add for older iOS    @available(iOS 13, tvOS 13, watchOS 6, *)
public protocol KuColor: Codable, Equatable, Hashable {
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
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var brown: UnderlyingColorType { get }
    static var brownBackport: UnderlyingColorType { get }
    static var clear: UnderlyingColorType { get }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var cyan: UnderlyingColorType { get }
    static var cyanBackport: UnderlyingColorType { get }
    static var gray: UnderlyingColorType { get }
    static var green: UnderlyingColorType { get }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var indigo: UnderlyingColorType { get }
    static var indigoBackport: UnderlyingColorType { get }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var mint: UnderlyingColorType { get }
    static var mintBackport: UnderlyingColorType { get }
    static var orange: UnderlyingColorType { get }
    static var pink: UnderlyingColorType { get }
    static var purple: UnderlyingColorType { get }
    static var red: UnderlyingColorType { get }
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    static var teal: UnderlyingColorType { get }
    static var tealBackport: UnderlyingColorType { get }
    static var white: UnderlyingColorType { get }
    static var yellow: UnderlyingColorType { get }
    // Kudit Added
    static var magenta: UnderlyingColorType { get }
    static var lightGray: UnderlyingColorType { get }
    static var darkGray: UnderlyingColorType { get }
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
    var id: String {
        self.pretty
    }
    
    // Fallback color values for platforms that don't support colors or dynamic colors
    static var blackFixed: Self { Self(red: .zero, green: .zero, blue: .zero, alpha: .one) }
    static var blueFixed: Self { Self(red: .zero, green: 112/255, blue: .one, alpha: .one) }
    static var brownFixed: Self { Self(red: 162/255, green: 132/255, blue: 94/255, alpha: .one) }
    static var clearFixed: Self { Self(red: .zero, green: .zero, blue: .zero, alpha: .zero)}
    static var cyanFixed: Self { Self(red: 50/255, green: 173/255, blue: 230/255, alpha: .one)}
    static var grayFixed: Self { Self(red: 142/255, green: 142/255, blue: 147/255, alpha: .one)}
    static var lightGrayFixed: Self { Self(red: 203/255, green: 203/255, blue: 204/255, alpha: .one)}
    static var darkGrayFixed: Self { Self(red: 81/255, green: 81/255, blue: 82/255, alpha: .one)}
    static var greenFixed: Self { Self(red: 52/255, green: 199/255, blue: 89/255, alpha: .one)}
    static var indigoFixed: Self { Self(red: 88/255, green: 86/255, blue: 214/255, alpha: .one)}
    static var magentaFixed: Self { Self(red: .one, green: .zero, blue: .one, alpha: .one)}
    static var mintFixed: Self { Self(red: .zero, green: 199/255, blue: 190/255, alpha: .one)}
    static var orangeFixed: Self { Self(red: .one, green: 149/255, blue: .zero, alpha: .one)}
    static var pinkFixed: Self { Self(red: .one, green: 45/255, blue: 85/255, alpha: .one)}
    static var purpleFixed: Self { Self(red: 175/255, green: 82/255, blue: 222/255, alpha: .one)}
    static var redFixed: Self { Self(red: .one, green: 59/255, blue: 48/255, alpha: .one)}
    static var tealFixed: Self { Self(red: 48/255, green: 176/255, blue: 199/255, alpha: .one)}
    static var whiteFixed: Self { Self(red: .one, green: .one, blue: .one, alpha: .one)}
    static var yellowFixed: Self { Self(red: .one, green: 204/255, blue: .zero, alpha: .one)}
    
    static var fixedMap: [UnderlyingColorType: Self] {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            [
                Self.black: .blackFixed,
                Self.blue: .blueFixed,
                Self.brown: .brownFixed,
                Self.clear: .clearFixed,
                Self.cyan: .cyanFixed,
                Self.gray: .grayFixed,
                Self.lightGray: .lightGrayFixed,
                Self.darkGray: .darkGrayFixed,
                Self.green: .greenFixed,
                Self.indigo: .indigoFixed,
                Self.mint: .mintFixed,
                Self.orange: .orangeFixed,
                Self.pink: .pinkFixed,
                Self.purple: .purpleFixed,
                Self.red: .redFixed,
                Self.teal: .tealFixed,
                Self.white: .whiteFixed,
                Self.yellow: .yellowFixed,
            ]
        } else {
            // Fallback on earlier versions
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
                Self.mintBackport: .mintFixed,
                Self.orange: .orangeFixed,
                Self.pink: .pinkFixed,
                Self.purple: .purpleFixed,
                Self.red: .redFixed,
                Self.tealBackport: .tealFixed,
                Self.white: .whiteFixed,
                Self.yellow: .yellowFixed,
            ]
        }
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

    /// conversion from HSB to RGB
    static func convert(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if saturation == 0 { return (brightness, brightness, brightness) } // Achromatic grey
        
        let angle = (hue >= 360 ? 0 : hue)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h
        
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

#if os(macOS) // NOT available in macCataylst canImport(AppKit)
// TODO: Make this a protocol for adding this automatically for NSColor and UIColor without duplicating code.
import AppKit
extension NSColor: Identifiable {
    public var id: String {
        self.pretty
    }
}
extension NSColor: KuColor {
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
extension UIColor: Identifiable {
    public var id: String {
        self.pretty
    }
}
extension UIColor: KuColor {
    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var indigo: UIColor {
#if os(watchOS)
        return .indigoFixed
#else
        return .systemIndigo
#endif
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var mint: UIColor {
#if os(watchOS)
        return .mintFixed
#else
        return .systemMint
#endif
    }

    public static var pink: UIColor {
#if os(watchOS)
        return .pinkFixed
#else
        return .systemPink
#endif
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    public static var teal: UIColor {
#if os(watchOS)
        return .tealFixed
#else
        return .systemTeal
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
extension Color: Identifiable {
    public var id: String {
        self.pretty
    }
}
public extension KuColor {
    @available(iOS 13, tvOS 13, watchOS 6, *)
    typealias DefaultColorType = Color
}
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

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: red, green: green, blue: blue, opacity: alpha)
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

        // check for built-in colors that need fixed replacements (if this already is a fixed replacement, don't delegate)
        if let fixedReplacement = Color.fixedMap[self], fixedReplacement != self {
            // system values can't get RGBA so use the fixed versions instead
            return fixedReplacement.getRed(red, green: green, blue: blue, alpha: alpha)
        }
        
        // not named color
        // Impossible to calculate for accentColor/primary/secondary/.  Perhaps return something else?
        
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
public struct Color: KuColor {
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
    // TODO: Standardize 255
    //    static let eightBitDenominator = 255.0
    // MARK: Get RGB Colors
    /// returns the RGBA values of the color if it can be determined and black-clear if not.
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        get {
            // TODO: Store in cache so we don't have to re-calculate?
            var rgba = (red: CGFloat.zero, green: CGFloat.zero, blue: CGFloat.zero, alpha: CGFloat.zero)
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
public extension KuColor {
    static func ==(lhs:Self, rhs:Self) -> Bool {
        return lhs.redComponent == rhs.redComponent
        && lhs.greenComponent == rhs.greenComponent
        && lhs.blueComponent == rhs.blueComponent
        && lhs.alphaComponent == rhs.alphaComponent
    }
    
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
    @available(iOS 13, tvOS 13, watchOS 6, *)
    var contrastingColor: Color {
#if os(macOS)
        if let color = self as? Color, color == .primary || color == .secondary {
            return Color(NSColor.windowBackgroundColor)
            //            let mode = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
            //            return mode == "Dark"
        }
        if let color = self as? Color, color == .accentColor {
            // pull from assets rather than from the color which will just return a blue color
            if let nsColor = NSColor(named: "AccentColor") {
                return nsColor.contrastingColor
            }
        }
#elseif canImport(UIKit)
        // Fix so primary color - dark mode shows black
        if let color = self as? Color, color == .primary || color == .secondary {
#if os(watchOS) || os(tvOS) || os(visionOS) // no dark/light mode
            return .black
#else
            return Color(UIColor.systemBackground)
#endif
        }
        if let color = self as? Color, color == .accentColor {
            // pull from assets rather than from the color which will just return a blue color
            if let uiColor = UIColor(named: "AccentColor") {
                return uiColor.contrastingColor
            }
        }
#endif
        //        return isDark ? .white : .black
        return luminance < 0.6 ? .white : .black
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

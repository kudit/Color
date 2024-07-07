//
//  Color.swift
//  KuditFrameworks
//
//  Created by Ben Ku on 9/26/16.
//  Copyright © 2016 Kudit. All rights reserved.
//

// http://arstechnica.com/apple/2009/02/iphone-development-accessing-uicolor-components/

public extension Color {
    static let version = "1.0.0"
}

public protocol KuColor: Codable, Equatable, Identifiable {
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
    static var brown: UnderlyingColorType { get }
    static var clear: UnderlyingColorType { get }
    static var cyan: UnderlyingColorType { get }
    static var gray: UnderlyingColorType { get }
    static var green: UnderlyingColorType { get }
    static var indigo: UnderlyingColorType { get }
    static var mint: UnderlyingColorType { get }
    static var orange: UnderlyingColorType { get }
    static var pink: UnderlyingColorType { get }
    static var purple: UnderlyingColorType { get }
    static var red: UnderlyingColorType { get }
    static var teal: UnderlyingColorType { get }
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
}


#if canImport(UIKit)
import UIKit
extension UIColor: KuColor {
    public static var indigo: UIColor {
#if os(watchOS)
        return UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
#else
        return .systemPurple
#endif
    }

    public static var mint: UIColor {
#if os(watchOS)
        return UIColor(red: 0/255, green: 199/255, blue: 190/255, alpha: 1)

#else
        return .systemMint
#endif
    }

    public static var pink: UIColor {
#if os(watchOS)
        return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)

#else
        return .systemPink
#endif
    }

    public static var teal: UIColor {
#if os(watchOS)
        return UIColor(red: 48/255, green: 176/255, blue: 199/255, alpha: 1)

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
public extension KuColor {
    typealias DefaultColorType = Color
}
extension Color: KuColor {
    public static var lightGray: Color {
        return .init(string: "#CBCBCB", defaultColor: .white)
    }
    
    public static var darkGray: Color {
        return .init(string: "#515151", defaultColor: .black)
    }
    
    public static var magenta: Color {
        return .init(red: 1, green: 0, blue: 1, alpha: 1)
    }

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    public init(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        self.init(hue: hue, saturation: saturation, brightness: brightness, opacity: alpha)
    }
    
    public func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // Switch for built-in colors
        let zero = CGFloat(0.0)
        let black = (red: zero, green: zero, blue: zero, alpha: zero)
        var rgba = black
        switch self {
        case .blue:
            rgba = (red: 0/255, green: 112/255, blue: 255/255, alpha: 1)
        case .brown:
            rgba = (red: 162/255, green: 132/255, blue: 94/255, alpha: 1)
        case .clear:
            rgba = (red: 0, green: 0, blue: 0, alpha: 0)
        case .cyan:
            rgba = (red: 50/255, green: 173/255, blue: 230/255, alpha: 1)
        case .gray:
            rgba = (red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        case .lightGray:
            rgba = (red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        case .darkGray:
            rgba = (red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        case .green:
            rgba = (red: 52/255, green: 199/255, blue: 89/255, alpha: 1)
        case .indigo:
            rgba = (red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
        case .mint:
            rgba = (red: 0/255, green: 199/255, blue: 190/255, alpha: 1)
        case .orange:
            rgba = (red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
        case .pink:
            rgba = (red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        case .purple:
            rgba = (red: 175/255, green: 82/255, blue: 222/255, alpha: 1)
        case .red:
            rgba = (red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        case .teal:
            rgba = (red: 48/255, green: 176/255, blue: 199/255, alpha: 1)
        case .white: // seems to work already
            rgba = (red: 1, green: 1, blue: 1, alpha: 1)
        case .yellow:
            rgba = (red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        default:
            break
            // nothing.  Default to black.
            // Impossible to calculate for accentColor/primary/secondary/.  Perhaps return something else?
            //print("Unable to determine SwiftUI Color: \(color)")
        }
        if rgba != black {
            // try using defined values first from above
            red?.pointee = rgba.red
            green?.pointee = rgba.green
            blue?.pointee = rgba.blue
            alpha?.pointee = rgba.alpha
            return true
        }
        
        guard let cgColor = cgColor, let components = cgColor.components, components.count >= 3 else {
            return false
        }
        
        red?.pointee = components[0]
        green?.pointee = components[1]
        blue?.pointee = components[2]
        alpha?.pointee = cgColor.alpha
        return true
    }
    
    public func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        guard let cgColor = cgColor, let components = cgColor.components, components.count == 2 else {
            return false
        }
        
        white?.pointee = components[0]
        alpha?.pointee = cgColor.alpha
        return true
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
    // all values should be 0-1
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
    public var alpha: CGFloat
    
    // functions to get around native implementation change with no return
    public func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        if var red {
            red.pointee = self.red
        }
        if var green {
            green.pointee = self.green
        }
        if var blue {
            blue.pointee = self.blue
        }
        if var alpha {
            alpha.pointee = self.alpha
        }
        return true
    }
    
    public func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        if var white {
            white.pointee = (self.red + self.green + self.blue) / 3
        }
        if var alpha {
            alpha.pointee = self.alpha
        }
        return true
    }
    
    public func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        // use KuColor calculations of HSB
        let components = hsbComponents
        if var hue {
            hue.pointee = components.hue
        }
        if var saturation {
            saturation.pointee = components.saturation
        }
        if var brightness {
            brightness.pointee = components.brightness
        }
        if var alpha {
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
            let zero = CGFloat(0.0)
            var rgba = (red: zero, green: zero, blue: zero, alpha: zero)
            if getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha) {
                return rgba
            }
            var white = zero
            var alpha = zero
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
        let zero = CGFloat(0.0)
        var hsb = (hue: zero, saturation: zero, brightness: zero)
        if getHue(&hsb.hue, saturation: &hsb.saturation, brightness: &hsb.brightness, alpha: nil) {
            return hsb
        }
        //hsb.saturation = 1.0
        //_ = getWhite(&hsb.brightness, alpha: nil)
        
        // attempt to convert from RGBA
        // based off of https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce
        let rgba = rgbaComponents
        let r = rgba.red
        let g = rgba.green
        let b = rgba.blue
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
        hsb = (h,s,v)
        //print("\(self) calculated HSB: \(hsb)")
        return hsb
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
    var contrastingColor: Color {
#if canImport(UIKit) && !os(watchOS) && !os(tvOS)
        // Fix so primary color - dark mode shows black
        if let color = self as? Color, color == .primary || color == .secondary {
            return Color(UIColor.systemBackground)
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
#Preview("Color Tinting") {
    ColorTintingTestView()
}
#Preview("Lightness Tests") {
    LightnessTestView()
}
#endif




#if canImport(SwiftUI)
import SwiftUI

#Preview("All Tests") {
    ColorTestView()
}

#endif

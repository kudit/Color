//
//  Colorsets.swift
//
//
//  Created by Ben Ku on 7/5/24.
//
// MARK: - Colorsets/groups
// doesn't really make sense directly on color since it's not a color, it's a set of colors
//public extension KuColor where UnderlyingColorType == Self {
//    static var rainbow: [UnderlyingColorType] { [Self].rainbow }
//    static var prioritized: [Self] { [Self].prioritized }
//    static var named: [UnderlyingColorType] { [Self].named }
//    static var grayscale: [UnderlyingColorType] { [Self].grayscale }
//}
public extension Array where Element: KuColor, Element.UnderlyingColorType == Element {
    /// 6 colors in logo order
    static var apple: [Element] {
        return [.green, .yellow, .orange, .red, .purple, .blue]
    }
    /// ROYGBIV(purple for violet)
    static var rainbow: [Element] {
        return [.red, .orange, .yellow, .green, .blue, .indigoBackport, .purple]
    }
    /// Primary colors, secondary colors, tertiary colors
    static var prioritized: [Element] {
        return [.red, .green, .blue, .yellow, .tealBackport, .magenta, .orange, .mintBackport, .purple, .dotYellowGreen, .indigoBackport, .brownBackport]//.sorted()
    }
    /// All Apple named colors (adds cyan and magenta)
    static var named: [Element] {
        return [.red, .orange, .yellow, .green, .mintBackport, .tealBackport, .cyanBackport, .blue, .indigoBackport, .purple, .magenta, .pink, .brownBackport, .clear, .gray, .black, .white]
    }
    /// Grayscale colors from white to black
    static var grayscale: [Element] { [.white, .lightGray, .gray, .darkGray, .black] }
}
// MARK: DOT Colors
public extension KuColor where UnderlyingColorType == Self {
    //     Blue - 294
    /// Services
    static var dotBlue: Self { .init(string: "rgb(0,63,135)", defaultColor: .black ) }
    //     Brown - 469
    /// Recreational
    static var dotBrown: Self { .init(string: "rgb(96,51,17)", defaultColor: .black ) }
    //     Green - 342
    /// Location guide, direction guidance
    static var dotGreen: Self { .init(string: "rgb(0,107,84)", defaultColor: .black ) }
    //     Green-Colored Pavement - 802
    /// Bicycle Lanes
    static var dotGreenPavement: Self { .init(string: "rgb(96,221,73)", defaultColor: .black ) }
    //     Orange - 152
    /// temporary traffic control
    static var dotOrange: Self { .init(string: "rgb(221,117,0)", defaultColor: .black ) }
    //     Pink - 198
    /// Incident Management
    static var dotPink: Self { .init(string: "rgb(119,45,53)", defaultColor: .black ) }
    //     Purple - 259
    /// Toll collection
    static var dotPurple: Self { .init(string: "rgb(114,22,107)", defaultColor: .black ) }
    //     Red - 187
    /// stop or prohibition
    static var dotRed: Self { .init(string: "rgb(175,30,45)", defaultColor: .black ) }
    //     Red-Colored Pavement - 485
    /// Transit Only
    static var dotRedPavement: Self { .init(string: "rgb(216,30,5)", defaultColor: .black ) }
    //     Yellow - 116
    /// Warning
    static var dotYellow: Self { .init(string: "rgb(252,209,22)", defaultColor: .black ) }
    //     Yellow-Green - 382
    /// Pedestrian warning
    static var dotYellowGreen: Self { .init(string: "rgb(186,216,10)", defaultColor: .black ) }
}

public extension Array where Element: KuColor, Element.UnderlyingColorType == Element {
    /// DOT Colors
    static var dotColors: [Element] { [.dotBlue, .dotBrown, .dotGreen, .dotGreenPavement, .dotOrange, .dotPink, .dotPurple, .dotRed, .dotRedPavement, .dotYellow, .dotYellowGreen] }
    
    /// A list of named color sets for debugging/picking.  Can't just use dictionary since we care about the order.
    // TODO: Change to OrderedDictionary?
    static var namedColorsets: [(String, [Element])] {
        return [
            ("Apple", .apple),
            ("Rainbow", .rainbow),
            ("Prioritized", .prioritized),
            ("Named", .named),
            ("Grayscale", .grayscale),
            ("DOT", .dotColors),
        ]
    }
}

//extension [any KuColor]: Swift.Identifiable {
//    public var id: String {
//        map { $0.id }.joined(separator: ",")
//    }
//}
public extension KuColor {
    /// For quickly initializing a color using the nth item in a colorset.  Extension of KuColor so we can type . and start initializing for autocomplete.
    static func nth(_ nth: Int, of colorset: [Self]) -> Self {
        return colorset[nth: nth]
    }
}

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, tvOS 13, watchOS 6, *)
public struct ColorBarTestView: View {
    public var text: String?
    public var colors: [Color]
    // auto-generated doesn't work externally.  need to explicitly define so can be public.
    public init(text: String? = nil, colors: [Color]) {
        self.text = text
        self.colors = colors
    }
    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(colors, id: \.self) { color in
                    color
                }
            }
            if let text {
                Text(text)
                    .font(.title)
                    .bold()
                    .backport.foregroundStyle(.white)
                    .shadow(radius: 1)
                
            }
        }.clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

@available(iOS 13, tvOS 13, watchOS 6, *)
public struct ColorsetsTestView: View {
    var colorsets = [Color].namedColorsets
    public var body: some View {
        VStack {
            ForEach(colorsets.indices, id: \.self) { index in
                let (label, colorset) = colorsets[index]
                ColorBarTestView(text: label, colors: colorset)
            }
        }
    }
}

@available(iOS 13, tvOS 13, watchOS 6, *)
#Preview("Colorsets") {
    ColorsetsTestView()
}

#endif

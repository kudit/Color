//
//  SwiftUIView.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if canImport(SwiftUI)
import SwiftUI
//import Compatibility

@available(macOS 11.0, *)
struct Swatch: View {
    var color: Color
    var logo: Bool = false
    init(color: Color, logo: Bool = false) {
        self.color = color
        self.logo = logo
    }
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 50, height: 50)
            .foregroundColor(color)
            .backport.overlay {
                ZStack {
                    if logo {
                        Image(systemName: "applelogo")
                            .imageScale(.large)
                    } else {
                        Text("\(self.color.hexString)")
                            .bold()
                    }
                }
                .foregroundColor(color.contrastingColor) // isDark ? .white : .black
            }
    }
}
@available(macOS 11.0, *)
struct SwatchTest: View {
    var color: Color
    var body: some View {
        Swatch(color: color, logo: true)
    }
}
@available(macOS 11.0, *)
struct HSVConversionTestView: View {
    public var body: some View {
        VStack {
            Text("HSV Conversion")
            ForEach([Color].rainbow, id: \.self) { color in
                HStack(spacing: 0) {
                    // primary named colors
                    SwatchTest(color: color)
                    // css conversion tests
                    SwatchTest(color: color.rgbConverted)
                    // hsv conversion tests
                    SwatchTest(color: color.hsvConverted)
                    // rgb converted tests
                    SwatchTest(color: color.cssConverted)
                }
            }
        }
    }
}

@available(macOS 11.0, *)
struct ColorTintingTestView: View {
    public var body: some View {
        VStack {
            Text("Color Tinting")
            HStack {
                ForEach([Color].rainbow, id: \.self) { color in
                    VStack {
                        Swatch(color: color.lighterColor)
                        Swatch(color: color)
                        Swatch(color: color.darkerColor)
                    }
                }
            }
        }
    }
}
@available(macOS 11.0, *)
struct LightnessTestView: View {
    var body: some View {
        VStack {
            Text("Lightness Tests")
                .bold()
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    SwatchTest(color: .red)
                    SwatchTest(color: .orange)
                    SwatchTest(color: .yellow)
                    SwatchTest(color: .green)
                    SwatchTest(color: .blue)
                    SwatchTest(color: .purple)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: Color(string:Color.red.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.orange.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.yellow.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.green.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.blue.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.purple.hexString) ?? .black)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: .white)
                    SwatchTest(color: .lightGray)
                    SwatchTest(color: Color(string: "Gray") ?? .white)
                    SwatchTest(color: .gray)
                    SwatchTest(color: .darkGray)
                    SwatchTest(color: .black)
                }
                VStack(spacing: 0) {
                    
                    SwatchTest(color: .accentColor)
                    SwatchTest(color: .primary)
                    SwatchTest(color: .secondary)
                    SwatchTest(color: Color(string:"SkyBlue") ?? .black)
                    SwatchTest(color: Color(string:"Beige") ?? .black)
                    SwatchTest(color: Color(string:"LightGray") ?? .black)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: Color(string:Color.pink.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.brown.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.mint.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.teal.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.cyan.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.indigo.hexString) ?? .black)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: .pink)
                    SwatchTest(color: .brown)
                    SwatchTest(color: .mint)
                    SwatchTest(color: .teal)
                    SwatchTest(color: .cyan)
                    SwatchTest(color: .indigo)
                }
            }
            
        }.padding().backport.background { Color.gray }
    }
}

struct NamedColorsListTestView: View {
    public var body: some View {
        List {
//            ForEach(Color.namedColorMap.sorted(by: <), id: \.key) { key, value in
            ForEach(Color.namedColorMap.sorted { lhs, rhs in
                // TODO: Migrate this to allowing comparisons of colors to create a color line.
                let left = Color(string: lhs.value, defaultColor: .gray)
                let right = Color(string: rhs.value, defaultColor: .gray)
                guard left.hueComponent == right.hueComponent else {
                    return left.hueComponent < right.hueComponent
                }
                guard left.saturationComponent == right.saturationComponent else {
                    return left.saturationComponent < right.saturationComponent
                }
                return left.brightnessComponent < right.brightnessComponent
            }, id: \.key) { key, value in
                let color = Color(string: key, defaultColor: .black)
                HStack {
                    Text(key)
                    Spacer()
                    Text(value)
                }
                .padding()
                .backport.background {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(color)
                }
                .backport.foregroundStyle(color.contrastingColor)
            }
        }
    }
}

struct ColorPrettyTestView: View {
    public var body: some View {
        VStack {
            Text("Pretty output of various colors.")
                .font(.title)
            Text("red -> \"\(Color(string: "red", defaultColor: .black).pretty)\"")
            Text("red rgb -> \"\(Color(red: 1, green: 0, blue: 0, alpha: 1).pretty)\"")
            Text("red alpha color -> \"\(Color(red: 1, green: 0, blue: 0, alpha: 0.5).pretty)\"")
            Text("red rgba -> \"\(Color(string: "rgba(255,0,0,0.5)", defaultColor: .black).pretty)\"")
            Text("red hex -> \"\(Color(string: "#F00", defaultColor: .black).pretty)\"")
            Text("red rgb expanded -> \"\(Color(red: 1.1, green: 0, blue: 0, alpha: 1).pretty)\"")
            Text("white -> \"\(Color.white.pretty)\"")
            Text("black -> \"\(Color.black.pretty)\"")
        }
    }
}

@available(macOS 11.0, tvOS 14, *)
public struct ColorTestView: View {
    public init() {}
    public var body: some View {
        TabView {
            ColorsetsTestView()
            HSVConversionTestView()
            LightnessTestView()
            ColorPrettyTestView()
            NamedColorsListTestView()
            ColorTintingTestView()
        }
        .backport.tabViewStyle(.page)
    }
}

/// For KuditConnect for testing
@available(tvOS 15, macOS 12, *)
public extension View {
    func testBackground() -> some View {
        ZStack {
            Color.clear
            self
        }
        .background(.conicGradient(colors: .rainbow, center: .center))
        .backport.ignoresSafeArea()
    }
}


#endif

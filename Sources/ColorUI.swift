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
    var label: String?
    init(color: Color, logo: Bool = false) {
        let label = logo ? nil : color.hexString
        self.init(color: color, label: label)
    }
    init(color: Color, label: String?) {
        self.color = color
        self.label = label
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .frame(width: 50, height: 50)
            .foregroundColor(color)
            .backport.overlay {
                ZStack {
                    if let label {
                        Text("\(label)")
                            .bold()
                    } else {
                        Image(systemName: "applelogo")
                            .imageScale(.large)
                    }
                    //Text("\(Int(color.luminance * 100))").shadow(color: color, radius: 1)
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
@available(macOS 11, *)
#Preview("HSV") {
    HSVConversionTestView()
}
@available(macOS 11.0, *)
struct ColorTintingTestView: View {
    public var body: some View {
        VStack {
            Text("Color Tinting")
            VStack {
                HStack {
                    Swatch(color: .lightGray, label: "Light")
                    Swatch(color: .gray, label: "Normal")
                    Swatch(color: .darkGray, label: "Dark")
                }.font(.caption)
                ForEach([Color].rainbow, id: \.self) { color in
                    HStack {
                        Swatch(color: color.lighterColor)
                        Swatch(color: color)
                        Swatch(color: color.darkerColor)
                    }
                }
            }
        }
    }
}
@available(macOS 11, *)
#Preview("Color Tinting") {
    ColorTintingTestView()
}
@available(macOS 11.0, *)
struct ContrastingTestView: View {
    var body: some View {
        VStack {
            Text("Contrasting Tests")
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
@available(macOS 11, *)
#Preview("Lightness") {
    ContrastingTestView()
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
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color)
                }
                .backport.foregroundStyle(color.contrastingColor)
                .closure { view in
#if !os(tvOS) && !os(watchOS)
                    Group {
                        if #available(iOS 15, macOS 13, *) {
                            view.listRowSeparator(.hidden)
                        } else {
                            view
                        }
                    }
#else
                    view
#endif
                }
            }
        }
        .listStyle(.plain)
        .closure { view in
            Group {
                if #available(iOS 17.0, macOS 99, tvOS 17, watchOS 10, *) {
                    view
                        .contentMargins(.bottom, Self.bottomMargin, for: .automatic)
                } else {
                    // Fallback on earlier versions
                    view
                }
            }
        }
    }
}
@available(macOS 11, *)
#Preview("Named") {
    NamedColorsListTestView()
}

struct PrettySwatch: View {
    var source: String
    var color: Color {
        Color(string: source, defaultColor: .primary)
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(color)
            VStack {
                HStack {
                    Text(source)
                        .italic()
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(color.pretty)
                        .font(.title.monospaced())
                        .bold()
                }
            }
            .padding()
            .foregroundStyle(color.contrastingColor)
        }
    }
}

//#Preview("Pretty Swatch") {
//    PrettySwatch(source: "red")
//        .frame(height: 100)
//        .padding()
//}

struct ColorPrettyTestView: View {
    let prettyTests = [
        "red",
        "rgb(0, 255, 0)",
        "rgba(0, 0, 255, 1)",
        "rgba(255, 0, 128, 0.5)",
        "#ff0",
        "#c0ffee",
        "rgba(0,281,0,1)", // expanded colorspace
        "white",
        "black",
    ]
    public var body: some View {
        VStack {
            Text("Pretty output of various colors.")
                .font(.title)
            ForEach(prettyTests, id: \.self) { test in
                PrettySwatch(source: test)
            }
//            Text("red -> \"\(Color(string: "red", defaultColor: .black).pretty)\"")
//            Text("red rgb -> \"\(Color(red: 1, green: 0, blue: 0, alpha: 1).pretty)\"")
//            Text("red alpha color -> \"\(Color(red: 1, green: 0, blue: 0, alpha: 0.5).pretty)\"")
//            Text("red rgba -> \"\(Color(string: "rgba(255,0,0,0.5)", defaultColor: .black).pretty)\"")
//            Text("red hex -> \"\(Color(string: "#F00", defaultColor: .black).pretty)\"")
//            Text("red rgb expanded -> \"\(Color(red: 1.1, green: 0, blue: 0, alpha: 1).pretty)\"")
//            Text("white -> \"\(Color.white.pretty)\"")
//            Text("black -> \"\(Color.black.pretty)\"")
        }
    }
}
@available(macOS 11, *)
#Preview("Pretty") {
    ColorPrettyTestView()
}

@available(macOS 11.0, tvOS 14, *)
public struct ColorTestView: View {
    public init() {}
    public var body: some View {
        TabView {
            ContrastingTestView()
                .colorTestWrapper()
                .tabItem {
                    Text("Contrast")
                }
            ColorsetsTestView()
                .padding()
                .colorTestWrapper()
                .tabItem {
                    Text("Colorset")
                }
            HSVConversionTestView()
                .colorTestWrapper()
                .tabItem {
                    Text("HSV")
                }
            ColorPrettyTestView()
                .padding()
                .colorTestWrapper()
                .tabItem {
                    Text("Pretty")
                }
            NamedColorsListTestView()
                .tabItem {
                    Text("Named CSS")
                }
            ColorTintingTestView()
                .colorTestWrapper()
                .tabItem {
                    Text("Tinting")
                }
        }
        .backport.tabViewStyle(.page)
        .closure { view in
#if os(macOS) || os(tvOS)
            view
#else
            view.ignoresSafeArea()
#endif
        }
    }
}

@available(macOS 11.0, tvOS 14, *)
#Preview("All Tests") {
    ColorTestView()
}

@available(watchOS 6.0, iOS 13, tvOS 13, *)
public extension View {
    static var bottomMargin: Double { 35 }
    func colorTestWrapper() -> some View {
        GeometryReader { proxy in // TODO: Move this to have scroll views within each tab rather than wrapping the tab view.  Might fix tvOS and macOS.
            ScrollView {
                self
                    .frame(minWidth: proxy.size.width, minHeight: proxy.size.height)
                    .closure { view in
                        Group {
                            if #available(iOS 17.0, macOS 14, tvOS 17, watchOS 10, *) {
                                view
                                    .safeAreaPadding(.init(top: 0, leading: 0, bottom: 20, trailing: 0))
                            } else {
                                // Fallback on earlier versions
                                view
                            }
                        }
                    }
            }
            .frame(minWidth: proxy.size.width, minHeight: proxy.size.height)
            .closure { view in
                Group {
                    if #available(iOS 17.0, macOS 99, tvOS 17, watchOS 10, *) {
                        view
                            .contentMargins(.bottom, Self.bottomMargin, for: .scrollIndicators)
                    } else {
                        // Fallback on earlier versions
                        view
                    }
                }
            }
        }
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

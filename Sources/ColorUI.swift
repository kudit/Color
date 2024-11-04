//
//  SwiftUIView.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if canImport(SwiftUI)
import SwiftUI
import Compatibility

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
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
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
struct SwatchTest: View {
    var color: Color
    var body: some View {
        Swatch(color: color, logo: true)
    }
}
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
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
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("HSV") {
    HSVConversionTestView()
}
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
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
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Color Tinting") {
    ColorTintingTestView()
}
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
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
                    SwatchTest(color: .accentColorBackport)
                    SwatchTest(color: .primary)
                    SwatchTest(color: .primaryBackport)
                    SwatchTest(color: .secondary)
                    SwatchTest(color: .secondaryBackport)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: Color(string:Color.pink.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.brownBackport.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.mintBackport.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.tealBackport.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.cyanBackport.hexString) ?? .black)
                    SwatchTest(color: Color(string:Color.indigoBackport.hexString) ?? .black)
                }
                VStack(spacing: 0) {
                    SwatchTest(color: .pink)
                    SwatchTest(color: .brownBackport)
                    SwatchTest(color: .mintBackport)
                    SwatchTest(color: .tealBackport)
                    SwatchTest(color: .cyanBackport)
                    SwatchTest(color: .indigoBackport)
                }
            }
            
        }.padding().backport.background { Color.gray }
    }
}
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Lightness") {
    ContrastingTestView()
}

@available(iOS 13, tvOS 13, watchOS 6, *)
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
                if #available(iOS 17, macOS 99, tvOS 17, watchOS 10, *) {
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
@available(iOS 13, tvOS 13, watchOS 6, *)
#Preview("Named") {
    NamedColorsListTestView()
}

@available(iOS 13, tvOS 13, watchOS 6, *)
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
                    if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
                        Text(color.pretty)
                            .font(.title.monospaced())
                            .bold()
                    } else {
                        // Fallback on earlier versions
                        Text(color.pretty)
                            .font(Font.custom("San Francisco", size: 28).monospacedDigit())
                            .bold()
                    }
                }
            }
            .padding()
            .backport.foregroundStyle(color.contrastingColor)
        }
    }
}

//#Preview("Pretty Swatch") {
//    PrettySwatch(source: "red")
//        .frame(height: 100)
//        .padding()
//}

@available(iOS 13, tvOS 13, watchOS 6, *)
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
@available(iOS 13, tvOS 13, watchOS 6, *)
#Preview("Pretty") {
    ColorPrettyTestView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
public struct SimpleDemoRainbowView: View {
    public init() {}
    public var body: some View {
        List {
            ForEach([Color].rainbow, id: \.pretty) { color in
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Compatibility v\(Compatibility.version)")
                    Spacer()
                }
                .foregroundColor(color)
            }
        }
    }
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Demo") {
    SimpleDemoRainbowView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 7, *)
public struct ColorTestView: View {
    public init() {}
    @State private var tabSelection = 0
    public var body: some View {
        TabView(selection: $tabSelection.animation()) {
            ContrastingTestView()
                .border(Color.accentColorAsset, width: 5)
                .colorTestWrapper()
                .tabItem {
                    Text("Contrast")
                }
                .tag(0)
            ColorsetsTestView()
                .padding()
                .colorTestWrapper()
                .tabItem {
                    Text("Colorset")
                }
                .tag(1)
            HSVConversionTestView()
                .colorTestWrapper()
                .tabItem {
                    Text("HSV")
                }
                .tag(2)
            ColorPrettyTestView()
                .padding()
                .colorTestWrapper()
                .tabItem {
                    Text("Pretty")
                }
                .tag(3)
            NamedColorsListTestView()
                .tabItem {
                    Text("Named CSS")
                }
                .tag(4)
            ColorTintingTestView()
                .colorTestWrapper()
                .tabItem {
                    Text("Tinting")
                }
                .tag(5)
            SimpleDemoRainbowView()
                .tabItem {
                    Text("Demo")
                }
                .tag(6)
            CodingDemoView()
                .tabItem {
                    Text("Coding")
                }
                .tag(7)
        }
        .backport.tabViewStyle(.page)
//        .tabViewStyle(.page(indexDisplayMode: .never))
//        .safeAreaInset(edge: .bottom) {
//            HStack(spacing: 6){
//                ForEach(0..<7, id: \.self) { i in
//                    Image(systemName: "circle.fill")
//                        .font(.system(size: 9))
//                        .foregroundStyle(tabSelection == i ? .primary : .tertiary)
//                }
//            }
//            .padding()
//            .background(.clear)
//        }
//        .closure { view in
//#if os(macOS) || os(tvOS)
//            view
//#else
//            view.ignoresSafeArea()
//#endif
//        }
    }
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 7, *)
#Preview("All Tests") {
    ColorTestView()
}

@available(watchOS 6, iOS 13, tvOS 13, *)
public extension View {
    static var bottomMargin: Double { 35 }
    func colorTestWrapper() -> some View {
        GeometryReader { proxy in // TODO: Move this to have scroll views within each tab rather than wrapping the tab view.  Might fix tvOS and macOS.
            ScrollView {
                self
                    .frame(minWidth: proxy.size.width, minHeight: proxy.size.height)
                    .closure { view in
                        Group {
                            if #available(iOS 17, macOS 14, tvOS 17, watchOS 10, *) {
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
                    if #available(iOS 17, macOS 99, tvOS 17, watchOS 10, *) {
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
@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
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

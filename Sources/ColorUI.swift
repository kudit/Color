//
//  SwiftUIView.swift
//  
//
//  Created by Ben Ku on 7/5/24.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
public struct Swatch: View {
    public var color: Color
    public var label: String?
    public var width: CGFloat
    public var height: CGFloat
    public var cornerRadius: CGFloat
    public init(color: Color, logo: Bool = false, width: CGFloat = 50, height: CGFloat = 50, cornerRadius: CGFloat = 15) {
        let label = logo ? nil : color.debugString
        self.init(color: color, label: label, width: width, height: height, cornerRadius: cornerRadius)
    }
    public init(color: Color, label: String?, width: CGFloat = 50, height: CGFloat = 50, cornerRadius: CGFloat = 15) {
        self.color = color
        self.label = label
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .frame(width: width, height: height)
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
            .backport.focusable()
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
                        Swatch(color: color.lighterColor, label: color.lighterColor.hexString)
                        Swatch(color: color)
                        Swatch(color: color.darkerColor, label: color.darkerColor.hexString)
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
    @State private var alphaSort = false

    // Parse every CSS color only once when this tab is first opened. The old
    // sort closure reconstructed both colors for every comparison during each
    // body evaluation, multiplying an already expensive conversion operation.
    private static let hueSortedEntries: [(key: String, value: String, color: Color)] =
        Color.namedColorMap
            .map { (key: $0.key, value: $0.value, color: Color(string: $0.value, defaultColor: .gray)) }
            .sorted { $0.color < $1.color }

    // Keep a separately cached alphabetical ordering so changing the picker
    // swaps arrays instead of sorting the complete CSS table again.
    private static let alphabeticallySortedEntries: [(key: String, value: String, color: Color)] =
        Color.namedColorMap
            .map { (key: $0.key, value: $0.value, color: Color(string: $0.value, defaultColor: .gray)) }
            .sorted { $0.key < $1.key }

    public var body: some View {
        List {
            Section {
                ForEach(alphaSort ? Self.alphabeticallySortedEntries : Self.hueSortedEntries, id: \.key) { entry in
                    HStack {
                        Text(entry.key)
                        Spacer()
                        Text(entry.value)
                    }
                    .padding()
                    .backport.background {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(entry.color)
                    }
                    .backport.foregroundStyle(entry.color.contrastingColor)
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
            } header: {
                Picker("Sort", selection: $alphaSort.animation()) {
                    Text("Hue").tag(false)
                    Text("Alphabetical").tag(true)
                }
                .pickerStyle(.segmentedBackport)
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
                        Text(color.stringValue)
                            .font(.title.monospaced())
                            .bold()
                    } else {
                        // Fallback on earlier versions
                        Text(color.stringValue)
                            .font(Font.custom("San Francisco", size: 28).monospacedDigit())
                            .bold()
                    }
                }
            }
            .padding()
            .backport.foregroundStyle(color.contrastingColor)
        }
        .backport.focusable()
    }
}

//@available(iOS 13, tvOS 13, watchOS 6, *)
//#Preview("Pretty Swatch") {
//    PrettySwatch(source: "red")
//        .frame(height: 100)
//        .padding()
//}

@available(iOS 13, tvOS 13, watchOS 6, *)
struct ColorPrettyTestView: View {
    let prettyTests = [
        "rEd",
        "rGb(0, 255, 0)",
        "rgBa(0, 0, 255, 1)",
        "rgba(255,  0, 128, 0.5)",
        "#ff0",
        "#c0ffee",
        "rgba(0,281,   0,1)", // expanded colorspace
        "white",
        "junkname",
        "#f006",
        "#00f30076",
    ]
    public var body: some View {
        List {
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
@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
#Preview("Pretty") {
    ColorPrettyTestView()
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
public extension CGColor {
    /// Returns a string in the form rgba(R,G,B,A) (should be URL safe as well). Will drop the alpha if it is 1.0 and do rgb(R,G,B) in double numbers from 0 to 255.
    var cssString: String {
        guard let components = components, components.count == 4 else {
            debug("Unable to convert CGColor: \(self) to CSS string")
            return "UNKNOWN"
        }
        return Color.cssFrom(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
    var hexString: String {
        guard let components = components, components.count == 4 else {
            debug("Unable to convert CGColor: \(self) to CSS string")
            return "UNKNOWN"
        }
        return Color.hexFrom(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}

@available(iOS 13, macOS 11, tvOS 13, watchOS 6, *)
public struct SimpleDemoRainbowView: View {
    @Environment(\.self) var environment
    @CloudStorage("chosenColor") var chosenColor = Color.accentColor
    @State var cgColor = CGColor(red: 1, green: 0, blue: 1, alpha: 1)
    
    func setColor(_ color: Color) {
        chosenColor = color
        cgColor = color.cgColorBackport
    }
    
    public init() {}
    public var body: some View {
        let binding = Binding<CGColor>(get: {
            return cgColor
        }, set: {
            cgColor = $0
            chosenColor = Color(cgColor: cgColor)
        })
        List {
			Section {
				Text("Color v\(Color.version) © \(String(Date.nowBackport.year)) Kudit LLC").font(.caption)
			}
            #if !os(tvOS) && !os(watchOS)
            if #available(iOS 14, macOS 11, *) {
                Section {
                    ColorPicker("Saved Color", selection: binding)
                    Swatch(color: Color(cgColor: cgColor), width: 300)
                    Text("Saved: \(Color(cgColor: cgColor).stringValue)")
                    Button("Set accent color") {
                        setColor(.accentColorBackport)
                    }
                }
            }
            #endif
            // KuColor already requires Hashable, so the color value provides a
            // stable row ID without performing the expensive CSS conversion.
            ForEach([Color].named, id: \.self) { color in
                HStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Compatibility v\(Compatibility.version) \(color.stringValue)")
                    Spacer()
                }
                .backport.onTapGesture {
                    setColor(color)
                }
                .backport.focusable()
                .foregroundColor(color)
            }
            if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
                Text("Color Background")
                    .testBackground()
            }
        }
        .onAppear {
            cgColor = chosenColor.cgColorBackport
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
    public var body: some View {
        // Keep every page as a stable, direct child. Replacing pages with lazy
        // placeholders during an interactive swipe can make UIKit transfer a
        // navigation item between navigation bars and can visibly jump when
        // SwiftUI constructs the destination hierarchy halfway through a gesture.
        // Let SwiftUI infer tab identity from the ordered children; the app does not need
        // programmatic selection, so integer tags would add maintenance without behavior.
        TabView {
            SimpleDemoRainbowView()
                .backport.accessibilityIdentifier("color.demo")
                .tabItem {
                    Backport.Label("Demo", systemImage: "paintpalette")
                }
            ColorsetsTestView()
                .padding()
                .colorTestWrapper()
                .backport.accessibilityIdentifier("color.colorset")
                .tabItem {
                    Backport.Label("Colorset", systemImage: "square.grid.2x2")
                }
            HSVConversionTestView()
                .colorTestWrapper()
                .backport.accessibilityIdentifier("color.hsv")
                .tabItem {
                    Backport.Label("HSV", systemImage: "slider.horizontal.3")
                }
            ColorPrettyTestView()
                .backport.accessibilityIdentifier("color.pretty")
                .tabItem {
                    Backport.Label("Pretty", systemImage: "wand.and.stars")
                }
            NamedColorsListTestView()
                .backport.accessibilityIdentifier("color.namedColors")
                .tabItem {
                    Backport.Label("Named CSS", systemImage: "list.bullet.rectangle")
                }
            ColorTintingTestView()
                .colorTestWrapper()
                .backport.accessibilityIdentifier("color.tinting")
                .tabItem {
                    Backport.Label("Tinting", systemImage: "paintbrush")
                }
            ContrastingTestView()
                .border(Color.accentColorAsset, width: 5)
                .colorTestWrapper()
                .backport.accessibilityIdentifier("color.contrast")
                .tabItem {
                    Backport.Label("Contrast", systemImage: "circle.lefthalf.filled")
                }
            CodingDemoView()
                .backport.accessibilityIdentifier("color.coding")
                .tabItem {
                    Backport.Label("Coding", systemImage: "doc.text")
                }
            RadialStack {
                Group {
                    ForEach([Color].rainbow, id: \.self) { color in
                        Circle().fill(color)
                    }
                }
                .frame(size: 80)
            }
            .backport.accessibilityIdentifier("color.rainbow")
            .tabItem {
                Backport.Label("Rainbow", systemImage: "rainbow")
            }
            if #available(iOS 15, macOS 12, tvOS 15, watchOS 8, *) {
                RadialTestView()
                    .accessibilityIdentifier("color.radialCompatibility")
                .tabItem {
                    Label("Radial Compatibility", systemImage: "arrow.triangle.2.circlepath")
                }
            }
#if compiler(>=5.9)
            if #available(iOS 15, macOS 12, tvOS 17, watchOS 8, *) {
                // Present Color's own ordered test catalog so Compatibility
                // supplies the enclosing module-and-version heading automatically.
                AllTestsListView()
                    .accessibilityIdentifier("color.allTests")
                .tabItem {
                    Label("All Tests", systemImage: "checkmark.seal")
                }
            }
#endif
        }
        .backport.tabViewStyle(.sidebarAdaptable)
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
    @MainActor
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

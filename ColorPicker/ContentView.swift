//
//  ContentView.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit

public enum QueryType: String, CaseIterable, Identifiable {
    case single
    case formatted
    public var id: Self { self }
}

struct InlineView: View {
    var parts: [CGFloat]

    var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Color").foregroundColor(.red)
                Text("(")
            }
            HStack(spacing: 0) {
                Text("red").foregroundColor(.blue)
                Text(": ")
                Text(num(parts[0])).foregroundColor(.green)
            }
            HStack(spacing: 0) {
                Text(", ")
                Text("green").foregroundColor(.blue)
                Text(": ")
                Text(num(parts[1])).foregroundColor(.green)
            }
            HStack(spacing: 0) {
                Text(", ")
                Text("blue").foregroundColor(.blue)
                Text(": ")
                Text(num(parts[2])).foregroundColor(.green)
            }
            HStack(spacing: 0) {
                Text(", ")
                Text("alpha").foregroundColor(.blue)
                Text(": ")
                Text(num(parts[3])).foregroundColor(.green)
            }
            HStack(spacing: 0) {
                Text(")")
            }
        }
        .scenePadding()
        .monospaced()
    }
}

struct FormattedView: View {
    var parts: [CGFloat]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("Color").foregroundColor(.red)
                    Text("(")
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("red").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[0])).foregroundColor(.green)
                    Text(", ")
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("green").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[1])).foregroundColor(.green)
                    Text(", ")
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("blue").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[2])).foregroundColor(.green)
                    Text(", ")
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("alpha").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[3])).foregroundColor(.green)
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(")")
                }
            }
        }
        .scenePadding()
        .monospaced()
    }
}

func num(_ result: Double) -> String {
    let value = String(format: "%g", result)
    return value
}

struct AppIconSetMaker {
    let sizes: [String: Double] = [
        "notification40.png": 20,
        "notification60.png": 20,
        "settings58.png": 29,
        "settings87.png": 29,
        "spotlight80.png": 40,
        "spotlight120.png": 40,
        "iphone120.png": 60,
        "iphone180.png": 60,
        "ipadNotification20.png": 20,
        "ipadNotification40.png": 20,
        "ipadSettings29.png": 29,
        "ipadSettings58.png": 29,
        "ipadSpotlight40.png": 40,
        "ipadSpotlight80.png": 40,
        "ipad76.png": 76,
        "ipad152.png": 76,
        "ipadPro167.png":  83.5,
        "appstore1024.png": 1024,
        "mac16.png": 16,
        "mac32.png": 16,
        "mac32.png": 32,
        "mac64.png": 32,
        "mac128.png": 128,
        "mac256.png": 128,
        "mac256.png": 256,
        "mac512.png": 256,
        "mac512.png": 512,
        "mac1024.png": 512
    ]


    func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {
        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        bitmapRepresentation.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)
        return bitmapRepresentation.representation(using: format, properties: [
            .interlaced: true
        ])
    }

    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"

        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }



    func savePNG(color: Color, imageName: String, path: URL) {
        let scale: CGFloat = 4
        let wrapper = NSHostingView(rootView: AppIcon(color: color).scaleEffect(scale))
        wrapper.frame = CGRect(x: 0, y: 0, width: AppIcon.size*scale, height: AppIcon.size*scale)
        let png = rasterize(view: wrapper, format: .png)
        do {
            try png?.write(to: path)
        } catch {
            print(error)
        }
    }

}

struct ContentView: View {
    // @AppStorage("Color") private var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    @State private var selectedColor: Color = .orange
    @State private var isOn: Bool = true
    @State private var showCode: Bool = false
    @State private var setEffect: Bool = false

    var toolbarBG: Color {
        return selectedColor.darker(by: 5)
    }

    let bouncyAnimation: Animation = .interpolatingSpring(stiffness: 200, damping: 15)
    let stiffBouncyAnimation: Animation = .interpolatingSpring(stiffness: 900, damping: 25)

    var body: some View {
        ZStack {
            selectedColor

            VStack {
                if let parts = NSColor(selectedColor).cgColor.components {
                    HStack {
                        ColorPicker("", selection: $selectedColor)
                        Button("Save Image") {
                            if let url = showSavePanel() {
                                savePNG(imageName: "cake", path: url)
                            }
                        }

                        Button("Copy", action: {
                            setToPasteboard()
                        })
                        .offset(y: setEffect ? 3 : 0)
                        .animation(stiffBouncyAnimation, value: setEffect)
                    }

                    if showCode {
                        Group {
                            if isOn {
                                FormattedView(parts: parts)
                            } else {
                                InlineView(parts: parts)
                            }
                        }
                        .transition(.scale.animation(bouncyAnimation).combined(with: .opacity.animation(bouncyAnimation)))
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(.secondary.opacity(0.4))
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.background.opacity(0.6))
                                )
                                .shadow(color: .secondary.opacity(0.4), radius: 20)
                        )
                        // .frame(width: .infinity)
                        .fixedSize()
                        .monospaced()
                        .toolbar {
                            ToolbarItem(placement: .automatic, content: {
                                HStack {
                                    Text("Formatted")
                                    Toggle("Formatted", isOn: $isOn)
                                        .toggleStyle(.switch)
                                }
                            })
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic, content: {
                    HStack {
                        Text("Show Code")
                        Toggle("Show Code", isOn: $showCode)
                            .toggleStyle(.switch)
                    }
                })
            }
            .animation(bouncyAnimation, value: selectedColor)
            .animation(bouncyAnimation, value: isOn)
            .navigationSubtitle(selectedColor.pasteboardText)
            .toolbarBackground(toolbarBG, for: .windowToolbar)
            .onChange(of: selectedColor, perform: { newColor in
                setDockIcon(newColor)
            })
            .task {
                setDockIcon(selectedColor)
            }
        }
    }

    func setDockIcon(_ color: Color) {
        let dockView = AppIcon(color: color) //.frame(width: 512, height: 512)
        NSApp.dockTile.contentView = NSHostingView(rootView: dockView)
        NSApp.dockTile.display()
    }

    func setToPasteboard() {
        withAnimation(bouncyAnimation) {
            setEffect = true

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) {
                setEffect = false
            }
        }
        let content = selectedColor.pasteboardText
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
    }
}

extension Color {
    var pasteboardText: String {
        if let parts = NSColor(self).cgColor.components {
            return "Color(red: \(num(parts[0])), green: \(num(parts[1])), blue: \(num(parts[2])), alpha: \(num(parts[3])))"
        } else {
            return self.description
        }
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard let hsbColor = NSColor(self).usingColorSpace(NSColorSpace.deviceRGB) else {
            return (r, g, b, o)
        }

        r = hsbColor.redComponent
        g = hsbColor.greenComponent
        b = hsbColor.blueComponent
        o = hsbColor.alphaComponent

        return (r, g, b, o)
    }

    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> Color {
        return Color(red: min(Double(self.components.red + percentage/100), 1.0),
                     green: min(Double(self.components.green + percentage/100), 1.0),
                     blue: min(Double(self.components.blue + percentage/100), 1.0),
                     opacity: Double(self.components.opacity))
    }
}
struct ContentView_Previews: PreviewProvider {
    static let parts = NSColor(Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)).cgColor.components!

    static var previews: some View {
        Group {
            InlineView(parts: parts)
                .previewDisplayName("Inline")
            FormattedView(parts: parts)
                .previewDisplayName("Formatted")
        }
    }
}

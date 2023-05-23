//
//  ContentView.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers

func num(_ result: Double) -> String {
    let value = String(format: "%g", result)
    return value
}

struct ContentView: View {
    @AppStorage("Color") private var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    // @State private var selectedColor: Color = .orange
    @State private var isOn: Bool = true
    @State private var showCode: Bool = false
    @State private var setEffect: Bool = false
    @AppStorage("showAlpha") private var showAlpha: Bool = false

    var toolbarBG: Color {
        return selectedColor.darker(by: 5)
    }

    let bouncyAnimation: Animation = .interpolatingSpring(stiffness: 200, damping: 15)
    let stiffBouncyAnimation: Animation = .interpolatingSpring(stiffness: 900, damping: 25)

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        ZStack {
            selectedColor

            VStack {
                if let parts = NSColor(selectedColor).cgColor.components {
                    HStack {
                        Button("Pick Color") {
                            Task {
                                if let color = await NSColorSampler().sample() {
                                    selectedColor = Color(nsColor: color)
                                    setToPasteboard()
                                }
                            }
                        }
                        .offset(y: setEffect ? 3 : 0)
                        .animation(stiffBouncyAnimation, value: setEffect)

                        // Button("Save Image") {
                        //     openWindow(value: selectedColor)
                        // }
                        //
                        // Button("Copy", action: {
                        //     setToPasteboard()
                        // })
                        // .offset(y: setEffect ? 3 : 0)
                        // .animation(stiffBouncyAnimation, value: setEffect)
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

                ToolbarItem(placement: .automatic, content: {
                    HStack {
                        Text("Show Alpha")
                        Toggle("Show Alpha", isOn: $showAlpha)
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
        let dockView = AppIcon(size: 130, color: color) //.frame(width: 512, height: 512)
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
        let content = showAlpha ? selectedColor.pasteboardTextWithAlpha : selectedColor.pasteboardText
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
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

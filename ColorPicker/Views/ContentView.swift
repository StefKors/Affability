//
//  ContentView.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit
import UniformTypeIdentifiers
import ViewToAppIconSet

func num(_ result: Double) -> String {
    let value = String(format: "%g", result)
    return value
}

struct ContentView: View {
    @EnvironmentObject private var model: MyAppDelegate

    var body: some View {
        ZStack {
            // Colours the full background
            model.selectedColor

            VStack {
                ScrollView {
                    VStack {
                        ForEach(model.colorHistory.sorted(by: { $0.createdAt > $1.createdAt })) { color in
                            HistoryColorView(color: color)
                                .transition(.move(edge: .top))
                        }
                        .animation(.interpolatingSpring(stiffness: 300, damping: 15), value: model.colorHistory)

                        if !model.colorHistory.isEmpty {
                            Button("clear history") {
                                withAnimation(.spring()) {
                                    model.colorHistory = []
                                }
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .scenePadding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic, content: {
                    Button {
                        Task {
                            if let color = await NSColorSampler().sample() {
                                model.selectedColor = Color(nsColor: color)

                                withAnimation(.easeInOut) {
                                    model.theme = color.windowTheme
                                }
                            }
                        }
                    } label: {
                        Label("Pick Color", systemImage: "eyedropper.halffull")
                    }
                    .offset(y: model.setEffect ? 3 : 0)
                    .animation(model.stiffBouncyAnimation, value: model.setEffect)
                })
            }
            .animation(model.bouncyAnimation, value: model.selectedColor)
            .animation(model.bouncyAnimation, value: model.isOn)
            .navigationSubtitle(model.selectedColor.pasteboardText)
            .toolbarBackground(model.toolbarBG, for: .windowToolbar)
            .task {
                model.initDockIcon()
                model.setToPasteboard()
                withAnimation(.easeInOut) {
                    model.theme = model.selectedColor.windowTheme
                }
            }
            .preferredColorScheme(model.theme)
        }
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

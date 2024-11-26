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
import BottomSheet

func num(_ result: Double) -> String {
    let value = String(format: "%g", result)
    return value
}

enum ColorStyle: String, CaseIterable {
    case SwiftUI
    case NSColor
    case UIColor
    case Hex
    case rgb
}

struct ContentView: View {
    @EnvironmentObject private var model: MyAppDelegate
    @AppStorage("inspector") private var showInspector: Bool = true
    @State var bottomSheetPosition: BottomSheetPosition = .dynamicTop

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
                    Picker("Color style", selection: $model.colorStyle) {
                        ForEach(ColorStyle.allCases, id: \.rawValue) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(idealWidth: 200)
                })

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

                if #available(macOS 14.0, *) {
                    ToolbarItem(placement: .automatic, content: {
                        Button {
                            showInspector.toggle()
                        } label: {
                            Label("Inspector", systemImage: "sidebar.right")
                        }
                        .offset(y: model.setEffect ? 3 : 0)
                        .animation(model.stiffBouncyAnimation, value: model.setEffect)
                    })
                }
            }

            .animation(model.bouncyAnimation, value: model.selectedColor)
            .animation(model.bouncyAnimation, value: model.isOn)
            .navigationSubtitle(model.selectedColor.pasteboardText(style: model.colorStyle, withAlpha: model.showAlpha))
            .toolbarBackground(model.toolbarBG, for: .windowToolbar)
            .task {
                model.initDockIcon()
                model.setToPasteboard()
                withAnimation(.easeInOut) {
                    model.theme = model.selectedColor.windowTheme
                }
            }
            .preferredColorScheme(model.theme)
            .overlay(alignment: .bottom, content: {
                VStack {
                    InspectorContentView(selectedColor: model.selectedColor)
                        .scenePadding()
                }
                .frame(maxHeight: 200)
                .background(.ultraThinMaterial, in: UnevenRoundedRectangle(topLeadingRadius: 22, topTrailingRadius: 22))
                .offset(y: showInspector ? 0 : 200)
                .animation(.snappy, value: showInspector)
            })
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
        .scenePadding()
    }
}


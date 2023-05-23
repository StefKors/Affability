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
    @EnvironmentObject private var model: Model

    var body: some View {
        ZStack {
            model.selectedColor

            VStack {
                if let parts = NSColor(model.selectedColor).cgColor.components {
                    HStack {
                        Button("Pick Color") {
                            Task {
                                if let color = await NSColorSampler().sample() {
                                    model.selectedColor = Color(nsColor: color)
                                }
                            }
                        }
                        .offset(y: model.setEffect ? 3 : 0)
                        .animation(model.stiffBouncyAnimation, value: model.setEffect)
                    }

                    if model.showCode {
                        Group {
                            if model.isOn {
                                FormattedView(parts: parts)
                            } else {
                                InlineView(parts: parts)
                            }
                        }
                        .transition(.scale.animation(model.bouncyAnimation).combined(with: .opacity.animation(model.bouncyAnimation)))
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
                                    Toggle("Formatted", isOn: $model.isOn)
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
                        Toggle("Show Code", isOn: $model.showCode)
                            .toggleStyle(.switch)
                    }
                })

                ToolbarItem(placement: .automatic, content: {
                    HStack {
                        Text("Show Alpha")
                        Toggle("Show Alpha", isOn: $model.showAlpha)
                            .toggleStyle(.switch)
                    }
                })
            }
            .animation(model.bouncyAnimation, value: model.selectedColor)
            .animation(model.bouncyAnimation, value: model.isOn)
            .navigationSubtitle(model.selectedColor.pasteboardText)
            .toolbarBackground(model.toolbarBG, for: .windowToolbar)
            // .onChange(of: model.selectedColor, perform: { _ in
            //     setToPasteboard()
            //     updateDockIcon()
            // })
            .task {
                model.initDockIcon()
                model.setToPasteboard()
            }
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

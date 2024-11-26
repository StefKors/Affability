//
//  InspectorContentView.swift
//  ColorPicker
//
//  Created by Stef Kors on 06/11/2024.
//

import SwiftUI

struct InspectorContentView: View {
    let selectedColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(ColorStyle.allCases, id: \.rawValue) { style in
                if let parts = selectedColor.cgColor?.components {
                    InlineView(style: style, parts: parts)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 7)
                        .background(.background.opacity(0.7), in: RoundedRectangle(cornerRadius: 6))
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(lineWidth: 1)
                                .foregroundStyle(.background)
                                .opacity(0.8)
                        })
                }
//                GroupBox(label: Text(style.rawValue).tag(style), content: {
//                    if let parts = selectedColor.cgColor?.components {
//                        InlineView(style: style, parts: parts)
//                            .padding(.vertical, 4)
//                            .padding(.horizontal, 7)
//                            .background(.background.opacity(0.7), in: RoundedRectangle(cornerRadius: 6))
//                            .overlay(content: {
//                                RoundedRectangle(cornerRadius: 6, style: .continuous)
//                                    .stroke(lineWidth: 1)
//                                    .foregroundStyle(.background)
//                                    .opacity(0.8)
//                            })
//                    }
////                    Text(model.selectedColor.pasteboardText(style: style, withAlpha: model.showAlpha))
//                })
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InspectorContentView(selectedColor: Color(hex: "#23BB3f"))
        .frame(width: 600, height: 800)
        .scenePadding()
}

struct OptionalInspectorViewModifier: ViewModifier {
    var showInspector: Binding<Bool>

    @EnvironmentObject private var model: MyAppDelegate
    func body(content: Content) -> some View {
        if #available(macOS 14.0, *) {
            content
            // perhaps sheet?
//                .sheet(isPresented: showInspector, content: {
//                    InspectorContentView()
//                })
                .inspector(isPresented: showInspector, content: {
                    InspectorContentView(selectedColor: model.selectedColor)
                })
        } else {
            content
        }
    }
}

extension View {
    func optionalInspector(isPresented: Binding<Bool>) -> some View {
        modifier(OptionalInspectorViewModifier(showInspector: isPresented))
    }
}

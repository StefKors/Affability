//
//  HistoryColorView.swift
//  ColorPicker
//
//  Created by Stef Kors on 19/06/2023.
//

import SwiftUI

struct HistoryColorView: View {
    let color: HistoricalColor

    @State private var isHovering: Bool = false
    @State private var setEffect: Bool = false
    private let stiffBouncyAnimation: Animation = .interpolatingSpring(stiffness: 900, damping: 25)
    var body: some View {
        if let parts = NSColor(color.value).cgColor.components {
            ViewThatFits {
                // if isHovering {
                //     InlineView(parts: parts)
                //         .padding(.vertical, 4)
                //         .padding(.horizontal, 7)
                //         .background(.background.opacity(0.7), in: RoundedRectangle(cornerRadius: 6))
                //         .overlay(content: {
                //             RoundedRectangle(cornerRadius: 6, style: .continuous)
                //                 .stroke(lineWidth: 1)
                //                 .foregroundStyle(.background)
                //                 .opacity(0.8)
                //         })
                //     
                //     FormattedView(parts: parts)
                //         .padding(.vertical, 4)
                //         .padding(.horizontal, 7)
                //         .background(.background.opacity(0.7), in: RoundedRectangle(cornerRadius: 6))
                //         .overlay(content: {
                //             RoundedRectangle(cornerRadius: 6, style: .continuous)
                //                 .stroke(lineWidth: 1)
                //                 .foregroundStyle(.background)
                //                 .opacity(0.8)
                //         })
                // }
            }
            .padding()
            .frame(minWidth: 200, maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.value)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.background)
                            .opacity(0.8)
                    })
                    .shadow(radius: 20)
                    .overlay(alignment: .center) {

                    }
            }
            .offset(y: setEffect ? 3 : 0)
            .animation(stiffBouncyAnimation, value: setEffect)
            .onTapGesture {
                color.value.copyToPasteboard()
                withAnimation(stiffBouncyAnimation) {
                    setEffect = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) {
                        self.setEffect = false
                    }
                }
            }
            .onHover { hoverState in
                isHovering = hoverState
            }

        }


    }
}

struct HistoryColorView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryColorView(color: HistoricalColor.preview)
    }
}

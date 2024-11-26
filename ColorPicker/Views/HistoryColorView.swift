//
//  HistoryColorView.swift
//  ColorPicker
//
//  Created by Stef Kors on 19/06/2023.
//

import SwiftUI

struct HistoryColorView: View {
    @EnvironmentObject private var model: MyAppDelegate
    let color: HistoricalColor

    @State private var setEffect: Bool = false
    private let stiffBouncyAnimation: Animation = .interpolatingSpring(stiffness: 900, damping: 25)
    var body: some View {
        ViewThatFits {}
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
        }
        .offset(y: setEffect ? 3 : 0)
        .animation(stiffBouncyAnimation, value: setEffect)
        .onTapGesture {
            color.value.copyToPasteboard(style: model.colorStyle)
            withAnimation(stiffBouncyAnimation) {
                setEffect = true

                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) {
                    self.setEffect = false
                }
            }
        }
    }
}

struct HistoryColorView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryColorView(color: HistoricalColor.preview)
    }
}

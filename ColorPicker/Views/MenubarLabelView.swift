//
//  MenubarLabelView.swift
//  ColorPicker
//
//  Created by Stef Kors on 23/05/2023.
//

import SwiftUI

struct MenubarLabelView: View {
    @AppStorage("Color") private var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(selectedColor)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.background)
                    .opacity(0.3)
            })
            .padding(3)
            .frame(width: 20, height: 20)
    }
}

struct MenubarLabelView_Previews: PreviewProvider {
    static var previews: some View {
        MenubarLabelView()
            .scenePadding()
    }
}

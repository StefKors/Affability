//
//  MenuItemView.swift
//  ColorPicker
//
//  Created by Stef Kors on 19/06/2023.
//

import SwiftUI

struct MenuItemView: View {
    let label: String
    @AppStorage("Color") private var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    var body: some View {
        HStack {
            MenubarLabelView()
            Text(label)
        }
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemView(label: "Color RGB")
    }
}

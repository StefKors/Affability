//
//  InlineView.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import SwiftUI

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

struct InlineView_Previews: PreviewProvider {
    static var previews: some View {
        InlineView(parts: [1, 1, 1, 1])
    }
}

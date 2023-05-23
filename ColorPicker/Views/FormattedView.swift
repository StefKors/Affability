//
//  FormattedView.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import SwiftUI

struct FormattedView: View {
    @AppStorage("showAlpha") private var showAlpha: Bool = false
    var parts: [CGFloat]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("Color").foregroundColor(.red)
                    Text("(")
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("red").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[0])).foregroundColor(.green)
                    Text(", ")
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("green").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[1])).foregroundColor(.green)
                    Text(", ")
                }
            }.padding(.leading)
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("blue").foregroundColor(.blue)
                    Text(": ")
                    Text(num(parts[2])).foregroundColor(.green)
                    if showAlpha {
                        Text(", ")
                    }
                }
            }.padding(.leading)
            if showAlpha {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("alpha").foregroundColor(.blue)
                        Text(": ")
                        Text(num(parts[3])).foregroundColor(.green)
                    }
                }.padding(.leading)
            }
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text(")")
                }
            }
        }
        .scenePadding()
        .monospaced()
    }
}

struct FormattedView_Previews: PreviewProvider {
    static var previews: some View {
        FormattedView(parts: [1, 1, 1, 1])
    }
}

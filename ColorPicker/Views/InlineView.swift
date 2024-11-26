//
//  InlineView.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import SwiftUI

struct InlineView: View {
    @AppStorage("showAlpha") var showAlpha: Bool = true

    var style: ColorStyle = .SwiftUI
    var parts: [CGFloat]

    private var hex: String? {
        Color(parts: parts).toHex(alpha: showAlpha)
    }

    var body: some View {
        ZStack {
            switch style {
            case .Hex:
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("#" + (hex ?? "")).foregroundColor(.green)
                    }
                }
            case .rgb:
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(style.rawValue).foregroundColor(.red)
                        if showAlpha {
                            Text("a").foregroundColor(.red)
                        }
                        Text("(")
                    }
                    HStack(spacing: 0) {
                        Text(num(parts[0]*255.0)).foregroundColor(.green)
                    }
                    HStack(spacing: 0) {
                        Text(", ")
                        Text(num(parts[1]*255.0)).foregroundColor(.green)
                    }
                    HStack(spacing: 0) {
                        Text(", ")
                        Text(num(parts[2]*255.0)).foregroundColor(.green)
                    }
                    if showAlpha {
                        HStack(spacing: 0) {
                            Text(", ")
                            Text("alpha").foregroundColor(.blue)
                            Text(": ")
                            Text(num(parts[3]*255.0)).foregroundColor(.green)
                        }
                    }
                    HStack(spacing: 0) {
                        Text(")")
                    }
                }
            default:
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(style.rawValue).foregroundColor(.red)
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
                    if showAlpha {
                        HStack(spacing: 0) {
                            Text(", ")
                            Text("alpha").foregroundColor(.blue)
                            Text(": ")
                            Text(num(parts[3])).foregroundColor(.green)
                        }
                    }
                    HStack(spacing: 0) {
                        Text(")")
                    }
                }
            }
        }
        .monospaced()
    }
}

struct InlineView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ForEach(ColorStyle.allCases, id: \.rawValue) { style in
                InlineView(style: style, parts: [1, 1, 1, 0.3])
                    .padding(4)
            }
        }
        .scenePadding()
    }
}

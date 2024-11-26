//
//  FormattedView.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import SwiftUI

struct FormattedView: View {
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
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(style.rawValue).foregroundColor(.red)
                            Text("(")
                        }
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("#" + (hex ?? "")).foregroundColor(.green)
                        }
                    }.padding(.leading)
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(")")
                        }
                    }
                }
            default:
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text(style.rawValue).foregroundColor(.red)
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
            }
        }
        .monospaced()
    }
}

struct FormattedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            FormattedView(style: .SwiftUI, parts: [1, 1, 1, 0.3])
                .scenePadding()

            FormattedView(style: .Hex, parts: [1, 1, 1, 0.3])
                .scenePadding()
        }
        .scenePadding()
    }
}

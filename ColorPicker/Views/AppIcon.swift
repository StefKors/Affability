//
//  AppIcon.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit
import ViewToAppIconSet

struct AppIcon: View {
    @AppStorage("Color") private var color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)

    @IconRelativeMetric private var padding = 7
    @IconRelativeMetric private var cornerRadius = 10
    @IconRelativeMetric private var shadowS = 1.5
    @IconRelativeMetric private var shadowM = 2
    @IconRelativeMetric private var shadowL = 3
    @IconRelativeMetric private var shadowXL = 5

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
            .fill(color)
            .shadow(color: .black.opacity(0.2), radius: shadowS, y: shadowS)
            .overlay {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        color.lighter(by: 20),
                                        color.darker(by: 5),
                                    ]
                                ),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )

                    Circle()
                        .stroke(color.darker(by: 2), lineWidth: 1)
                }
                .shadow(color: color.darker(by: 10), radius: shadowXL, y: -shadowL)
                .shadow(color: color.darker(by: 10).opacity(0.3), radius: shadowL, x: -shadowL, y: -shadowL)
                .shadow(color: color.lighter(by: 10).opacity(0.2), radius: shadowM, x: shadowM, y: shadowM)
                .padding(padding)
            }
    }
}

// struct AppIcon_Previews: PreviewProvider {
//     static var previews: some View {
//         VStack {
//             HStack {
//                 AppIcon(color: Color(red: 0.8, green: 0.8, blue: 0.3))
//                     .iconStyle(.macOS)
//                     .frame(width: 128, height: 128)
//                 AppIcon(color: .green)
//                     .iconStyle(.macOS)
//                     .frame(width: 128, height: 128)
//             }
// 
//             HStack {
//                 AppIcon(color: .purple)
//                     .iconStyle(.macOS)
//                     .frame(width: 128, height: 128)
// 
//                 AppIcon(color: .orange)
//                     .iconStyle(.macOS)
//                     .frame(width: 128, height: 128)
// 
//             }
//         }
//         .previewDisplayName("grid")
// 
//     }
// }

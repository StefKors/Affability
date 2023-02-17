//
//  AppIcon.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit

struct AppIcon: View {
    var size: CGFloat
    var color: Color
    static let defaultSize: CGFloat = 130

    var body: some View {
        let padd: CGFloat = size >= 256 ? 20 : 12
        RoundedRectangle(cornerRadius: size*0.1, style: .circular)
            .fill(color)
            .shadow(color: .black.opacity(0.2), radius: size*0.015, y: size*0.015)
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

                        // .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))

                    Circle()
                        .stroke(color.darker(by: 2), lineWidth: 1)
                }
                .shadow(color: color.darker(by: 10), radius: size*0.076, y: -size*0.038)
                .shadow(color: color.darker(by: 10).opacity(0.3), radius: size*0.038, x: -size*0.038, y: -size*0.038)
                .shadow(color: color.lighter(by: 10).opacity(0.2), radius: size*0.030, x: size*0.023, y: size*0.023)
                .padding(size*0.1)
            }
            .clipShape(RoundedRectangle(cornerRadius: size*0.15, style: .continuous))
            .padding(padd)
            .shadow(color: .black.lighter(by: 30).opacity(0.3), radius: size*0.011, y: -size*0.021)
            .frame(width: size, height: size)
            // .scaledToFit()
            // .shadow(radius: 20, y: 10)
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                AppIcon(size: 32, color: Color(red: 0.8, green: 0.8, blue: 0.3))
                    .frame(width: 32, height: 32)

                AppIcon(size: 32, color: .pink)
                    .frame(width: 32, height: 32)

                AppIcon(size: 32, color: .green)
                    .frame(width: 32, height: 32)
            }

            HStack {
                AppIcon(size: 32, color: .purple)
                    .frame(width: 32, height: 32)

                AppIcon(size: 32, color: .brown)
                    .frame(width: 32, height: 32)

                AppIcon(size: 32, color: .orange)
                    .frame(width: 32, height: 32)
            }
        }
        .previewDisplayName("all sizes small")

        VStack {
            HStack {
                AppIcon(size: 62, color: Color(red: 0.8, green: 0.8, blue: 0.3))
                    .frame(width: 62, height: 62)

                AppIcon(size: 62, color: .pink)
                    .frame(width: 62, height: 62)

                AppIcon(size: 62, color: .green)
                    .frame(width: 62, height: 62)
            }

            HStack {
                AppIcon(size: 62, color: .purple)
                    .frame(width: 62, height: 62)

                AppIcon(size: 62, color: .brown)
                    .frame(width: 62, height: 62)

                AppIcon(size: 62, color: .orange)
                    .frame(width: 62, height: 62)
            }
        }
        .previewDisplayName("all sizes medium")


            HStack {
                AppIcon(size: 256, color: Color(red: 0.8, green: 0.8, blue: 0.3))
                    .frame(width: 256, height: 256)

                AppIcon(size: 256, color: .pink)
                    .frame(width: 256, height: 256)

                AppIcon(size: 256, color: .green)
                    .frame(width: 256, height: 256)
            }.previewDisplayName("all sizes large")

        VStack {
            HStack {
                AppIcon(size: 130, color: Color(red: 0.8, green: 0.8, blue: 0.3))
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)

                AppIcon(size: 130, color: .pink)
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)

                AppIcon(size: 130, color: .green)
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)
            }

            HStack {
                AppIcon(size: 130, color: .purple)
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)

                AppIcon(size: 130, color: .brown)
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)

                AppIcon(size: 130, color: .orange)
                    .frame(width: AppIcon.defaultSize, height: AppIcon.defaultSize)
            }
        }
        .previewDisplayName("grid")

        AppIcon(size: 130, color: Color(red: 0.8, green: 0.8, blue: 0.3))
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("red")

        AppIcon(size: 130, color: .pink)
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("accent")

        AppIcon(size: 130, color: .green)
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("green")

        AppIcon(size: 130, color: .purple)
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("purple")

        AppIcon(size: 130, color: .brown)
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("brown")

        AppIcon(size: 130, color: .orange)
            .previewLayout(.fixed(width: AppIcon.defaultSize, height: AppIcon.defaultSize))
            .previewDisplayName("orange")
    }
}

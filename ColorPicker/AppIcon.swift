//
//  AppIcon.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit

struct AppIcon: View {
    var color: Color
    static let size: CGFloat = 130

    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(color)
            .shadow(color: .black.opacity(0.2), radius: 2, y: 2)
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
                .shadow(color: color.darker(by: 10), radius: 10, y: -5)
                .shadow(color: color.darker(by: 10).opacity(0.3), radius: 5, x: -5, y: -5)
                .shadow(color: color.lighter(by: 10).opacity(0.2), radius: 4, x: 3, y: 3)
                .padding(13)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(12)
            .frame(width: Self.size, height: Self.size)
            .shadow(color: .black.lighter(by: 30).opacity(0.5), radius: 2, y: -2)
            // .shadow(radius: 20, y: 10)
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {

        VStack {
            HStack {
                AppIcon(color: Color(red: 0.8, green: 0.8, blue: 0.3))
                    .frame(width: AppIcon.size, height: AppIcon.size)

                AppIcon(color: .pink)
                    .frame(width: AppIcon.size, height: AppIcon.size)

                AppIcon(color: .green)
                    .frame(width: AppIcon.size, height: AppIcon.size)
            }

            HStack {
                AppIcon(color: .purple)
                    .frame(width: AppIcon.size, height: AppIcon.size)

                AppIcon(color: .brown)
                    .frame(width: AppIcon.size, height: AppIcon.size)

                AppIcon(color: .orange)
                    .frame(width: AppIcon.size, height: AppIcon.size)
            }
        }
        .previewDisplayName("grid")

        AppIcon(color: Color(red: 0.8, green: 0.8, blue: 0.3))
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("red")

        AppIcon(color: .pink)
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("accent")

        AppIcon(color: .green)
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("green")

        AppIcon(color: .purple)
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("purple")

        AppIcon(color: .brown)
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("brown")

        AppIcon(color: .orange)
            .previewLayout(.fixed(width: AppIcon.size, height: AppIcon.size))
            .previewDisplayName("orange")
    }
}

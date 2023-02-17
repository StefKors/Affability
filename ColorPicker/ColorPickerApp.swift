//
//  ColorPickerApp.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit

@main
struct ColorPickerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowResizability(.contentMinSize)

        WindowGroup(for: Color.ID.self) { $icon in
            if let color = $icon.wrappedValue {
                AppIconContentView(color: color)
            }
        }
    }
}

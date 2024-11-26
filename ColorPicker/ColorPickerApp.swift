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
    @NSApplicationDelegateAdaptor private var appDelegate: MyAppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate)
                .frame(maxWidth: 800)
        }
        .windowResizability(.contentSize)
    }
}

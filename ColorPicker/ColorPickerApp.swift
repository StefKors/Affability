//
//  ColorPickerApp.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//

import SwiftUI
import AppKit


@MainActor class Model: ObservableObject {
    @AppStorage("Color") var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2) {
        didSet {
            setToPasteboard()
            updateDockIcon()
        }
    }
    @AppStorage("showAlpha") var showAlpha: Bool = false
    @Published var isOn: Bool = true
    @Published var showCode: Bool = false
    @Published var setEffect: Bool = false

    var toolbarBG: Color {
        return selectedColor.darker(by: 5)
    }

    let bouncyAnimation: Animation = .interpolatingSpring(stiffness: 200, damping: 15)
    let stiffBouncyAnimation: Animation = .interpolatingSpring(stiffness: 900, damping: 25)

    /// On multiple calls to this method the dock icon can become wrongly sized
    func initDockIcon() {
        let size = NSApp.dockTile.size
        let dockView = AppIcon()
            .iconStyle(.macOS)
            .frame(width: size.width, height: size.height)
        NSApp.dockTile.contentView = NSHostingView(rootView: dockView)
        NSApp.dockTile.display()
    }

    func updateDockIcon() {
        NSApp.dockTile.display()
    }

    func setToPasteboard() {
        withAnimation(bouncyAnimation) {
            setEffect = true

            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(120)) {
                self.setEffect = false
            }
        }
        let content = showAlpha ? selectedColor.pasteboardTextWithAlpha : selectedColor.pasteboardText
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
    }
}

class MyAppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    @AppStorage("Color") var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let iconView = NSHostingView(rootView: MenubarLabelView())
        iconView.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.addSubview(iconView)
        statusItem.button?.frame = iconView.frame
        statusItem.button?.action = #selector(self.statusBarButtonClicked(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        self.statusItem = statusItem
    }

    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        Task {
            if let color = await NSColorSampler().sample() {
                selectedColor = Color(nsColor: color)
                await NSApp.dockTile.display()
            }
        }
    }
}

@main
struct ColorPickerApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: MyAppDelegate
    @StateObject private var model = Model()
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }.windowResizability(.contentMinSize)

        // MenuBarExtra {
        //     ContentView()
        // } label: {
        //     Label {
        //         Text("test")
        //     } icon: {
        //         // Image(systemName: "circle")
        //         // MenubarLabelView()
        //         Rectangle().fill(.blue)
        //     }
        //
        // }
        //
        //
        // MenuBarExtra(isInserted: $showMenuBarExtra) {
        //     ContentView()
        // } label: {
        //     MenubarLabelView()
        // }
        // .menuBarExtraStyle(.window)

    }
}

//
//  MyAppDelegate.swift
//  ColorPicker
//
//  Created by Stef Kors on 26/11/2024.
//

import SwiftUI
import AppKit

@MainActor class MyAppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, ObservableObject {
    @AppStorage("Color") var selectedColor = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2) {
        didSet {
            setToPasteboard()
            updateDockIcon()
            addColorToHistory()
        }
    }

    @AppStorage("ColorHistory") var colorHistory: [HistoricalColor] = []
    @AppStorage("showAlpha") var showAlpha: Bool = false
    @AppStorage("ColorStyle") var colorStyle: ColorStyle = .SwiftUI {
        didSet {
            self.refreshRightClickMenu()
        }
    }
    @Published var isOn: Bool = true
    @Published var showCode: Bool = false
    @Published var setEffect: Bool = false
    @Published var theme: ColorScheme?

    var statusItem: NSStatusItem?
    var statusBarMenu: NSMenu!

    let anchor = NSMenuItem(title: "Set Color Style", action: nil, keyEquivalent: "")

    var selectedColorLabel: String {
        selectedColor.pasteboardText(style: self.colorStyle, withAlpha: showAlpha)
    }

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
        let content = selectedColorLabel
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
    }

    func addColorToHistory() {
        if selectedColor != colorHistory.last?.value {
            let val = HistoricalColor(id: UUID().uuidString, createdAt: Date.now, value: selectedColor)
            colorHistory.append(val)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let iconView = NSHostingView(rootView: MenubarLabelView())
        iconView.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.addSubview(iconView)
        statusItem.button?.frame = iconView.frame
        statusItem.button?.action = #selector(self.statusBarButtonClicked(_:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        statusBarMenu = NSMenu(title: "Status Bar Menu")
        statusBarMenu.delegate = self
        self.statusItem = statusItem
    }

    @objc func copyToPasteboard() {
        let content = selectedColorLabel
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(content, forType: .string)
        pasteboard.setString(content, forType: .rtf)
    }

    @objc func selectColorStyle(_ sender: NSMenuItem) {
        if let style = ColorStyle(rawValue: sender.title) {
            print("selected \(style)")
            colorStyle = style
        }
    }

    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        if let event = NSApp.currentEvent,
           event.type == NSEvent.EventType.rightMouseUp {
            rightMouseUp()
        } else {
            leftMouseUp()
        }
    }

    @objc func menuDidClose(_ menu: NSMenu) {
        statusItem?.menu = nil // remove menu so button works as before
    }

    func leftMouseUp() {
        Task {
            if let color = await NSColorSampler().sample() {
                selectedColor = Color(nsColor: color)
                NSApp.dockTile.display()
                withAnimation(.easeInOut) {
                    self.theme = color.windowTheme
                }
            }
        }
    }

    func refreshRightClickMenu() {
        statusItem?.menu = nil
        statusBarMenu.items = []

        let submenu = NSMenu(title: "Set Color Style")

        for style in ColorStyle.allCases {
            let item = NSMenuItem(
                title: style.rawValue,
                action: #selector(self.selectColorStyle),
                keyEquivalent: ""
            )
            item.state = style == self.colorStyle ? .on : .off
            submenu.addItem(item)
        }

        // set current item
        // if #available(macOS 14.0, *) {
        //     anchor.badge = NSMenuItemBadge(string: self.colorStyle.rawValue)
        // } else {
        //     // Fallback on earlier versions
        // }
        statusBarMenu.addItem(anchor)
        statusBarMenu.setSubmenu(submenu, for: anchor)

        statusBarMenu.addItem(.separator())

        for color in colorHistory.sorted(by: { $0.createdAt > $1.createdAt }).prefix(12) {
            statusBarMenu.addItem(colorToMenuItem(color.value))
        }
        statusItem?.menu = statusBarMenu
    }

    func rightMouseUp() {
        self.refreshRightClickMenu()
        statusItem?.button?.performClick(nil) // ...and click
    }

    func colorToMenuItem(_ color: Color) -> NSMenuItem {
        let simpleItem = NSMenuItem(
            title: color.pasteboardText(
                style: self.colorStyle,
                withAlpha: self.showAlpha
            ),
            action: #selector(
                self.copyToPasteboard
            ),
            keyEquivalent: ""
        )

        if let image = NSImage(
            systemSymbolName: "app.fill",
            accessibilityDescription: "A rectangle filled with the selected color."
        ) {
            var config = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
            config = config.applying(.init(paletteColors: [NSColor(color)]))
            simpleItem.image = image.withSymbolConfiguration(config)
        }
        return simpleItem
    }
}

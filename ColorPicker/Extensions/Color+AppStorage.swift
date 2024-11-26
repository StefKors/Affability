//
//  Color+AppStorage.swift
//  ColorPicker
//
//  Created by Stef Kors on 14/02/2023.
//  Source: https://medium.com/geekculture/using-appstorage-with-swiftui-colors-and-some-nskeyedarchiver-magic-a38038383c5e

import Foundation
import SwiftUI
import AppKit

struct HistoricalColor: Codable, Identifiable, Equatable {
    let id: String
    let createdAt: Date
    let value: Color
}

extension HistoricalColor {
    static let preview = HistoricalColor(id: "test", createdAt: Date(timeIntervalSince1970: 200), value: .accentColor)
}

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = Data(base64Encoded: rawValue) else {
            self = .black
            return
        }

        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) ?? .black
            self = Color(color)
        } catch {
            self = .black
        }
    }

    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: NSColor(self), requiringSecureCoding: false) as Data
            return data.base64EncodedString()
        } catch {
            return ""
        }
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

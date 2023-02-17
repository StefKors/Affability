//
//  AppIconSetMaker.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import Foundation
import SwiftUI

struct IconSize {
    let idiom: String
    let size: Double
    let scale: Double
    let filename: String
}

struct AppIconSetMaker {
    static let sizes: [IconSize] = [
        IconSize(
            idiom: "iphone",
            size: 20,
            scale: 2,
            filename: "notification40.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 20,
            scale: 3,
            filename: "notification60.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 29,
            scale: 2,
            filename: "settings58.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 29,
            scale: 3,
            filename: "settings87.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 40,
            scale: 2,
            filename: "spotlight80.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 40,
            scale: 3,
            filename: "spotlight120.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 60,
            scale: 2,
            filename: "iphone120.png"
        ),
        IconSize(
            idiom: "iphone",
            size: 60,
            scale: 3,
            filename: "iphone180.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 20,
            scale: 1,
            filename: "ipadNotification20.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 20,
            scale: 2,
            filename: "ipadNotification40.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 29,
            scale: 1,
            filename: "ipadSettings29.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 29,
            scale: 2,
            filename: "ipadSettings58.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 40,
            scale: 1,
            filename: "ipadSpotlight40.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 40,
            scale: 2,
            filename: "ipadSpotlight80.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 76,
            scale: 1,
            filename: "ipad76.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 76,
            scale: 2,
            filename: "ipad152.png"
        ),
        IconSize(
            idiom: "ipad",
            size: 83.5,
            scale: 2,
            filename: "ipadPro167.png"
        ),
        IconSize(
            idiom: "ios-marketing",
            size: 1024,
            scale: 1,
            filename: "appstore1024.png"
        ),
        IconSize(
            idiom: "mac",
            size: 16,
            scale: 1,
            filename: "mac16.png"
        ),
        IconSize(
            idiom: "mac",
            size: 16,
            scale: 2,
            filename: "mac32.png"
        ),
        IconSize(
            idiom: "mac",
            size: 32,
            scale: 1,
            filename: "mac32.png"
        ),
        IconSize(
            idiom: "mac",
            size: 32,
            scale: 2,
            filename: "mac64.png"
        ),
        IconSize(
            idiom: "mac",
            size: 128,
            scale: 1,
            filename: "mac128.png"
        ),
        IconSize(
            idiom: "mac",
            size: 128,
            scale: 2,
            filename: "mac256.png"
        ),
        IconSize(
            idiom: "mac",
            size: 256,
            scale: 1,
            filename: "mac256.png"
        ),
        IconSize(
            idiom: "mac",
            size: 256,
            scale: 2,
            filename: "mac512.png"
        ),
        IconSize(
            idiom: "mac",
            size: 512,
            scale: 1,
            filename: "mac512.png"
        ),
        IconSize(
            idiom: "mac",
            size: 512,
            scale: 2,
            filename: "mac1024.png"
        ),
    ]

    func rasterize(view: NSView, format: NSBitmapImageRep.FileType) -> Data? {
        guard let bitmapRepresentation = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        bitmapRepresentation.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRepresentation)
        return bitmapRepresentation.representation(using: format, properties: [
            .interlaced: true
        ])
    }

    func writeToTemp(color: Color) {
        do {
            // create temp folder
            let folder = NSTemporaryDirectory() + "AppIcon.appiconset/"
            try? FileManager.default.removeItem(atPath: folder)
            try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true)
            // copy json file to it
            let jsonFileName = "Contents.json"
            if let sourceURL = Bundle.main.url(forResource: "Contents", withExtension: ".json") {
                let destURL = URL(fileURLWithPath: folder).appendingPathComponent(jsonFileName)
                try FileManager.default.copyItem(at: sourceURL, to: destURL)
            }

            // write image files to it
            try Self.sizes.forEach { iconInfo in

                let size = iconInfo.size * iconInfo.scale
                let iconView = AppIcon(size: size/2, color: color)
                    // .scaledToFit()
                    // .frame(width: size, height: size, alignment: .center)

                let wrapper = NSHostingView(rootView: iconView)

                wrapper.frame = CGRect(x: 0, y: 0, width: size/2, height: size/2)
                guard let png = rasterize(view: wrapper, format: .png) else {
                    print("failed to rasterize")
                    return
                }

                print("writing \(iconInfo) to size: \(size)x\(size)")
                let url = URL(fileURLWithPath: folder).appendingPathComponent(iconInfo.filename)
                try png.write(to: url)
            }
        } catch {
            print(error)
        }
    }

}

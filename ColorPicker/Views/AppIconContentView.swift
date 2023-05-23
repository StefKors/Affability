//
//  AppIconContentView.swift
//  ColorPicker
//
//  Created by Stef Kors on 15/02/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct AppIconContentView: View {
    var color: Color.ID
    private let folderURL: URL = URL(fileURLWithPath: NSTemporaryDirectory() + "AppIcon.appiconset/")
    private let iconMaker: AppIconSetMaker = .init()
    @State private var finishedWriting: Bool = false
    var body: some View {
        ZStack(alignment: .top) {
            if !finishedWriting {
                ProgressView("Writing Icons")
                    .progressViewStyle(.linear)
                    .transition(.opacity.animation(.interpolatingSpring(stiffness: 200, damping: 10)).combined(with: .scale.animation(.interpolatingSpring(stiffness: 900, damping: 20))))
                    .animation(.interpolatingSpring(stiffness: 200, damping: 10), value: finishedWriting)
            }
            AppIcon(size: 256, color: color)
                .opacity(finishedWriting ? 1 : 0.5)
                .animation(.interpolatingSpring(stiffness: 200, damping: 10), value: finishedWriting)
                .onDrag({
                    let provider = NSItemProvider(item: folderURL as NSSecureCoding, typeIdentifier: kUTTypeFileURL as String)
                    return provider
                }, preview: {
                    AppIcon(size: 512, color: color)
                        .frame(width: 512, height: 512)
                })
        }
        .frame(width: 256, height: 256)
        .task(priority: .background) {
            iconMaker.writeToTemp(color: color)
            finishedWriting = true
        }

    }
}

struct AppIconContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconContentView(color: .brown)
    }
}

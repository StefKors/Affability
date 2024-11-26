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
                                        color.darker(by: 5)
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
// 
// 
// struct AppIcon: View {
//     var color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
//     // @Environment(\.parentSize) var parentSize
//     var padding: CGFloat = (512/100)*7
//     var cornerRadius: CGFloat = (512/100)*10
//     var shadowS: CGFloat = (512/100)*1.5
//     var shadowM: CGFloat = (512/100)*2
//     var shadowL: CGFloat = (512/100)*3
//     var shadowXL: CGFloat = (512/100)*5
// 
//     let width: CGFloat = 512
// 
//     var body: some View {
//         // Text("Hello, world!")
//         //     .font(.largeTitle)
//         //     .foregroundStyle(.white)
//         //     .padding()
//         //     .background(.blue)
//         //     .clipShape(Capsule())
//         //     .environment(\.parentSize, width)
// 
//         RoundedRectangle(cornerRadius: cornerRadius, style: .circular)
//             .fill(color)
//             .shadow(color: .black.opacity(0.2), radius: shadowS, y: shadowS)
//             .overlay {
//                 ZStack {
//                     Circle()
//                         .fill(
//                             LinearGradient(
//                                 gradient: Gradient(
//                                     colors: [
//                                         color.lighter(by: 20),
//                                         color.darker(by: 5),
//                                     ]
//                                 ),
//                                 startPoint: .topTrailing,
//                                 endPoint: .bottomLeading
//                             )
//                         )
// 
//                     Circle()
//                         .stroke(color.darker(by: 2), lineWidth: 1)
//                 }
//                 .shadow(color: color.darker(by: 10), radius: shadowXL, y: -shadowL)
//                 .shadow(color: color.darker(by: 10).opacity(0.3), radius: shadowL, x: -shadowL, y: -shadowL)
//                 .shadow(color: color.lighter(by: 10).opacity(0.2), radius: shadowM, x: shadowM, y: shadowM)
//                 .padding(padding)
//             }
//             .clipShape(RoundedRectangle(cornerRadius: (width*0.2), style: .circular))
//             .shadow(radius: (width*0.02), y: (width*0.002))
//             .padding((width*0.08))
//             .frame(width: width, height: width, alignment: .center)
//     }
// }
// 
// struct IconRenderer: View {
//     var body: some View {
//         VStack {
//             AppIcon(color: Color(red: 0.721545, green: 0.572411, blue: 0.709819))
//                 .iconStyle(.macOS)
//                 .frame(width: 512, height: 512)
//             Button("generate") {
//                 do {
//                     // let iconView = AppIcon(color: Color(red: 0.721545, green: 0.572411, blue: 0.709819))
//                     //     .iconStyle(.macOS)
//                     //     .frame(width: 512, height: 512)
//                     //     .clipShape(Rectangle())
//                     let renderer = ImageRenderer(content: AppIcon(color: Color(red: 0.721545, green: 0.572411, blue: 0.709819)))
// 
//                     // // 2: Save it to our documents directory
//                     // let url = URL.documentsDirectory.appending(path: "output.pdf")
//                     //
//                     // // 3: Start the rendering process
//                     // renderer.render { size, context in
//                     //     // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
//                     //     var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//                     //
//                     //     // 5: Create the CGContext for our PDF pages
//                     //     guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
//                     //         return
//                     //     }
//                     //
//                     //     // 6: Start a new PDF page
//                     //     pdf.beginPDFPage(nil)
//                     //
//                     //     // 7: Render the SwiftUI view data onto the page
//                     //     context(pdf)
//                     //
//                     //     // 8: End the page and close the file
//                     //     pdf.endPDFPage()
//                     //     pdf.closePDF()
//                     // }
//                     //
//                     // print(url.description)
// 
//                     renderer.scale = 2.0
//                     renderer.proposedSize = .init(width: 512, height: 512)
//                     guard let image = renderer.nsImage  else { return }
//                     let folder = NSTemporaryDirectory() + "PreviewIcon/"
// 
// 
//                     try? FileManager.default.removeItem(atPath: folder)
//                     try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true)
//                     let path = folder + "icon.png"
//                     let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
//                     let pngData = imageRep?.representation(using: .png, properties: [:])
//                     try pngData?.write(to: URL(filePath: path))
//                     print(path.description)
//                 } catch {
//                     print("error \(error.localizedDescription)")
//                 }
//             }
//         }
//     }
// }
// 
// struct AppIcon_Previews: PreviewProvider {
//     static var previews: some View {
//         VStack {
//             AppIcon(color: Color(red: 0.721545, green: 0.572411, blue: 0.709819))
//                 .iconStyle(.macOS)
//                 .frame(width: 512, height: 512)
            // Button("generate") {
            //     do {
            //         let iconView = AppIcon(color: Color(red: 0.721545, green: 0.572411, blue: 0.709819))
            //         // .iconStyle(.macOS)
            //         // .frame(width: 512, height: 512)
            //         let renderer = ImageRenderer(content: iconView)
            //         // renderer.scale = 1.0
            //         // renderer.proposedSize = .init(width: 120, height: 120)
            //         guard let image = renderer.nsImage  else { return }
            //         let folder = NSTemporaryDirectory() + "PreviewIcon/"
            //         try? FileManager.default.removeItem(atPath: folder)
            //         try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true)
            //         let path = folder + "icon.png"
            //         let imageRep = NSBitmapImageRep(data: image.tiffRepresentation!)
            //         let pngData = imageRep?.representation(using: .png, properties: [:])
            //         try pngData?.write(to: URL(filePath: path))
            //         print(path.description)
            //     } catch {
            //         print("error \(error.localizedDescription)")
            //     }
            // }
//         }
//         .previewDisplayName("grid")
// 
//     }
// }
// 

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

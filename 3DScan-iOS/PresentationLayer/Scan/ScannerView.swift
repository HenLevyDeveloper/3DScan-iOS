//
//  ScannerView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI
import ARKit
import RealityKit

struct ScannerView: View {
    @StateObject private var captureService = CaptureService()
    private let arSession = ARSession()

    var body: some View {
        VStack {
            ARViewController(captureService: captureService)
                .edgesIgnoringSafeArea(.all)

            if captureService.isCapturing {
                ProgressView(value: captureService.progress, total: 1.0)
                    .padding()
            }

            Button(captureService.isCapturing ? "Stop Capture" : "Start Capture") {
                if captureService.isCapturing {
                    captureService.stopCapturing()
                } else {
                    captureService.startCapturing()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            if let modelURL = captureService.outputModelURL {
                Text("3D Model Ready! 🎉")
                Button("Export Model") {
                    shareModel(url: modelURL)
                }
                .padding()
            }
        }
    }

    private func shareModel(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let presentedViewController = window.rootViewController?.presentedViewController {
            presentedViewController.present(activityVC, animated: true, completion: nil)
        } else {
            print("❌ Unable to find a window to present the activity view controller.")
        }
    }

}


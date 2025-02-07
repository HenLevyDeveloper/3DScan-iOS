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
    @StateObject private var handCaptureService = HandCaptureService()
    private let arSession = ARSession()

    var body: some View {
        VStack {
            ARViewController(handCaptureService: handCaptureService)
                .edgesIgnoringSafeArea(.all)

            if handCaptureService.isCapturing {
                ProgressView(value: handCaptureService.progress, total: 1.0)
                    .padding()
            }

            Button(handCaptureService.isCapturing ? "Stop Capture" : "Start Capture") {
                if handCaptureService.isCapturing {
                    handCaptureService.stopCapturing()
                } else {
                    handCaptureService.startCapturing()
                }
            }
            .buttonStyle(.borderedProminent)
            .padding()

            if let modelURL = handCaptureService.outputModelURL {
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


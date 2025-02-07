//
//  ARViewContainer.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewController: UIViewControllerRepresentable {
    let handCaptureService: HandCaptureService

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let arView = ARView(frame: viewController.view.frame)
        arView.session.delegate = context.coordinator
        viewController.view.addSubview(arView)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(handCaptureService: handCaptureService)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let handCaptureService: HandCaptureService

        init(handCaptureService: HandCaptureService) {
            self.handCaptureService = handCaptureService
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            Task {
                await MainActor.run {
                    handCaptureService.captureImage(from: frame)
                }
            }
        }
    }
}

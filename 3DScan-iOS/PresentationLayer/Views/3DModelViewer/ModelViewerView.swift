//
//  ModelViewerView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 09/02/2025.
//

import SwiftUI
import SceneKit

struct ModelViewerView: View {
    @StateObject var viewModel: ModelViewerViewModel
    
    var body: some View {
        ZStack {
            if let localFileURL = viewModel.localFileURL {
                SceneView(
                    scene: loadModel(from: localFileURL),
                    options: [.allowsCameraControl, .autoenablesDefaultLighting]
                )
                .edgesIgnoringSafeArea(.all)
            } else if viewModel.isLoading {
                ProgressView("Loading Model...")
            } else {
                Text(viewModel.errorMessage ?? "Failed to load model")
                    .foregroundColor(.red)
                    .font(.headline)
            }
        }
        .onAppear {
            if viewModel.localFileURL != nil { return }
            Task {
                await viewModel.fetchViewPersignedURL()
            }
        }
    }

    private func loadModel(from localURL: URL) -> SCNScene? {
        let referenceNode = SCNReferenceNode(url: localURL)
        referenceNode?.load()
        let scene = SCNScene()
        scene.rootNode.addChildNode(referenceNode ?? SCNNode())
        scene.rootNode.addChildNode(createDefaultLighting())
        return scene
    }

    private func createDefaultLighting() -> SCNNode {
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = .omni
        light.intensity = 1000
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 5, z: 10)
        return lightNode
    }
}

#Preview {
    ModelViewerView(viewModel: .create(withExternalFileKey: "1739140583762_BodyPartModel.usdz", userId: "67a4c07d8d7db26fb9e7324c"))
        .padding()
}

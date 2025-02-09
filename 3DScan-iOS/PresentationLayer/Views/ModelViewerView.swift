//
//  ModelViewerView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 09/02/2025.
//

import SwiftUI
import SceneKit

struct ModelViewerView: View {
    let modelURL: URL
    
    var body: some View {
        SceneView(
            scene: loadModel(),
            options: [.allowsCameraControl, .autoenablesDefaultLighting] // Enable lighting and interaction
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private func loadModel() -> SCNScene? {
        do {
            let scene = try SCNScene(url: modelURL, options: nil)
            scene.rootNode.addChildNode(createDefaultLighting())
            return scene
        } catch {
            print("❌ Error loading model: \(error.localizedDescription)")
            return nil
        }
    }

    private func createDefaultLighting() -> SCNNode {
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = .omni // Ensures object is visible
        light.intensity = 1000
        lightNode.light = light
        lightNode.position = SCNVector3(x: 0, y: 5, z: 10)
        return lightNode
    }
}

//#Preview {
//    ModelViewerView(modelURL: URL(fileURLWithPath: "/path/to/your/model.scn"))
//}

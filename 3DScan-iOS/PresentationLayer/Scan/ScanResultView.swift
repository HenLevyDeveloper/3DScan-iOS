//
//  ScanResultView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 08/02/2025.
//

import SwiftUI

struct ScanResultView: View {
    let modelURL: URL?
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Scan Completed!")
                .font(.largeTitle)
                .bold()
            
            Image(systemName: "cube.box.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.lightBlue)
            
            if let modelURL = modelURL {
                VStack {
                    ModelViewerView(modelURL: modelURL)
                        .frame(height: 400)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(12)
                }
            }
            
            // Share Scan Button
            Button {
                shareModel()
            } label: {
                AppButtonText("Share Scan")
            }
            .padding(.horizontal)
            
            // Finish Button
            Button {
                onClose()
            } label: {
                AppButtonText("Back to Home", backgroundColor: .metal)
            }
            .padding(.horizontal)
        }
    }
    
    private func shareModel() {
        guard let modelURL = modelURL else { return }
        let activityVC = UIActivityViewController(activityItems: [modelURL], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let presentedViewController = window.rootViewController?.presentedViewController {
            presentedViewController.present(activityVC, animated: true)
        }
    }
}

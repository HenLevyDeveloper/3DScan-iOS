//
//  ScanDetailView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 10/02/2025.
//

import SwiftUI

struct ScanDetailView: View {
    let scan: Scan
    
    var body: some View {
        VStack(spacing: 20) {
            Text(scan.fileName)
                .font(.title)
                .fontWeight(.bold)
            
            Image(systemName: "cube.box.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.lightBlue)
            
            VStack {
                ModelViewerView(viewModel: .create(withExternalFileKey: scan.key, userId: scan.userId))
                    .frame(height: 300)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(12)
            }
            
            // Share Scan Button
            Button {
                shareScan(scan)
            } label: {
                AppButtonText("Share Scan")
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    func shareScan(_ scan: Scan) {
        let activityVC = UIActivityViewController(activityItems: [scan.url], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let target = window.rootViewController {
            target.present(activityVC, animated: true)
        }
    }
}

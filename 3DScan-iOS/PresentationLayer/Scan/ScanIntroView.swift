//
//  ScanIntroView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI
import AVFoundation

struct ScanIntroView: View {
    @State private var showScanScreen = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 3D-like Illustration Placeholder
            Image(systemName: "viewfinder.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.lightGreen, Color.darkGray]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(radius: 10)
                .rotation3DEffect(
                    .degrees(10),
                    axis: (x: 0, y: 1, z: 0)
                )
                .animation(Animation.easeInOut(duration: 1.5).repeatForever(), value: true)
                
            Text("Scan Your Body in 3D")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                
            Text("Easily scan your body part in 3D using your device's camera. Ensure good lighting and follow the instructions for the best results.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .foregroundColor(.secondary)
                
            Spacer()
            
            // Scan Button
            Button {
                showScanScreen = true
            } label: {
                AppButtonText("Proceed to Scan")
            }
            .padding(.horizontal)
            
            Button(action: {
                // TODO: Open tutorial
            }) {
                Text("How it works?")
                    .underline()
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

#Preview {
    ScanIntroView()
}

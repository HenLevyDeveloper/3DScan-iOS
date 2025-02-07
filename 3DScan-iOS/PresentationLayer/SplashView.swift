//
//  SplashView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                // Navigate to the main content view after the splash screen
                MainView()
            } else {
                // Splash screen with animation
                AnimationView(animation: .splash)
                    .background(.darkGray)
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(2))
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

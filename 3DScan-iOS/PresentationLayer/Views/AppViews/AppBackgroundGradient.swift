//
//  AppBackgroundGradient.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 06/02/2025.
//

import SwiftUI

struct AppBackgroundGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.7)]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()

    }
}

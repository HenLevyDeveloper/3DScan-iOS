//
//  AppButtonText.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 06/02/2025.
//

import SwiftUI

struct AppButtonText: View {
    private let placeholder: String
    private let backgroundColor: Color
    
    init(_ placeholder: String, backgroundColor: Color = .blue) {
        self.placeholder = placeholder
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Text(placeholder)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 3)
    }
}

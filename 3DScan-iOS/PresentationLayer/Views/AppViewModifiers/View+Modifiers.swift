//
//  View+Modifiers.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 06/02/2025.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(PlainTextFieldStyle())
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 2)
    }
}

extension View {
    func textFieldStyle() -> some View {
        modifier(TextFieldModifier())
    }
}

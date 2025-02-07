//
//  AnimationView.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import SwiftUI
import Lottie

typealias AppAnimationView = LottieAnimationView
typealias AppAnimation = LottieAnimation
typealias AppLoopMode = LottieLoopMode

struct AnimationView: UIViewRepresentable {
    
    enum AnimationType {
        case splash
        
        var name: String {
            switch self {
            case .splash:
                return "splash_animation"
            }
        }
        
        var loopMode: AppLoopMode {
            switch self {
            case .splash:
                return .playOnce
            }
        }
    }
    
    let animation: AnimationType
    
    func makeUIView(context: Context) -> AppAnimationView {
        let animationView = AppAnimationView()
        animationView.animation = AppAnimation.named(animation.name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = animation.loopMode
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: AppAnimationView, context: Context) {}
}

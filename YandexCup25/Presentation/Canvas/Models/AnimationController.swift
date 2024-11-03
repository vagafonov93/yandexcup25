//
//  AnimationController.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 01.11.2024.
//

import UIKit

struct ImagesAnimationModel {
    let images: [UIImage]
    let duration: TimeInterval
    let repeatCount: Int
}

protocol AnimationControllerProtocol: AnyObject {
    var isAnimating: Bool { get }
    
    func startAnimation(
        images: [UIImage],
        stop: @escaping () -> Void
    ) -> ImagesAnimationModel
    
    func pauseAnimation()
}

final class AnimationController {
    
    private let properties: PropertiesContainerProtocol = PropertiesContainer.shared
    
    private var stopAction: (() -> Void)?
    
    var isAnimating = false
}

// MARK: - AnimationControllerProtocol

extension AnimationController: AnimationControllerProtocol {
    
    func startAnimation(
        images: [UIImage],
        stop: @escaping () -> Void
    ) -> ImagesAnimationModel {
        stopAction = stop
        isAnimating = true
        
        return ImagesAnimationModel(
            images: images,
            duration: Double(images.count) * properties.animationSpeed,
            repeatCount: 0
        )
    }
    
    func pauseAnimation() {
        isAnimating = false
        
        stopAction?()
    }
}

//
//  PropertiesContainer.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 03.11.2024.
//

import UIKit

protocol PropertiesContainerProtocol: AnyObject {
    var animationSpeed: TimeInterval { get set }
    var lineWidth: CGFloat { get set }
}

final class PropertiesContainer: PropertiesContainerProtocol {
    
    static let shared = PropertiesContainer()
    
    var animationSpeed: TimeInterval = 0.35
    
    var lineWidth: CGFloat = 10
}

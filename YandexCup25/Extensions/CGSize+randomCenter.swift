//
//  CGSize+randomCenter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

extension CGSize {
    
    static var defaultInstrumentSize: CGSize {
        CGSize(width: 100, height: 100)
    }
    
    static var allFramesCollectionCellSize: CGSize {
        CGSize(
            width: UIScreen.main.bounds.width / 2,
            height: 200
        )
    }
    
    func getRandomCenterInside(for size: CGSize) -> CGPoint {
        let minX = size.width / 2
        let maxX = width - minX
        let minY = size.height / 2
        let maxY = height - minY
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        return CGPoint(x: randomX, y: randomY)
    }
}

//
//  DrawingModel.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 02.11.2024.
//

import UIKit

final class DrawingModel: Equatable {
    
    final class Line: Equatable {
        var points: [CGPoint]
        
        init(points: [CGPoint]) {
            self.points = points
        }
        
        static func == (lhs: DrawingModel.Line, rhs: DrawingModel.Line) -> Bool {
            lhs.points == rhs.points
        }
    }
    
    let tag: Int
    var lines: [Line]
    let color: UIColor
    let lineWidth: CGFloat
    
    var copied: DrawingModel {
        DrawingModel(
            tag: tag,
            lines: lines,
            color: color,
            lineWidth: lineWidth
        )
    }
    
    init(tag: Int, lines: [Line], color: UIColor, lineWidth: CGFloat) {
        self.tag = tag
        self.lines = lines
        self.color = color
        self.lineWidth = lineWidth
    }
    
    static func == (lhs: DrawingModel, rhs: DrawingModel) -> Bool {
        return lhs.tag == rhs.tag && lhs.lines == rhs.lines && lhs.color == rhs.color && lhs.lineWidth == rhs.lineWidth
    }
}

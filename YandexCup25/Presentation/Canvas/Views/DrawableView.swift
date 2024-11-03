//
//  DrawableView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 02.11.2024.
//

import UIKit

final class DrawableView: UIView {
    
    private lazy var panRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePan)
    )
    
    private var drawingPath = UIBezierPath()
    
    private let shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var model: Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shapeLayer.frame = bounds
        
        super.layoutSubviews()
    }
}

extension DrawableView {
    
    struct Model {
        
        struct Line {
            let points: [CGPoint]
        }
        
        let tag: Int
        
        let lineWidth: CGFloat
        let strokeColor: UIColor
        let lines: [Line]
        
        let didBeginDrawingLine: (CGPoint) -> Void
        let didAddPointToLine: (CGPoint) -> Void
        let didFinishDrawingLine: () -> Void
        
        let isUserInteractionEnabled: Bool
        
        var path: UIBezierPath {
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            lines.forEach { line in
                if let firstPoint = line.points.first {
                    path.move(to: firstPoint)
                }
                line.points.dropFirst().forEach { path.addLine(to: $0) }
            }
            return path
        }
    }
    
    func configure(with model: Model) {
        self.model = model
        
        tag = model.tag
        isUserInteractionEnabled = model.isUserInteractionEnabled
        
        drawingPath = model.path
        
        shapeLayer.strokeColor = model.strokeColor.cgColor
        shapeLayer.lineWidth = model.lineWidth
        shapeLayer.path = drawingPath.cgPath
    }
}

private extension DrawableView {
    
    func setup() {
        layer.addSublayer(shapeLayer)
        
        addGestureRecognizer(panRecognizer)
    }
    
    @objc
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        
        let location = recognizer.location(in: view)
        
        if recognizer.state == .began {
            drawingPath.move(to: location)
            
            model?.didBeginDrawingLine(location)
        }
        
        if recognizer.state == .changed {
            drawingPath.addLine(to: location)
            
            model?.didAddPointToLine(location)
        }
        
        shapeLayer.path = drawingPath.cgPath
        
        if recognizer.state == .ended {
            model?.didFinishDrawingLine()
        }
    }
}

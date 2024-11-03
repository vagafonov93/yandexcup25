//
//  DraggableInstrumentView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class DraggableInstrumentView: UIView {
    
    private lazy var panRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePan)
    )
    
    private lazy var pinchRecognizer = UIPinchGestureRecognizer(
        target: self,
        action: #selector(handlePinch)
    )
    
    private lazy var instrumentImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var model: Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DraggableInstrumentView {
    
    struct Model {
        let tag: Int
        let instrumentImage: UIImage
        
        let center: CGPoint
        let didChangeCenter: (CGPoint) -> Void
        let didFinishDragging: () -> Void
        
        let transform: CGAffineTransform
        let didChangeTransform: (CGAffineTransform) -> Void
        let didFinishTransforming: () -> Void
        
        let isUserInteractionEnabled: Bool
    }
    
    func configure(with model: Model) {
        self.model = model
        
        tag = model.tag
        center = model.center
        transform = model.transform
        isUserInteractionEnabled = model.isUserInteractionEnabled
        
        instrumentImageView.image = model.instrumentImage
    }
}

private extension DraggableInstrumentView {
    
    func setup() {
        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(pinchRecognizer)
        
        addSubview(instrumentImageView)
        
        NSLayoutConstraint.activate([
            instrumentImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            instrumentImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            instrumentImageView.topAnchor.constraint(equalTo: topAnchor),
            instrumentImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let view = recognizer.view else { return }
        
        let translation = recognizer.translation(in: view.superview)
        
        view.center = CGPoint(
            x: view.center.x + translation.x,
            y: view.center.y + translation.y
        )
        
        recognizer.setTranslation(.zero, in: view)
        
        model?.didChangeCenter(view.center)
        
        if recognizer.state == .ended {
            model?.didFinishDragging()
        }
    }
    
    @objc
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        guard let view = recognizer.view else { return }

        view.transform = view.transform.scaledBy(
            x: recognizer.scale,
            y: recognizer.scale
        )
        
        recognizer.scale = 1
        
        model?.didChangeTransform(view.transform)
        
        if recognizer.state == .ended {
            model?.didFinishTransforming()
        }
    }
}

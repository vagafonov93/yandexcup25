//
//  UIView+redDots.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

extension UIView {
    
    func removeAllDrawingViews() {
        subviews.forEach { subview in
            if subview is DrawableView || subview is DraggableInstrumentView {
                subview.removeFromSuperview()
            }
        }
    }
    
    @discardableResult
    func addDrawableView(
        with model: DrawableView.Model
    ) -> DrawableView {
        let view = DrawableView(frame: bounds)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.configure(with: model)
        addSubview(view)
        return view
    }
    
    @discardableResult
    func addDraggableInstrumentView(
        with model: DraggableInstrumentView.Model
    ) -> DraggableInstrumentView {
        let view = DraggableInstrumentView(
            frame: .init(
                origin: .zero,
                size: .defaultInstrumentSize
            )
        )
        view.configure(with: model)
        addSubview(view)
        return view
    }
    
    func sortAllDrawingsByTag() {
        let orderedDrawings = subviews
            .filter {
                $0 is DrawableView || $0 is DraggableInstrumentView
            }
            .sorted(by: {
                $0.tag < $1.tag
            })
        
        orderedDrawings.forEach { $0.removeFromSuperview() }
        orderedDrawings.forEach { addSubview($0) }
    }
}

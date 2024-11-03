//
//  ColorPickerView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class ColorPickerView: UIView {
    
    private lazy var colorsStackView: UIStackView = {
        let colorsStackView = UIStackView(arrangedSubviews: [])
        colorsStackView.axis = .vertical
        colorsStackView.spacing = 16
        colorsStackView.translatesAutoresizingMaskIntoConstraints = false
        return colorsStackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension ColorPickerView {
    
    struct Model {
        
        struct LineItem {
            let image: UIImage?
            let action: () -> Void
        }
        
        struct Line {
            let items: [LineItem]
        }
        
        let lines: [Line]
    }
    
    func makeStackView(for line: Model.Line) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: line.items.map { item in
                UIButton.makeButton(image: item.image, action: item.action)
            }
        )
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func configure(with model: Model) {
        colorsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        model.lines.map(makeStackView).reversed().forEach { colorsStackView.addArrangedSubview($0) }
        
        
//        colorsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        model.colors
//            .map { color -> UIButton in
//                .makeButton(
//                    image: .color.withTintColor(color),
//                    action: { model.colorAction(color) }
//                )
//            }
//            .forEach {
//                colorsStackView.addArrangedSubview($0)
//            }
    }
}

// MARK: - Private

private extension ColorPickerView {
    
    func setup() {
        addSubview(colorsStackView)
        
        NSLayoutConstraint.activate([
            colorsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorsStackView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -24
            ),
        ])
    }
}

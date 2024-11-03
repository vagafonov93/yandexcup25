//
//  InstrumentsPickerView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class InstrumentsPickerView: UIView {
    
    private lazy var colorsStackView: UIStackView = {
        let colorsStackView = UIStackView(arrangedSubviews: [])
        colorsStackView.axis = .horizontal
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

extension InstrumentsPickerView {
    
    struct Model {
        let instruments: [Instrument]
        let instrumentAction: (Instrument) -> Void
    }
    
    func configure(with model: Model) {
        colorsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        model.instruments
            .map { instrument -> UIButton in
                .makeButton(
                    image: instrument.image,
                    action: { model.instrumentAction(instrument) }
                )
            }
            .forEach {
                colorsStackView.addArrangedSubview($0)
            }
    }
}

// MARK: - Private

private extension InstrumentsPickerView {
    
    func setup() {
        backgroundColor = .yandexGray.withAlphaComponent(0.35)
        
        addSubview(colorsStackView)
        
        NSLayoutConstraint.activate([
            colorsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorsStackView.centerYAnchor.constraint(
                equalTo: centerYAnchor,
                constant: -6
            ),
        ])
    }
}

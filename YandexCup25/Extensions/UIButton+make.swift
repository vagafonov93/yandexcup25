//
//  UIButton+make.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

extension UIButton {
    
    static func makeButton(
        image: UIImage?,
        action: (() -> Void)? = nil
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addAction(UIAction(handler: { _ in action?() }), for: .touchUpInside)
        return button
    }
}

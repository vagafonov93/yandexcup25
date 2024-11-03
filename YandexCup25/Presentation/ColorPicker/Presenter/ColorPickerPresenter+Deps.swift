//
//  ColorPickerPresenter+Deps.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

extension ColorPickerPresenter {
    struct Deps {
        let colors: [UIColor] = UIColor.allColors
        let selectColor: (UIColor) -> Void
    }
}

//
//  ColorPickerFactory.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol ColorPickerFactoryProtocol: AnyObject {
    func make(
        selectColor: @escaping (UIColor) -> Void
    ) -> UIViewController
}

final class ColorPickerFactory: ColorPickerFactoryProtocol {
    
    func make(
        selectColor: @escaping (UIColor) -> Void
    ) -> UIViewController {
        let presenter = ColorPickerPresenter(
            deps: .init(
                selectColor: selectColor
            )
        )
        let viewController = ColorPickerViewController(
            presenter: presenter
        )
        viewController.preferredContentSize = CGSize(width: 256, height: 56)
        presenter.view = viewController
        return viewController
    }
}

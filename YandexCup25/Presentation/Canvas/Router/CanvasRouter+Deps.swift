//
//  CanvasRouter+Deps.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

extension CanvasRouter {
    struct Deps {
        let allFramesFactory: AllFramesFactoryProtocol
        let colorPickerFactory: ColorPickerFactoryProtocol
        let instrumentsPickerFactory: InstrumentsPickerFactoryProtocol
        let popoverDelegate: UIPopoverPresentationControllerDelegateImpl
    }
}

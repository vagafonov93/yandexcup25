//
//  InstrumentsPickerFactory.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol InstrumentsPickerFactoryProtocol: AnyObject {
    func make(
        instrumentHandler: @escaping (Instrument) -> Void
    ) -> UIViewController
}

final class InstrumentsPickerFactory: InstrumentsPickerFactoryProtocol {
    
    func make(
        instrumentHandler: @escaping (Instrument) -> Void
    ) -> UIViewController {
        let presenter = InstrumentsPickerPresenter(
            deps: .init(
                selectInstrument: instrumentHandler
            )
        )
        let viewController = InstrumentsPickerViewController(
            presenter: presenter
        )
        viewController.preferredContentSize = CGSize(width: 176, height: 56)
        presenter.view = viewController
        return viewController
    }
}

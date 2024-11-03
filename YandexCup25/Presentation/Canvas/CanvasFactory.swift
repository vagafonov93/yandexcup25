//
//  CanvasFactory.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class CanvasFactory {
    func make() -> UIViewController {
        let canvasStore = CanvasStore.shared
        let router = CanvasRouter(
            deps: .init(
                allFramesFactory: AllFramesFactory(),
                colorPickerFactory: ColorPickerFactory(),
                instrumentsPickerFactory: InstrumentsPickerFactory(),
                popoverDelegate: UIPopoverPresentationControllerDelegateImpl()
            )
        )
        let presenter = CanvasPresenter(
            deps: .init(
                viewModelFactory: CanvasViewModelFactory(),
                router: router,
                canvasStore: canvasStore,
                undoManager: UndoManager(),
                animationController: AnimationController(),
                gifGenerator: GIFGeneratorService(),
                properties: PropertiesContainer.shared
            )
        )
        let viewController = CanvasViewController(presenter: presenter)
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}

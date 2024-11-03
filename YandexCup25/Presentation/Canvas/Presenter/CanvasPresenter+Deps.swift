//
//  CanvasPresenter+Deps.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

extension CanvasPresenter {
    struct Deps {
        let viewModelFactory: CanvasViewModelFactoryProtocol
        let router: CanvasRouterProtocol
        let canvasStore: CanvasStoreProtocol
        let undoManager: UndoManagerProtocol
        let animationController: AnimationControllerProtocol
        let gifGenerator: GIFGeneratorServiceProtocol
        let properties: PropertiesContainerProtocol
    }
}

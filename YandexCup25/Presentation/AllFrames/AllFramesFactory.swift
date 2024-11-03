//
//  AllFramesFactory.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

protocol AllFramesFactoryProtocol: AnyObject {
    func make(
        selectFrameHandler: @escaping (Int) -> Void
    ) -> UIViewController
}

final class AllFramesFactory: AllFramesFactoryProtocol {
    
    func make(
        selectFrameHandler: @escaping (Int) -> Void
    ) -> UIViewController {
        let router = AllFramesRouter()
        let presenter = AllFramesPresenter(
            deps: .init(
                router: router,
                canvasStore: CanvasStore.shared,
                selectFrameHandler: selectFrameHandler
            )
        )
        let viewController = AllFramesViewController(
            presenter: presenter
        )
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}

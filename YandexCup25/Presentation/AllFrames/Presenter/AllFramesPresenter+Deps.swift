//
//  AllFramesPresenter+Deps.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

extension AllFramesPresenter {
    struct Deps {
        let router: AllFramesRouterProtocol
        let canvasStore: CanvasStoreProtocol
        let selectFrameHandler: (Int) -> Void
    }
}

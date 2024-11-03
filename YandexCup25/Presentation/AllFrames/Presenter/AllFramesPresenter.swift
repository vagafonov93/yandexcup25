//
//  AllFramesPresenter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

protocol AllFramesPresenterProtocol: AnyObject {
    func viewLoaded()
}

final class AllFramesPresenter {
    
    weak var view: AllFramesViewControllerProtocol?
    
    private let deps: Deps
    
    init(deps: Deps) {
        self.deps = deps
    }
}

// MARK: - AllFramesPresenterProtocol

extension AllFramesPresenter: AllFramesPresenterProtocol {
    
    func viewLoaded() {
        updateViewModel()
    }
}

// MARK: - Private

private extension AllFramesPresenter {
    
    func updateViewModel() {
        view?.updateView(
            with: .init(
                items: deps.canvasStore.allCanvases.map { canvas in
                    AllFramesItem(image: canvas.snapshot)
                },
                selectFrame: { [weak self] in self?.handleFrameSelect(at: $0) },
                close: { [weak self] in self?.handleClose() }
            )
        )
    }
    
    func handleFrameSelect(at index: Int) {
        deps.selectFrameHandler(index)
        
        deps.router.dismiss()
    }
    
    func handleClose() {
        deps.router.dismiss()
    }
}

//
//  AllFramesRouter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

protocol AllFramesRouterProtocol: AnyObject {
    func dismiss()
}

final class AllFramesRouter {
    weak var viewController: UIViewController?
}

// MARK: - AllFramesRouterProtocol

extension AllFramesRouter: AllFramesRouterProtocol {
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}

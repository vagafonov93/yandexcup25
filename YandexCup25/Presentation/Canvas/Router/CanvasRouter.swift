//
//  CanvasRouter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol CanvasRouterProtocol: AnyObject {
    func showUnavailableFeatureAlert()
    func showColorPicker(
        sourceView: UIView?,
        colorHandler: @escaping (UIColor) -> Void,
        dismissHandler: @escaping () -> Void
    )
    func showInstrumentsPicker(
        sourceView: UIView?,
        instrumentHandler: @escaping (Instrument) -> Void,
        dismissHandler: @escaping () -> Void
    )
    func showAllFrames(
        selectFrameHandler: @escaping (Int) -> Void
    )
    func showAdditionalActionsSheet(actions: [ActionSheetModel])
    func showAlertWithSingleTextInput(
        customTitle: String,
        didUpdateText: @escaping (String) -> Void
    )
    func showShareActivity(activityItems: [Any])
    func dismiss(completion: (() -> Void)?)
}

extension CanvasRouterProtocol {
    
    func dismiss() {
        dismiss(completion: {})
    }
}

final class CanvasRouter {
    
    weak var viewController: UIViewController?
    
    private let deps: Deps
    
    init(deps: Deps) {
        self.deps = deps
    }
}

// MARK: - CanvasRouterProtocol

extension CanvasRouter: CanvasRouterProtocol {
    
    func showUnavailableFeatureAlert() {
        let alert = UIAlertController(
            title: "Функционал временно недосутпен",
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
    
    func showColorPicker(
        sourceView: UIView?,
        colorHandler: @escaping (UIColor) -> Void,
        dismissHandler: @escaping () -> Void
    ) {
        let delegate = deps.popoverDelegate
        delegate.popoverPresentationControllerDidDismissPopover = dismissHandler
        
        let controller = deps.colorPickerFactory.make(selectColor: colorHandler)
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.delegate = delegate
        controller.popoverPresentationController?.backgroundColor = .clear
        
        viewController?.present(controller, animated: true)
    }
    
    func showInstrumentsPicker(
        sourceView: UIView?,
        instrumentHandler: @escaping (Instrument) -> Void,
        dismissHandler: @escaping () -> Void
    ) {
        let delegate = deps.popoverDelegate
        delegate.popoverPresentationControllerDidDismissPopover = dismissHandler
        
        let controller = deps.instrumentsPickerFactory.make(
            instrumentHandler: instrumentHandler
        )
        controller.modalPresentationStyle = .popover
        controller.popoverPresentationController?.sourceView = sourceView
        controller.popoverPresentationController?.delegate = delegate
        
        viewController?.present(controller, animated: true)
    }
    
    func showAllFrames(
        selectFrameHandler: @escaping (Int) -> Void
    ) {
        let controller = deps.allFramesFactory.make(
            selectFrameHandler: selectFrameHandler
        )
        
        viewController?.present(controller, animated: true)
    }
    
    func showAlertWithSingleTextInput(
        customTitle: String,
        didUpdateText: @escaping (String) -> Void
    ) {
        let alertController = UIAlertController(
            title: customTitle,
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addTextField()
        
        alertController.addAction(
            UIAlertAction(
                title: "Готово",
                style: .default,
                handler: { [unowned alertController] _ in
                    didUpdateText(alertController.textFields?.first?.text ?? "")
                }
            )
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .destructive
            )
        )
        
        viewController?.present(alertController, animated: true)
    }
    
    func showAdditionalActionsSheet(actions: [ActionSheetModel]) {
        let alertController = UIAlertController(
            title: "Дополнительные возможности",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        actions.forEach { action in
            alertController.addAction(
                UIAlertAction(
                    title: action.title,
                    style: .default,
                    handler: { _ in action.action() }
                )
            )
        }
        
        alertController.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .destructive
            )
        )
        
        viewController?.present(alertController, animated: true)
    }
    
    func showShareActivity(activityItems: [Any]) {
        let activitityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        viewController?.present(activitityViewController, animated: true)
    }
    
    func dismiss(completion: (() -> Void)?) {
        viewController?.dismiss(animated: true, completion: completion)
    }
}

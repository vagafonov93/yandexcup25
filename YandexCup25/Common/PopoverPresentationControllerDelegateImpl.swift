//
//  UIPopoverPresentationControllerDelegateImpl.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class UIPopoverPresentationControllerDelegateImpl: NSObject {
    
    var getAdaptivePresentationStyle: ((UIPresentationController) -> UIModalPresentationStyle)?
    
    var popoverPresentationControllerDidDismissPopover: (() -> Void)?
}

// MARK: - UIPopoverPresentationControllerDelegate

extension UIPopoverPresentationControllerDelegateImpl: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        getAdaptivePresentationStyle?(controller) ?? .none
    }
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) {
        popoverPresentationControllerDidDismissPopover?()
    }
}

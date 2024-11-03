//
//  ColorPickerPresenter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol ColorPickerPresenterProtocol: AnyObject {
    func viewLoaded()
}

final class ColorPickerPresenter {
    
    weak var view: ColorPickerViewControllerProtocol?
    
    private let deps: Deps
    
    private var expanded = false
    
    init(deps: Deps) {
        self.deps = deps
    }
}

// MARK: - ColorPickerPresenterProtocol

extension ColorPickerPresenter: ColorPickerPresenterProtocol {
    
    func viewLoaded() {
        updateViewModel()
    }
}

// MARK: - Private

private extension ColorPickerPresenter {
    
    func updateViewModel() {
        view?.updateView(with: makeViewModel())
    }
    
    func makeViewModel() -> ColorPickerView.Model {
        ColorPickerView.Model(
            lines: [
                ColorPickerView.Model.Line(
                    items: [
                        ColorPickerView.Model.LineItem(
                            image: .colorPalette.withTintColor(
                                expanded ? .yandexLime : .yandexGray
                            ),
                            action: { [unowned self] in
                                expanded.toggle()
                                
                                updateContentSize()
                                
                                updateViewModel()
                            }
                        ),
                    ] + makeLineItems(colors: deps.colors.prefix(4))
                ),
                ColorPickerView.Model.Line(
                    items: makeLineItems(colors: deps.colors.dropFirst(4).prefix(5))
                ),
                ColorPickerView.Model.Line(
                    items: makeLineItems(colors: deps.colors.dropFirst(9).prefix(5))
                ),
                ColorPickerView.Model.Line(
                    items: makeLineItems(colors: deps.colors.dropFirst(14).prefix(5))
                ),
            ]
        )
    }
    
    func makeLineItems<T: Collection>(colors: T) -> [ColorPickerView.Model.LineItem] where T.Element == UIColor {
        return colors.map { color in
            ColorPickerView.Model.LineItem(
                image: .color.withTintColor(color),
                action: { [weak self] in
                    self?.deps.selectColor(color)
                }
            )
        }
    }
    
    func updateContentSize() {
        if expanded {
            view?.updateContentSize(to: CGSize(width: 256, height: 204))
        } else {
            view?.updateContentSize(to: CGSize(width: 256, height: 56))
        }
    }
}

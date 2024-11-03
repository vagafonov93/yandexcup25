//
//  ColorPickerViewController.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol ColorPickerViewControllerProtocol: AnyObject {
    func updateView(with model: ColorPickerView.Model)
    func updateContentSize(to size: CGSize)
}

final class ColorPickerViewController: UIViewController {
    
    private lazy var colorPicker = ColorPickerView()
    
    private let presenter: ColorPickerPresenterProtocol
    
    init(presenter: ColorPickerPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = colorPicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewLoaded()
    }
}

// MARK: - ColorPickerViewController

extension ColorPickerViewController: ColorPickerViewControllerProtocol {
    
    func updateView(with model: ColorPickerView.Model) {
        colorPicker.configure(with: model)
    }
    
    func updateContentSize(to size: CGSize) {
        preferredContentSize = size
    }
}

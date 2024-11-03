//
//  InstrumentsPickerViewController.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol InstrumentsPickerViewControllerProtocol: AnyObject {
    func updateView(with model: InstrumentsPickerView.Model)
}

final class InstrumentsPickerViewController: UIViewController {
    
    private lazy var instrumentsPicker = InstrumentsPickerView()
    
    private let presenter: InstrumentsPickerPresenterProtocol
    
    init(presenter: InstrumentsPickerPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = instrumentsPicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewLoaded()
    }
}

// MARK: - InstrumentsPickerViewControllerProtocol

extension InstrumentsPickerViewController: InstrumentsPickerViewControllerProtocol {
    
    func updateView(with model: InstrumentsPickerView.Model) {
        instrumentsPicker.configure(with: model)
    }
}

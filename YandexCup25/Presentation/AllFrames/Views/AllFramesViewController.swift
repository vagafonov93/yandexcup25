//
//  AllFramesViewController.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

protocol AllFramesViewControllerProtocol: AnyObject {
    func updateView(with model: AllFramesView.Model)
}

final class AllFramesViewController: UIViewController {
    
    private lazy var allFrames = AllFramesView()
    
    private let presenter: AllFramesPresenterProtocol
    
    init(presenter: AllFramesPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = allFrames
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewLoaded()
    }
}

// MARK: - AllFramesViewControllerProtocol

extension AllFramesViewController: AllFramesViewControllerProtocol {
    
    func updateView(with model: AllFramesView.Model) {
        allFrames.configure(with: model)
    }
}

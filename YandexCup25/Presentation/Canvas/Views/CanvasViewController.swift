//
//  CanvasViewController.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol CanvasViewControllerProtocol: AnyObject {
    var randomCenterPointInCanvas: CGPoint { get }
    
    var canvasSnapshot: UIImage { get }
    
    var colorPopoverSourceView: UIView? { get }
    var instrumentsPopoverSourceView: UIView? { get }
    
    func updateView(with model: CanvasView.Model)
    
    func startAnimation(model: ImagesAnimationModel)
    func stopAnimation()
}

final class CanvasViewController: UIViewController {
    
    private lazy var canvasView = CanvasView(frame: .zero)
    
    private let presenter: CanvasPresenterProtocol
    
    init(presenter: CanvasPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = canvasView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewLoaded()
    }
}

// MARK: - CanvasViewControllerProtocol

extension CanvasViewController: CanvasViewControllerProtocol {
    
    var randomCenterPointInCanvas: CGPoint {
        canvasView.canvasSize.getRandomCenterInside(for: .defaultInstrumentSize)
    }
    
    var colorPopoverSourceView: UIView? {
        canvasView.colorPopoverSourceView
    }
    
    var instrumentsPopoverSourceView: UIView? {
        canvasView.instrumentsPopoverSourceView
    }
    
    var canvasSnapshot: UIImage {
        canvasView.canvasSnapshot
    }
    
    func updateView(with model: CanvasView.Model) {
        canvasView.configure(with: model)
    }
    
    func startAnimation(model: ImagesAnimationModel) {
        canvasView.startAnimation(model: model)
    }
    
    func stopAnimation() {
        canvasView.stopAnimation()
    }
}

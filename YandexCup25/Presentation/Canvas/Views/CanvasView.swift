//
//  CanvasView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

final class CanvasView: UIView {
    
    // MARK: - Верхние кнопки действий
    
    private lazy var undoButton = UIButton.makeButton(
        image: .undoUnactive,
        action: { [weak self] in
            self?.model?.topPanelActions.undoAction()
        }
    )
    
    private lazy var redoButton = UIButton.makeButton(
        image: .redoUnactive,
        action: { [weak self] in
            self?.model?.topPanelActions.redoAction()
        }
    )
    
    private lazy var removeFrameButton = UIButton.makeButton(
        image: .bin,
        action: { [weak self] in
            self?.model?.topPanelActions.removeFrameAction()
        }
    )
    
    private lazy var addFrameButton = UIButton.makeButton(
        image: .filePlus,
        action: { [weak self] in
            self?.model?.topPanelActions.addFrameAction()
        }
    )
    
    private lazy var allFramesButton = UIButton.makeButton(
        image: .layers,
        action: { [weak self] in
            self?.model?.topPanelActions.allFramesAction()
        }
    )
    
    private lazy var pauseButton = UIButton.makeButton(
        image: .pauseUnactive,
        action: { [weak self] in
            self?.model?.topPanelActions.pauseAction()
        }
    )
    
    private lazy var playButton = UIButton.makeButton(
        image: .playUnactive,
        action: { [weak self] in
            self?.model?.topPanelActions.playAction()
        }
    )
    
    // MARK: - Нижние кнопки действий
    
    private lazy var pencilButton = UIButton.makeButton(
        image: .pencil,
        action: { [weak self] in
            self?.model?.bottomPanelActions.penAction()
        }
    )
    
    private lazy var brushButton = UIButton.makeButton(
        image: .brush,
        action: { [weak self] in
            self?.model?.bottomPanelActions.brushAction()
        }
    )
    
    private lazy var eraseButton = UIButton.makeButton(
        image: .erase,
        action: { [weak self] in
            self?.model?.bottomPanelActions.eraseAction()
        }
    )
    
    private lazy var instrumentsButton = UIButton.makeButton(
        image: .instruments,
        action: { [weak self] in
            self?.model?.bottomPanelActions.instrumentAction()
        }
    )
    
    private lazy var colorButton = UIButton.makeButton(
        image: .color,
        action: { [weak self] in
            self?.model?.bottomPanelActions.colorAction()
        }
    )
    
    // MARK: - Стек из верхних кнопок действий
    
    private lazy var historyStackView: UIStackView = {
        let historyStackView = UIStackView(arrangedSubviews: [undoButton, redoButton])
        historyStackView.translatesAutoresizingMaskIntoConstraints = false
        historyStackView.spacing = 8
        historyStackView.axis = .horizontal
        return historyStackView
    }()
    
    private lazy var operationsStackView: UIStackView = {
        let operationsStackView = UIStackView(arrangedSubviews: [removeFrameButton, addFrameButton, allFramesButton])
        operationsStackView.translatesAutoresizingMaskIntoConstraints = false
        operationsStackView.spacing = 16
        operationsStackView.axis = .horizontal
        return operationsStackView
    }()
    
    private lazy var playerStackView: UIStackView = {
        let playerStackView = UIStackView(arrangedSubviews: [pauseButton, playButton])
        playerStackView.translatesAutoresizingMaskIntoConstraints = false
        playerStackView.spacing = 16
        playerStackView.axis = .horizontal
        return playerStackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                historyStackView,
                operationsStackView,
                playerStackView,
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Анимация
    
    private lazy var playerImageView: UIImageView = {
        let playerImageView = UIImageView(image: nil)
        playerImageView.translatesAutoresizingMaskIntoConstraints = false
        playerImageView.isHidden = true
        return playerImageView
    }()
    
    // MARK: - Канвас
    
    private lazy var canvasImageView: UIImageView = {
        let canvasImageView = UIImageView(image: .canvas)
        canvasImageView.translatesAutoresizingMaskIntoConstraints = false
        return canvasImageView
    }()
    
    private var previousDraggableInstrumentViews: [DraggableInstrumentView] = []
    private var previousDrawableViews: [DrawableView] = []
    
    private lazy var canvasView: UIView = {
        let canvasView = UIView()
        canvasView.clipsToBounds = true
        canvasView.backgroundColor = .clear
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()
    
    // MARK: - Стек из нижних кнопок действий
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pencilButton, brushButton, eraseButton, instrumentsButton, colorButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Rнопка дополнительных действий
    
    private lazy var additionalActionsButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction(handler: { [weak self] _ in
                self?.model?.additionalActions.infoAction()
            }),
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Внутрянка
    
    private var model: Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        colorButton.layer.cornerRadius = colorButton.bounds.height / 2
        
        super.layoutSubviews()
    }
}

// MARK: - Public

extension CanvasView {
    
    func startAnimation(model: ImagesAnimationModel) {
        playerImageView.isHidden = false
        
        playerImageView.animationImages = model.images
        playerImageView.animationDuration = model.duration
        playerImageView.animationRepeatCount = model.repeatCount
        
        playerImageView.startAnimating()
    }
    
    func stopAnimation() {
        playerImageView.stopAnimating()
        
        playerImageView.animationImages = nil
        
        playerImageView.isHidden = true
    }
    
    var colorPopoverSourceView: UIView? {
        bottomStackView.arrangedSubviews.last
    }
    
    var instrumentsPopoverSourceView: UIView? {
        bottomStackView.arrangedSubviews.dropLast().last
    }
    
    var canvasSize: CGSize {
        canvasView.bounds.size
    }
    
    var canvasSnapshot: UIImage {
        viewsToExcludeFromSnapshot.forEach { $0.isHidden = true }
        
        let image = UIGraphicsImageRenderer(size: canvasSize).image { context in
            canvasView.layer.render(in: context.cgContext)
        }
        
        viewsToExcludeFromSnapshot.forEach { $0.isHidden = false }
        
        return image
    }
    
    func configure(with model: Model) {
        self.model = model
        
        // установка иконок в верхнюю панель
        undoButton.isUserInteractionEnabled = model.topPanelActions.undoActionAvailable
        undoButton.setImage(model.topPanelActions.undoActionImage, for: .normal)
        redoButton.isUserInteractionEnabled = model.topPanelActions.redoActionAvailable
        redoButton.setImage(model.topPanelActions.redoActionImage, for: .normal)
        removeFrameButton.isUserInteractionEnabled = model.topPanelActions.removeFrameActionAvailable
        removeFrameButton.setImage(model.topPanelActions.removeFrameActionImage, for: .normal)
        addFrameButton.isUserInteractionEnabled = model.topPanelActions.addFrameActionAvailable
        addFrameButton.setImage(model.topPanelActions.addFrameActionImage, for: .normal)
        allFramesButton.isUserInteractionEnabled = model.topPanelActions.allFramesActionAvailable
        allFramesButton.setImage(model.topPanelActions.allFramesActionImage, for: .normal)
        pauseButton.isUserInteractionEnabled = model.topPanelActions.pauseActionAvailable
        pauseButton.setImage(model.topPanelActions.pauseActionImage, for: .normal)
        playButton.isUserInteractionEnabled = model.topPanelActions.playActionAvailable
        playButton.setImage(model.topPanelActions.playActionImage, for: .normal)
        
        // установка иконок в нижнюю панель
        pencilButton.setImage(model.bottomPanelActions.penActionImage, for: .normal)
        brushButton.setImage(model.bottomPanelActions.brushActionImage, for: .normal)
        eraseButton.setImage(model.bottomPanelActions.eraseActionImage, for: .normal)
        instrumentsButton.setImage(model.bottomPanelActions.instrumentActionImage, for: .normal)
        colorButton.setImage(model.bottomPanelActions.colorActionImage, for: .normal)
        colorButton.layer.borderColor = model.bottomPanelActions.colorActionBorderColor?.cgColor
        bottomStackView.isHidden = model.bottomPanelActions.isHidden
        
        // поле для рисования
        canvasView.removeAllDrawingViews()
        
        previousDraggableInstrumentViews = model.canvas.previousDraggableInstruments.map {
            canvasView.addDraggableInstrumentView(with: $0)
        }
        model.canvas.draggableInstruments.forEach {
            canvasView.addDraggableInstrumentView(with: $0)
        }
        
        previousDrawableViews = model.canvas.previousDrawings.map {
            canvasView.addDrawableView(with: $0)
        }
        model.canvas.drawings.forEach {
            canvasView.addDrawableView(with: $0)
        }
        
        canvasView.sortAllDrawingsByTag()
        
        // кнопка доп действий
        additionalActionsButton.isHidden = !model.additionalActions.infoActionAvailable
    }
}

// MARK: - Private

private extension CanvasView {
    
    var viewsToExcludeFromSnapshot: [UIView] {
        previousDrawableViews + previousDraggableInstrumentViews
    }
    
    func setup() {
        backgroundColor = .black
        
        colorButton.layer.borderWidth = UIScreen.main.scale
        
        addSubview(headerStackView)
        addSubview(canvasView)
        addSubview(bottomStackView)
        addSubview(playerImageView)
        addSubview(additionalActionsButton)
        canvasView.addSubview(canvasImageView)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            headerStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            headerStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            
            canvasView.leadingAnchor.constraint(
                equalTo: headerStackView.leadingAnchor
            ),
            canvasView.trailingAnchor.constraint(
                equalTo: headerStackView.trailingAnchor
            ),
            canvasView.topAnchor.constraint(
                equalTo: headerStackView.bottomAnchor,
                constant: 32
            ),
            canvasView.bottomAnchor.constraint(
                equalTo: bottomStackView.topAnchor,
                constant: -22
            ),
            
            canvasImageView.leadingAnchor.constraint(
                equalTo: canvasView.leadingAnchor
            ),
            canvasImageView.trailingAnchor.constraint(
                equalTo: canvasView.trailingAnchor
            ),
            canvasImageView.topAnchor.constraint(
                equalTo: canvasView.topAnchor
            ),
            canvasImageView.bottomAnchor.constraint(
                equalTo: canvasView.bottomAnchor
            ),
            
            playerImageView.leadingAnchor.constraint(
                equalTo: canvasView.leadingAnchor
            ),
            playerImageView.trailingAnchor.constraint(
                equalTo: canvasView.trailingAnchor
            ),
            playerImageView.topAnchor.constraint(
                equalTo: canvasView.topAnchor
            ),
            playerImageView.bottomAnchor.constraint(
                equalTo: canvasView.bottomAnchor
            ),
            
            bottomStackView.centerXAnchor.constraint(
                equalTo: centerXAnchor
            ),
            bottomStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            
            additionalActionsButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            additionalActionsButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
        ])
    }
}

//
//  CanvasPresenter.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol CanvasPresenterProtocol: AnyObject {
    func viewLoaded()
}

final class CanvasPresenter {
    
    // MARK: - Public
    
    weak var view: CanvasViewControllerProtocol?
    
    // MARK: - Private
    
    private let deps: Deps
    
    private var modalScenario: ModalScenario?
    private var drawingScenario: DrawingScenario?
    
    private var snapshot: CanvasSnapshot
    
    // MARK: - Внутрянка
    
    init(deps: Deps) {
        self.deps = deps
        self.snapshot = deps.canvasStore.snapshot
    }
}

// MARK: - CanvasPresenterProtocol

extension CanvasPresenter: CanvasPresenterProtocol {
    
    func viewLoaded() {
        updateViewModel()
    }
}

// MARK: - CanvasViewModelDelegate

extension CanvasPresenter: CanvasViewModelDelegate {
    
    var previousDrawings: [DrawableView.Model] {
        let drawings = deps.canvasStore.previousCanvas?.drawings
        let tagSubtractFactor = deps.canvasStore.previousCanvas?.tag ?? 0
        
        return drawings?.enumerated().map { item in
            let drawing = item.element
            
            return DrawableView.Model(
                tag: drawing.tag - tagSubtractFactor,
                lineWidth: drawing.lineWidth,
                strokeColor: drawing.color.withAlphaComponent(0.5),
                lines: drawing.lines.map { .init(points: $0.points) },
                didBeginDrawingLine: {_ in},
                didAddPointToLine: {_ in},
                didFinishDrawingLine: {},
                isUserInteractionEnabled: false
            )
        } ?? []
    }
    
    var drawings: [DrawableView.Model] {
        let drawings = deps.canvasStore.currentCanvas.drawings
            
        return drawings.enumerated().map { item in
            let drawing = item.element
            
            return DrawableView.Model(
                tag: drawing.tag,
                lineWidth: drawing.lineWidth,
                strokeColor: drawing.color,
                lines: drawing.lines.map { .init(points: $0.points) },
                didBeginDrawingLine: { [unowned drawing] point in
                    drawing.lines.append(.init(points: [point]))
                },
                didAddPointToLine: { [unowned drawing] point in
                    drawing.lines.last?.points.append(point)
                },
                didFinishDrawingLine: { [unowned self] in
                    canvasStoreWillChange(snapshot: snapshot)
                    canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
                },
                isUserInteractionEnabled: item.offset == drawings.count - 1
                    && drawingScenario == .pencil
                    && !deps.animationController.isAnimating
            )
        }
    }
    
    var previousDraggableInstruments: [DraggableInstrumentView.Model] {
        let tagSubtractFactor = deps.canvasStore.previousCanvas?.tag ?? 0
        
        return deps.canvasStore.previousCanvas?.instruments.map { instrument in
            DraggableInstrumentView.Model(
                tag: instrument.tag - tagSubtractFactor,
                instrumentImage: instrument.instrument.image.withTintColor(
                    instrument.color.withAlphaComponent(0.5)
                ),
                center: instrument.center,
                didChangeCenter: {_ in},
                didFinishDragging: {},
                transform: instrument.transform,
                didChangeTransform: {_ in},
                didFinishTransforming: {},
                isUserInteractionEnabled: false
            )
        } ?? []
    }
    
    var draggableInstruments: [DraggableInstrumentView.Model] {
        deps.canvasStore.currentCanvas.instruments.map { instrument in
            DraggableInstrumentView.Model(
                tag: instrument.tag,
                instrumentImage: instrument.instrument.image.withTintColor(instrument.color),
                center: instrument.center,
                didChangeCenter: { [unowned instrument] center in
                    instrument.center = center
                },
                didFinishDragging: { [unowned self] in
                    canvasStoreWillChange(snapshot: snapshot)
                    canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
                },
                transform: instrument.transform,
                didChangeTransform: { [unowned instrument] transform in
                    instrument.transform = transform
                },
                didFinishTransforming: { [unowned self] in
                    canvasStoreWillChange(snapshot: snapshot)
                    canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
                },
                isUserInteractionEnabled: true
            )
        }
    }
    
    var canvasColor: UIColor {
        deps.canvasStore.currentCanvas.selectedColor
    }

    var undoActionAvailable: Bool {
        deps.undoManager.canUndo && !deps.animationController.isAnimating
    }
    
    var redoActionAvailable: Bool {
        deps.undoManager.canRedo && !deps.animationController.isAnimating
    }
    
    var removeFrameActionAvailable: Bool {
        deps.canvasStore.canDeleteCurrentCanvas && !deps.animationController.isAnimating
    }
    
    var addFrameActionAvailable: Bool {
        deps.canvasStore.canAddNewCanvas && !deps.animationController.isAnimating
    }
    
    var allFramesActionAvailable: Bool {
        !deps.animationController.isAnimating
    }
    
    var pauseActionAvailable: Bool {
        deps.animationController.isAnimating
    }
    
    var playActionAvailable: Bool {
        !deps.animationController.isAnimating
    }
    
    var colorActionActive: Bool {
        modalScenario == .colorPicker
    }
    
    var instrumentActionActive: Bool {
        modalScenario == .instrumentPicker
    }
    
    var isBottomPanelHidden: Bool {
        deps.animationController.isAnimating
    }
    
    var eraseActionActive: Bool {
        drawingScenario == .eraser && modalScenario == nil
    }
    
    var brushActionActive: Bool {
        false
    }
    
    var penActionActive: Bool {
        drawingScenario == .pencil && modalScenario == nil
    }
    
    var isAdditionalInfoAvailable: Bool {
        !deps.animationController.isAnimating
    }
    
    func undo() {
        deps.undoManager.undo()
    }
    
    func redo() {
        deps.undoManager.redo()
    }
    
    func removeFrame() {
        guard deps.canvasStore.canDeleteCurrentCanvas else { return }
        
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        deps.canvasStore.deleteCurrentCanvas()
        
        updateViewModel()
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func addFrame() {
        guard deps.canvasStore.canAddNewCanvas else { return }
        
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        storeCurrentCanvasSnapshot()
        
        deps.canvasStore.addNewCanvas()
        
        updateViewModel()
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func allFrames() {
        storeCurrentCanvasSnapshot()
        
        deps.router.showAllFrames { [weak self] in
            self?.handleSelectNewCanvasIndex($0)
        }
    }
    
    func pause() {
        deps.animationController.pauseAnimation()
    }
    
    func play() {
        storeCurrentCanvasSnapshot()
        
        let animationImages = deps.canvasStore.allCanvases.compactMap { $0.snapshot }

        view?.startAnimation(
            model: deps.animationController.startAnimation(
                images: animationImages,
                stop: { [weak self] in
                    self?.updateViewModel()
                    self?.view?.stopAnimation()
                }
            )
        )
        
        deps.canvasStore.setCurrentCanvas(index: animationImages.count - 1)
        
        updateViewModel()
    }
    
    func openColorSelector() {
        updateModalScenario(to: .colorPicker)
        
        deps.router.showColorPicker(
            sourceView: view?.colorPopoverSourceView,
            colorHandler: { [weak self] color in
                self?.handlePickedColor(color)
            },
            dismissHandler: { [weak self] in
                self?.updateModalScenario(to: nil)
            }
        )
    }
    
    func openInstrumentSelector() {
        updateModalScenario(to: .instrumentPicker)
        
        deps.router.showInstrumentsPicker(
            sourceView: view?.instrumentsPopoverSourceView,
            instrumentHandler: { [weak self] instrument in
                self?.handlePickedInstrument(instrument)
            },
            dismissHandler: { [weak self] in
                self?.updateModalScenario(to: nil)
            }
        )
    }
    
    func chooseErase() {
        showUnavailableFeature()
    }
    
    func chooseBrush() {
        showUnavailableFeature()
    }
    
    func choosePen() {
        // если уже в режиме рисования карандашом, то просто выключаем его
        if drawingScenario == .pencil {
            drawingScenario = nil
            
            updateViewModel()
            
            return
        }
        
        drawingScenario = .pencil
        
        deps.canvasStore.currentCanvas.addNewDrawing(lineWidth: deps.properties.lineWidth)
        
        updateViewModel()
    }
    
    func additionalInfo() {
        deps.router.showAdditionalActionsSheet(
            actions: [
                .init(
                    title: "Генерация N случайных кадров",
                    action: { [weak self] in
                        self?.deps.router.dismiss {
                            self?.handleGenerateRandomCanvases()
                        }
                    }
                ),
                .init(
                    title: "Дублировать текущий кадр",
                    action: { [weak self] in
                        self?.handleDuplicateCurrentCanvas()
                    }
                ),
                .init(
                    title: "Удалить все кадры",
                    action: { [weak self] in
                        self?.handleDeleteAllFrames()
                    }
                ),
                .init(
                    title: "Экспортировать в GIF",
                    action: { [weak self] in
                        self?.handleGifExport()
                    }
                ),
                .init(
                    title: "Изменить скорость анимации",
                    action: { [weak self] in
                        self?.deps.router.dismiss {
                            self?.handleChangeAnimationSpeed()
                        }
                    }
                ),
                .init(
                    title: "Изменить толщину кисти карандаша",
                    action: { [weak self] in
                        self?.deps.router.dismiss {
                            self?.handleChangeLineWidth()
                        }
                    }
                ),
            ]
        )
    }
}

// MARK: - Private

private extension CanvasPresenter {
    
    enum ModalScenario {
        case colorPicker
        case instrumentPicker
    }
    
    enum DrawingScenario {
        case pencil
        case eraser
    }
    
    func updateViewModel() {
        updateInternalStateIfNeeded()
        
        let viewModel = deps.viewModelFactory.makeCanvasViewModel(delegate: self)
        view?.updateView(with: viewModel)
    }
    
    func updateInternalStateIfNeeded() {
        if deps.canvasStore.currentCanvas.drawings.isEmpty, drawingScenario == .pencil {
            deps.canvasStore.currentCanvas.addNewDrawing(lineWidth: deps.properties.lineWidth)
        }
    }
    
    func showUnavailableFeature() {
        deps.router.showUnavailableFeatureAlert()
    }
    
    func updateModalScenario(to scenario: ModalScenario?) {
        modalScenario = scenario
        
        updateViewModel()
    }
    
    func handlePickedColor(_ color: UIColor) {
        // для стека изменений
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        // устанавливаем новый выбранный цвет
        deps.canvasStore.currentCanvas.selectedColor = color
        
        // убираем состояние модального окошка
        modalScenario = nil
        
        // убираем текущий режим рисования
        drawingScenario = nil
        
        // обновляем отображение
        updateViewModel()
        
        // скрываем физическое модальное окошко
        deps.router.dismiss()
        
        // сохраняем новый снапшот
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func handlePickedInstrument(_ instrument: Instrument) {
        // для стека изменений
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        // устанавливаем новый выбранный цвет
        deps.canvasStore.currentCanvas.addNewInstrument(
            instrument,
            at: view?.randomCenterPointInCanvas ?? .zero
        )
        
        // убираем состояние модального окошка
        modalScenario = nil
        
        // убираем текущий режим рисования
        drawingScenario = nil
        
        // обновляем отображение
        updateViewModel()
        
        // скрываем физическое модальное окошко
        deps.router.dismiss()
        
        // сохраняем новый снапшот
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func storeCurrentCanvasSnapshot() {
        deps.canvasStore.currentCanvas.snapshot = view?.canvasSnapshot
    }
    
    func handleSelectNewCanvasIndex(_ index: Int) {
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        deps.canvasStore.setCurrentCanvas(index: index)
        
        updateViewModel()
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func canvasStoreWillChange(snapshot: CanvasSnapshot) {
        deps.undoManager.registerUndo(withTarget: self) { presenter in
            let currentSnapshot = presenter.snapshot
            presenter.deps.canvasStore.apply(snapshot: snapshot)
            presenter.snapshot = presenter.deps.canvasStore.snapshot
            
            presenter.canvasStoreWillChange(snapshot: currentSnapshot)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.updateViewModel()
        }
    }
    
    func canvasStoreDidChange(snapshot: CanvasSnapshot) {
        self.snapshot = snapshot
    }
    
    func handleGenerateRandomCanvases() {
        deps.router.showAlertWithSingleTextInput(
            customTitle: "Введите значение N",
            didUpdateText: { [weak self] text in
                guard let framesToCreate = Int(text) else { return }
                
                self?.generateRandomCanvases(count: framesToCreate)
            }
        )
    }
    
    func generateRandomCanvases(count: Int) {
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        for _ in 0..<count {
            storeCurrentCanvasSnapshot()
            
            deps.canvasStore.addNewCanvas()
            
            deps.canvasStore.currentCanvas.selectedColor = UIColor.allColors.randomElement() ?? deps.canvasStore.currentCanvas.selectedColor
            deps.canvasStore.currentCanvas.addNewInstrument(
                Instrument.allCases.randomElement() ?? .arrow,
                at: view?.randomCenterPointInCanvas ?? .zero
            )
            
            updateViewModel()
        }
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func handleDuplicateCurrentCanvas() {
        guard deps.canvasStore.canAddNewCanvas else { return }
        
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        storeCurrentCanvasSnapshot()
        
        deps.canvasStore.addCopyOfCurrentCanvas()
        
        updateViewModel()
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func handleDeleteAllFrames() {
        canvasStoreWillChange(snapshot: deps.canvasStore.snapshot)
        
        deps.canvasStore.deleteAllCanvases()
        
        updateViewModel()
        
        canvasStoreDidChange(snapshot: deps.canvasStore.snapshot)
    }
    
    func handleGifExport() {
        if deps.gifGenerator.generate(at: .tempGifFileUrl) {
            deps.router.showShareActivity(
                activityItems: [
                    (try? Data(contentsOf: .tempGifFileUrl)) ?? Data()
                ]
            )
        }
    }
    
    func handleChangeAnimationSpeed() {
        deps.router.showAlertWithSingleTextInput(
            customTitle: "Введите время в секундах на 1 кадр анимации",
            didUpdateText: { [weak self] text in
                guard let frameSpeed = TimeInterval(text) else { return }
                
                self?.deps.properties.animationSpeed = frameSpeed
            }
        )
    }
    
    func handleChangeLineWidth() {
        drawingScenario = nil
        
        updateViewModel()
        
        deps.router.showAlertWithSingleTextInput(
            customTitle: "Введите значение толщины кисти (в пикселях)",
            didUpdateText: { [weak self] text in
                self?.deps.properties.lineWidth = CGFloat(Float(text) ?? 10)
            }
        )
    }
}

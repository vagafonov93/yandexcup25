//
//  CanvasViewModelFactory.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

protocol CanvasViewModelDelegate: AnyObject {
    var previousDrawings: [DrawableView.Model] { get }
    var drawings: [DrawableView.Model] { get }
    var previousDraggableInstruments: [DraggableInstrumentView.Model] { get }
    var draggableInstruments: [DraggableInstrumentView.Model] { get }
    var canvasColor: UIColor { get }
    
    var undoActionAvailable: Bool { get }
    var redoActionAvailable: Bool { get }
    var removeFrameActionAvailable: Bool { get }
    var addFrameActionAvailable: Bool { get }
    var allFramesActionAvailable: Bool { get }
    var pauseActionAvailable: Bool { get }
    var playActionAvailable: Bool { get }
    var colorActionActive: Bool { get }
    var instrumentActionActive: Bool { get }
    var eraseActionActive: Bool { get }
    var brushActionActive: Bool { get }
    var penActionActive: Bool { get }
    var isBottomPanelHidden: Bool { get }
    var isAdditionalInfoAvailable: Bool { get }
    
    func undo()
    func redo()
    func removeFrame()
    func addFrame()
    func allFrames()
    func pause()
    func play()
    func openColorSelector()
    func openInstrumentSelector()
    func chooseErase()
    func chooseBrush()
    func choosePen()
    func additionalInfo()
}

protocol CanvasViewModelFactoryProtocol: AnyObject {
    func makeCanvasViewModel(delegate: CanvasViewModelDelegate) -> CanvasView.Model
}

final class CanvasViewModelFactory: CanvasViewModelFactoryProtocol {
    
    func makeCanvasViewModel(delegate: CanvasViewModelDelegate) -> CanvasView.Model {
        CanvasView.Model(
            canvas: CanvasView.Model.Canvas(
                previousDraggableInstruments: delegate.previousDraggableInstruments,
                draggableInstruments: delegate.draggableInstruments,
                previousDrawings: delegate.previousDrawings,
                drawings: delegate.drawings
            ),
            topPanelActions: CanvasView.Model.TopPanelActions(
                undoActionAvailable: delegate.undoActionAvailable,
                undoAction: { [weak delegate] in delegate?.undo() },
                redoActionAvailable: delegate.redoActionAvailable,
                redoAction: { [weak delegate] in delegate?.redo() },
                removeFrameActionAvailable: delegate.removeFrameActionAvailable,
                removeFrameAction: { [weak delegate] in delegate?.removeFrame() },
                addFrameActionAvailable: delegate.addFrameActionAvailable,
                addFrameAction: { [weak delegate] in delegate?.addFrame() },
                allFramesActionAvailable: delegate.allFramesActionAvailable,
                allFramesAction: { [weak delegate] in delegate?.allFrames() },
                pauseActionAvailable: delegate.pauseActionAvailable,
                pauseAction: { [weak delegate] in delegate?.pause() },
                playActionAvailable: delegate.playActionAvailable,
                playAction: { [weak delegate] in delegate?.play() }
            ),
            bottomPanelActions: CanvasView.Model.BottomPanelActions(
                isHidden: delegate.isBottomPanelHidden,
                colorActionColor: delegate.canvasColor,
                colorActionActive: delegate.colorActionActive,
                colorAction: { [weak delegate] in delegate?.openColorSelector() },
                instrumentActionActive: delegate.instrumentActionActive,
                instrumentAction: { [weak delegate] in delegate?.openInstrumentSelector() },
                eraseActionActive: delegate.eraseActionActive,
                eraseAction: { [weak delegate] in delegate?.chooseErase() },
                brushActionActive: delegate.brushActionActive,
                brushAction: { [weak delegate] in delegate?.chooseBrush() },
                penActionActive: delegate.penActionActive,
                penAction: { [weak delegate] in delegate?.choosePen() }
            ),
            additionalActions: CanvasView.Model.AdditionalActions(
                infoActionAvailable: delegate.isAdditionalInfoAvailable,
                infoAction: { [weak delegate] in delegate?.additionalInfo() }
            )
        )
    }
}

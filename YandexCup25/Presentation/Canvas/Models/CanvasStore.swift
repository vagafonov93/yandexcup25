//
//  CanvasStore.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

protocol CanvasStoreProtocol: AnyObject {
    
    var allCanvases: [CanvasModel] { get }
    
    var currentCanvas: CanvasModel { get }
    
    var previousCanvas: CanvasModel? { get }
    
    var canDeleteCurrentCanvas: Bool { get }
    
    var canAddNewCanvas: Bool { get }
    
    var snapshot: CanvasSnapshot { get }
    
    @discardableResult
    func setCurrentCanvas(index: Int) -> CanvasModel
    
    @discardableResult
    func deleteAllCanvases() -> CanvasModel
    
    @discardableResult
    func deleteCurrentCanvas() -> CanvasModel
    
    @discardableResult
    func addNewCanvas() -> CanvasModel
    
    @discardableResult
    func addCopyOfCurrentCanvas() -> CanvasModel
    
    func apply(snapshot: CanvasSnapshot)
}

struct CanvasSnapshot: Equatable {
    let canvases: [CanvasModel]
    let canvasIndex: Int
    
    static func == (lhs: CanvasSnapshot, rhs: CanvasSnapshot) -> Bool {
        lhs.canvases == rhs.canvases && lhs.canvasIndex == rhs.canvasIndex
    }
}

final class CanvasStore {
    
    static let shared = CanvasStore()
    
    private var canvases: [CanvasModel] = [CanvasModel()]
    private var currentCanvasIndex = 0
}

// MARK: - CanvasStoreProtocol

extension CanvasStore: CanvasStoreProtocol {
    
    var snapshot: CanvasSnapshot {
        CanvasSnapshot(
            canvases: canvases.map { $0.copied },
            canvasIndex: currentCanvasIndex
        )
    }
    
    var allCanvases: [CanvasModel] {
        canvases
    }
    
    var currentCanvas: CanvasModel {
        canvases[currentCanvasIndex]
    }
    
    var previousCanvas: CanvasModel? {
        guard currentCanvasIndex > 0 else { return nil }
        
        return canvases[currentCanvasIndex - 1]
    }
    
    // TODO: если tag в текущем канвасе уже Int.max то будет проблема, надо обработать
    
    var canDeleteCurrentCanvas: Bool {
        canvases.count > 1 || !currentCanvas.isEmpty
    }
    
    var canAddNewCanvas: Bool {
        canvases.count < Int.max
    }
    
    func deleteCurrentCanvas() -> CanvasModel {
        if canvases.count > 1 {
            canvases.remove(at: currentCanvasIndex)
            currentCanvasIndex = max(0, currentCanvasIndex - 1)
        } else {
            canvases = [CanvasModel()]
            currentCanvasIndex = 0
        }
        
        return currentCanvas
    }
    
    func deleteAllCanvases() -> CanvasModel {
        canvases = [CanvasModel()]
        currentCanvasIndex = 0
        return currentCanvas
    }
    
    func addNewCanvas() -> CanvasModel {
        if currentCanvasIndex == canvases.count - 1 {
            canvases.append(CanvasModel())
        } else {
            canvases.insert(CanvasModel(), at: currentCanvasIndex + 1)
        }
        currentCanvasIndex += 1
        return currentCanvas
    }
    
    func addCopyOfCurrentCanvas() -> CanvasModel {
        if currentCanvasIndex == canvases.count - 1 {
            canvases.append(currentCanvas.copied)
        } else {
            canvases.insert(currentCanvas.copied, at: currentCanvasIndex + 1)
        }
        currentCanvasIndex += 1
        return currentCanvas
    }
    
    func setCurrentCanvas(index: Int) -> CanvasModel {
        currentCanvasIndex = index
        return currentCanvas
    }
    
    func apply(snapshot: CanvasSnapshot) {
        canvases = snapshot.canvases
        currentCanvasIndex = snapshot.canvasIndex
    }
}

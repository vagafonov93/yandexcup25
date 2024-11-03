//
//  CanvasModel.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

final class CanvasModel: Equatable {
    
    var tag = 0
    
    var selectedColor = UIColor.yandexBlue
    var instruments: [InstrumentModel] = []
    var drawings: [DrawingModel] = []
    var snapshot: UIImage?
    
    var isEmpty: Bool {
        instruments.isEmpty && drawings.allSatisfy { $0.lines.isEmpty }
    }
    
    var copied: CanvasModel {
        let model = CanvasModel()
        model.tag = tag
        model.instruments = instruments.map { $0.copied }
        model.drawings = drawings.map { $0.copied }
        model.selectedColor = selectedColor
        model.snapshot = snapshot
        return model
    }
    
    func addNewInstrument(_ instrument: Instrument, at center: CGPoint) {
        instruments.append(
            InstrumentModel(
                tag: tag,
                instrument: instrument,
                center: center,
                transform: .identity,
                color: selectedColor
            )
        )
        
        tag += 1
    }
    
    func addNewDrawing(lineWidth: CGFloat) {
        drawings.append(
            DrawingModel(
                tag: tag,
                lines: [],
                color: selectedColor,
                lineWidth: lineWidth
            )
        )
        
        tag += 1
    }
    
    static func == (lhs: CanvasModel, rhs: CanvasModel) -> Bool {
        lhs.instruments == rhs.instruments && lhs.drawings == rhs.drawings && lhs.selectedColor == rhs.selectedColor
    }
}

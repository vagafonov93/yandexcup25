//
//  InstrumentModel.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

enum Instrument: CaseIterable {
    case square
    case circle
    case triangle
    case arrow
    
    var image: UIImage {
        switch self {
        case .square: return .square
        case .circle: return .circle
        case .triangle: return .triangle
        case .arrow: return .arrowUp
        }
    }
}

final class InstrumentModel: Equatable {
    let tag: Int
    let instrument: Instrument
    var center: CGPoint
    var transform: CGAffineTransform
    let color: UIColor
    
    var copied: InstrumentModel {
        InstrumentModel(
            tag: tag,
            instrument: instrument,
            center: center,
            transform: transform,
            color: color
        )
    }
    
    init(tag: Int, instrument: Instrument, center: CGPoint, transform: CGAffineTransform, color: UIColor) {
        self.tag = tag
        self.instrument = instrument
        self.center = center
        self.transform = transform
        self.color = color
    }
    
    static func == (lhs: InstrumentModel, rhs: InstrumentModel) -> Bool {
        lhs.tag == rhs.tag
        && lhs.instrument == rhs.instrument
        && lhs.center == rhs.center
        && lhs.transform == rhs.transform
        && lhs.color == rhs.color
    }
}

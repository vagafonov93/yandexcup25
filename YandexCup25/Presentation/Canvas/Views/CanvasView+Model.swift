//
//  CanvasView+Model.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 29.10.2024.
//

import UIKit

extension CanvasView {
    
    struct Model {
        
        struct TopPanelActions {
            let undoActionAvailable: Bool
            let undoAction: () -> Void
            let redoActionAvailable: Bool
            let redoAction: () -> Void
            let removeFrameActionAvailable: Bool
            let removeFrameAction: () -> Void
            let addFrameActionAvailable: Bool
            let addFrameAction: () -> Void
            let allFramesActionAvailable: Bool
            let allFramesAction: () -> Void
            let pauseActionAvailable: Bool
            let pauseAction: () -> Void
            let playActionAvailable: Bool
            let playAction: () -> Void
            
            var undoActionImage: UIImage? {
                undoActionAvailable ? .undoActive : .undoUnactive
            }
            
            var redoActionImage: UIImage? {
                redoActionAvailable ? .redoActive : .redoUnactive
            }
            
            var removeFrameActionImage: UIImage? {
                removeFrameActionAvailable ? .bin : .bin.withTintColor(.yandexGray)
            }
            
            var addFrameActionImage: UIImage? {
                addFrameActionAvailable ? .filePlus : .filePlus.withTintColor(.yandexGray)
            }
            
            var allFramesActionImage: UIImage? {
                allFramesActionAvailable ? .layers : .layers.withTintColor(.yandexGray)
            }
            
            var pauseActionImage: UIImage? {
                pauseActionAvailable ? .pauseActive : .pauseUnactive
            }
            
            var playActionImage: UIImage? {
                playActionAvailable ? .playActive : .playUnactive
            }
        }
        
        struct BottomPanelActions {
            let isHidden: Bool
            let colorActionColor: UIColor
            let colorActionActive: Bool
            let colorAction: () -> Void
            let instrumentActionActive: Bool
            let instrumentAction: () -> Void
            let eraseActionActive: Bool
            let eraseAction: () -> Void
            let brushActionActive: Bool
            let brushAction: () -> Void
            let penActionActive: Bool
            let penAction: () -> Void
            
            var colorActionBorderColor: UIColor? {
                colorActionActive ? .yandexLime : .clear
            }
            
            var colorActionImage: UIImage? {
                .color.withTintColor(colorActionColor)
            }
            
            var instrumentActionImage: UIImage? {
                instrumentActionActive ? .instruments.withTintColor(.yandexLime) : .instruments
            }
            
            var eraseActionImage: UIImage? {
                eraseActionActive ? .erase.withTintColor(.yandexLime) : .erase
            }
            
            var brushActionImage: UIImage? {
                brushActionActive ? .brush.withTintColor(.yandexLime) : .brush
            }
            
            var penActionImage: UIImage? {
                penActionActive ? .pencil.withTintColor(.yandexLime) : .pencil
            }
        }
        
        struct Canvas {
            let previousDraggableInstruments: [DraggableInstrumentView.Model]
            let draggableInstruments: [DraggableInstrumentView.Model]
            
            let previousDrawings: [DrawableView.Model]
            let drawings: [DrawableView.Model]
        }
        
        struct AdditionalActions {
            let infoActionAvailable: Bool
            let infoAction: () -> Void
        }
        
        let canvas: Canvas
        let topPanelActions: TopPanelActions
        let bottomPanelActions: BottomPanelActions
        let additionalActions: AdditionalActions
    }
}

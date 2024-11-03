//
//  UndoManager.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 01.11.2024.
//

import Foundation

protocol UndoManagerProtocol: AnyObject {
    var canUndo: Bool { get }
    var canRedo: Bool { get }
    
    func undo()
    func redo()
    
    @preconcurrency
    func registerUndo<TargetType>(
        withTarget target: TargetType,
        handler: @escaping @Sendable (TargetType) -> Void
    ) where TargetType : AnyObject
}

extension UndoManager: UndoManagerProtocol {}

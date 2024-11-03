//
//  GIFGeneratorService.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 02.11.2024.
//

import ImageIO
import Foundation
import MobileCoreServices

protocol GIFGeneratorServiceProtocol: AnyObject {
    func generate(at url: URL) -> Bool
}

final class GIFGeneratorService: GIFGeneratorServiceProtocol {
    
    private let canvasStore: CanvasStoreProtocol
    private let properties: PropertiesContainerProtocol
    
    init(
        canvasStore: CanvasStoreProtocol = CanvasStore.shared,
        properties: PropertiesContainerProtocol = PropertiesContainer.shared
    ) {
        self.canvasStore = canvasStore
        self.properties = properties
    }
    
    func generate(at url: URL) -> Bool {
        let photos = canvasStore.allCanvases.compactMap { $0.snapshot }
        let fileProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
        let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: properties.animationSpeed]]
        let cfURL = url as CFURL
            
        if let destination = CGImageDestinationCreateWithURL(
            cfURL,
            kUTTypeGIF,
            photos.count,
            nil
        ) {
            CGImageDestinationSetProperties(
                destination,
                fileProperties as CFDictionary?
            )
            for photo in photos {
                CGImageDestinationAddImage(
                    destination,
                    photo.cgImage!,
                    gifProperties as CFDictionary?
                )
            }
            return CGImageDestinationFinalize(destination)
        }
        
        return false
    }
}

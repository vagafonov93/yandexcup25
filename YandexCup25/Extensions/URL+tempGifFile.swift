//
//  URL+tempGifFile.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 02.11.2024.
//

import Foundation

extension URL {
    static var tempGifFileUrl: URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("temp.gif", conformingTo: .gif)
    }
}

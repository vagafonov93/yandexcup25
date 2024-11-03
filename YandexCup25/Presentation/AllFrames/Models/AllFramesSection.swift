//
//  AllFramesSection.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

enum AllFramesSection {
    case main
}

struct AllFramesItem: Hashable {
    let id = UUID().uuidString
    let image: UIImage?
}

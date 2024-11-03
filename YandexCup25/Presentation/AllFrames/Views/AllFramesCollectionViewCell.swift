//
//  AllFramesCollectionViewCell.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

final class AllFramesCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "AllFramesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension AllFramesCollectionViewCell {
    
    func configure(with item: AllFramesItem) {
        imageView.image = item.image
    }
}

// MARK: - Private

private extension AllFramesCollectionViewCell {
    
    func setup() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            imageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

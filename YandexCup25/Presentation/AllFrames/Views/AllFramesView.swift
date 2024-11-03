//
//  AllFramesView.swift
//  YandexCup25
//
//  Created by Vasily Agafonov on 30.10.2024.
//

import UIKit

final class AllFramesView: UIView {
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.model?.close()
                }
            ),
            for: .touchUpInside
        )
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        label.text = "Все кадры"
        return label
    }()
    
    private lazy var framesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .allFramesCollectionCellSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 16
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(
            AllFramesCollectionViewCell.self,
            forCellWithReuseIdentifier: AllFramesCollectionViewCell.reuseId
        )
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<AllFramesSection, AllFramesItem>(
        collectionView: framesCollectionView
    ) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AllFramesCollectionViewCell.reuseId,
            for: indexPath
        ) as? AllFramesCollectionViewCell
        cell?.configure(with: itemIdentifier)
        return cell
    }
    
    private var model: Model?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public

extension AllFramesView {
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<AllFramesSection, AllFramesItem>
    
    struct Model {
        let items: [AllFramesItem]
        let selectFrame: (Int) -> Void
        let close: () -> Void
    }
    
    func configure(with model: Model) {
        self.model = model
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model.items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Public

extension AllFramesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        model?.selectFrame(indexPath.item)
    }
}

// MARK: - Private

private extension AllFramesView {
    
    func setup() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(framesCollectionView)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            closeButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 16
            ),
            
            titleLabel.topAnchor.constraint(
                equalTo: closeButton.bottomAnchor
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            
            framesCollectionView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 16
            ),
            framesCollectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            framesCollectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            framesCollectionView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
        ])
    }
}

//
//  ExcludePairsView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit

final class ExcludePairsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var collectionView = makeCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ExcludePairsView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
}

// MARK: Make constraints
private extension ExcludePairsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            collectionView.heightAnchor.constraint(equalToConstant: 88.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExcludePairsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 21.scale))
            .lineHeight(25.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "CSSExcludePairs.Pairs.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCollectionView() -> ExcludePairsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16.scale
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let view = ExcludePairsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

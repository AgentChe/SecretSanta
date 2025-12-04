//
//  ExcludePairsCollectionView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class ExcludePairsCollectionView: UICollectionView {
    private lazy var elements = [ExcludePairsCollectionElement]()
    
    private lazy var didTapDeletePairTrigger = PublishRelay<ExcludePairsCollectionPairElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ExcludePairsCollectionView {
    func setup(elements: [ExcludePairsCollectionElement]) {
        self.elements = elements
        
        reloadData()
        
        guard !elements.isEmpty else { return }
        
        let lastIndexPath = IndexPath(item: elements.count - 1, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.scrollToItem(at: lastIndexPath, at: .right, animated: false)
        }
    }
    
    var didTapDeletePair: Signal<ExcludePairsCollectionPairElement> {
        didTapDeletePairTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension ExcludePairsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .excludePair(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ExcludePairsCollectionPairCell.self), for: indexPath) as! ExcludePairsCollectionPairCell
            cell.setup(element: element)
            cell.didTapDelete = { [weak self] in
                self?.didTapDeletePairTrigger.accept(element)
            }
            return cell
        case .goingToSelect(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: ExcludePairsGoingToSelectCell.self), for: indexPath) as! ExcludePairsGoingToSelectCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ExcludePairsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 172.scale, height: bounds.height)
    }
}

// MARK: Private
private extension ExcludePairsCollectionView {
    func initialize() {
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(horizontal: 16.scale)
        setContentOffset(CGPoint(x: 16.scale, y: 0), animated: false)
        showsHorizontalScrollIndicator = false
        
        register(ExcludePairsCollectionPairCell.self, forCellWithReuseIdentifier: String(describing: ExcludePairsCollectionPairCell.self))
        register(ExcludePairsGoingToSelectCell.self, forCellWithReuseIdentifier: String(describing: ExcludePairsGoingToSelectCell.self))
        
        dataSource = self
        delegate = self 
    }
}

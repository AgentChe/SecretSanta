//
//  CSSExcludePairsTableView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 02.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CSSExcludePairsTableView: UITableView {
    private lazy var elements = [CSSExcludePairsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<Participient>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CSSExcludePairsTableView {
    func setup(elements: [CSSExcludePairsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<Participient> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CSSExcludePairsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: CSSExcludePairsTableCell.self), for: indexPath) as! CSSExcludePairsTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension CSSExcludePairsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row].participient)
    }
}

// MARK: Private
private extension CSSExcludePairsTableView {
    func initialize() {
        register(CSSExcludePairsTableCell.self, forCellReuseIdentifier: String(describing: CSSExcludePairsTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        setContentOffset(CGPoint(x: 0, y: -24.scale), animated: false)
        contentInset = UIEdgeInsets(vertical: 24.scale)
    }
}

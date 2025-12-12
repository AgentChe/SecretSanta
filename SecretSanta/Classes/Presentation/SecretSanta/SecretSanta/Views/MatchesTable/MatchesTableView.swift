//
//  MatchesTableView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 08.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MatchesTableView: UITableView {
    private lazy var elements = [MatchesElement]()
    
    private lazy var didSelectTrigger = PublishRelay<MatchesElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MatchesTableView {
    func setup(elements: [MatchesElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<MatchesElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension MatchesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: MatchesTableCell.self), for: indexPath) as! MatchesTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension MatchesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension MatchesTableView {
    func initialize() {
        register(MatchesTableCell.self, forCellReuseIdentifier: String(describing: MatchesTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        contentInset = UIEdgeInsets(vertical: 12.scale)
        setContentOffset(CGPoint(x: 0, y: -12.scale), animated: false)
        separatorStyle = .none
    }
}

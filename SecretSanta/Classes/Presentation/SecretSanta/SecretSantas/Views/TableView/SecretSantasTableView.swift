//
//  SecretSantasTableView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SecretSantasTableView: UITableView {
    private lazy var elements = [SecretSantasTableElement]()
    
    private lazy var didSelectElementTrigger = PublishRelay<SecretSantasTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SecretSantasTableView {
    func setup(elements: [SecretSantasTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectElement: Signal<SecretSantasTableElement> {
        didSelectElementTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SecretSantasTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: String(describing: SecretSantasTableCell.self)) as! SecretSantasTableCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UITableViewDelegate
extension SecretSantasTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectElementTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SecretSantasTableView {
    func initialize() {
        register(SecretSantasTableCell.self, forCellReuseIdentifier: String(describing: SecretSantasTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        separatorStyle = .none
        showsVerticalScrollIndicator = false
        setContentOffset(CGPoint(x: 0, y: 6.scale), animated: false)
        contentInset = UIEdgeInsets(t: 6.scale, b: 80.scale)
    }
}


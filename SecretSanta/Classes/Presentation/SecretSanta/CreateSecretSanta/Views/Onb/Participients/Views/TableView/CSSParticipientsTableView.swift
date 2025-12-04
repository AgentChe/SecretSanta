//
//  CSSParticipientsTableView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CSSParticipientsTableView: UITableView {
    private lazy var elements = [CSSParticipientsTableElement]()
    
    private lazy var didTapAddTrigger = PublishRelay<Void>()
    private lazy var didTapEditTrigger = PublishRelay<Participient>()
    private lazy var didTapDeleteTrigger = PublishRelay<Participient>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CSSParticipientsTableView {
    func setup(elements: [CSSParticipientsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapAdd: Signal<Void> {
        didTapAddTrigger.asSignal()
    }
    
    var didTapEdit: Signal<Participient> {
        didTapEditTrigger.asSignal()
    }
    
    var didTapDelete: Signal<Participient> {
        didTapDeleteTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension CSSParticipientsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .dummy(let index):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CSSParticipientsTableDummyCell.self), for: indexPath) as! CSSParticipientsTableDummyCell
            cell.setup(index: index)
            cell.didTapAdd = { [weak self] in
                self?.didTapAddTrigger.accept(Void())
            }
            return cell
        case .participient(let participient):
            let cell = dequeueReusableCell(withIdentifier: String(describing: CSSParticipientsTableCell.self), for: indexPath) as! CSSParticipientsTableCell
            cell.setup(participient: participient)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension CSSParticipientsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .participient(let participient) = elements[indexPath.row] else {
            return
        }
        
        didTapEditTrigger.accept(participient)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard case .participient(let participient) = elements[indexPath.row] else {
            return nil
        }
        
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            self?.didTapEditTrigger.accept(participient)
            completion(true)
        }
        editAction.image = UIImage(named: "CreateSecretSanta.Participients.Edit")
        editAction.backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.didTapDeleteTrigger.accept(participient)
            completion(true)
        }
        deleteAction.image = UIImage(named: "CreateSecretSanta.Participients.Delete")
        deleteAction.backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)

        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// MARK: Private
private extension CSSParticipientsTableView {
    func initialize() {
        register(CSSParticipientsTableDummyCell.self, forCellReuseIdentifier: String(describing: CSSParticipientsTableDummyCell.self))
        register(CSSParticipientsTableCell.self, forCellReuseIdentifier: String(describing: CSSParticipientsTableCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        setContentOffset(CGPoint(x: 0, y: -24.scale), animated: false)
        contentInset = UIEdgeInsets(vertical: 24.scale)
    }
}

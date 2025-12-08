//
//  SettingsTableView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 06.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsTableView: UITableView {
    private lazy var elements = [SettingsTableElement]()
    
    private lazy var didSelectTrigger = PublishRelay<SettingsTableElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelect: Signal<SettingsTableElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .paygate:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsPaygateCell.self), for: indexPath) as! SettingsPaygateCell
            cell.didTapOpenPaygate = { [weak self] in
                self?.didSelectTrigger.accept(.paygate)
            }
            return cell
        case .contactUs:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsRouteCell.self), for: indexPath) as! SettingsRouteCell
            cell.setup(route: .contactUs)
            return cell
        case .termsOfUse:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsRouteCell.self), for: indexPath) as! SettingsRouteCell
            cell.setup(route: .termsOfUse)
            return cell
        case .privacyPolicy:
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsRouteCell.self), for: indexPath) as! SettingsRouteCell
            cell.setup(route: .privacyPolicy)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case .paygate = elements[indexPath.row] {
            return
        }
        
        didSelectTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(SettingsPaygateCell.self, forCellReuseIdentifier: String(describing: SettingsPaygateCell.self))
        register(SettingsRouteCell.self, forCellReuseIdentifier: String(describing: SettingsRouteCell.self))
        
        dataSource = self
        delegate = self
        
        backgroundColor = UIColor.clear
        contentInset = UIEdgeInsets(vertical: 22.scale)
        setContentOffset(CGPoint(x: 0, y: -22.scale), animated: false)
        showsVerticalScrollIndicator = false
        separatorStyle = .none
    }
}

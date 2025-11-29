//
//  MainTabItemButton.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class MainTabItemButton: TapAreaButton {
    enum Item {
        case home, secretSantas, settings, paygate
    }
    
    lazy var marked = false
    
    lazy var label = makeLabel()
    
    private let item: Item
    
    init(item: Item) {
        self.item = item
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MainTabItemButton {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension MainTabItemButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainTabItemButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.text = {
            switch item {
            case .home:
                return "home"
            case .secretSantas:
                return "secretSantas"
            case .settings:
                return "settings"
            case .paygate:
                return "paygate"
            }
        }()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

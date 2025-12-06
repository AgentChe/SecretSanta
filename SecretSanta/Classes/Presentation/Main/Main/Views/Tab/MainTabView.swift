//
//  MainTabView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class MainTabView: UIView {
    enum DrawsItem {
        case home, secretSantas, settings
    }
    
    enum Style {
        case colored, normal
    }
    
    lazy var homeButtom = makeItemButton(item: .home)
    lazy var secretSantasButton = makeItemButton(item: .secretSantas)
    lazy var createSecretSantaButton = makeCreateSecretSantaButton()
    lazy var settingsButton = makeItemButton(item: .settings)
    lazy var paygateButton = makeItemButton(item: .paygate)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainTabView {
    func update(selectedItem: DrawsItem) {
        homeButtom.alpha = selectedItem == .home ? 1 : 0.3
        secretSantasButton.alpha = selectedItem == .secretSantas ? 1 : 0.3
        settingsButton.alpha = selectedItem == .settings ? 1 : 0.3
    }
    
    func update(style: Style) {
        let itemStyle: MainTabItemButton.Style = {
            switch style {
            case .colored:
                return .white
            case .normal:
                return .colored
            }
        }()
        [homeButtom, secretSantasButton, settingsButton, paygateButton].forEach { $0.update(style: itemStyle) }
        
        backgroundColor = {
            switch style {
            case .colored:
                return UIColor(integralRed: 146, green: 29, blue: 21)
            case .normal:
                return UIColor(integralRed: 255, green: 240, blue: 237)
            }
        }()
    }
}

// MARK: Private
private extension MainTabView {
    func initialize() {
        paygateButton.alpha = 0.3
    }
}

// MARK: Make constraints
private extension MainTabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            homeButtom.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeButtom.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            homeButtom.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            secretSantasButton.leadingAnchor.constraint(equalTo: homeButtom.trailingAnchor),
            secretSantasButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            secretSantasButton.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            createSecretSantaButton.widthAnchor.constraint(equalToConstant: 51.scale),
            createSecretSantaButton.heightAnchor.constraint(equalToConstant: 51.scale),
            createSecretSantaButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            createSecretSantaButton.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.trailingAnchor.constraint(equalTo: paygateButton.leadingAnchor),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            settingsButton.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
        
        NSLayoutConstraint.activate([
            paygateButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            paygateButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            paygateButton.widthAnchor.constraint(equalToConstant: 78.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainTabView {
    func makeItemButton(item: MainTabItemButton.Item) -> MainTabItemButton {
        let view = MainTabItemButton(item: item)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateSecretSantaButton() -> MainCreateSecretSantaButton {
        let view = MainCreateSecretSantaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

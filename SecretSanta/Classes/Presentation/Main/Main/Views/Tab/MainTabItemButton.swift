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
    
    enum Style {
        case white, colored
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    private lazy var whiteStyleAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.medium(size: 10.scale))
        .lineHeight(12.scale)
        .textAlignment(.center)
    private lazy var coloredStyleAttrs = TextAttributes()
        .textColor(Appearance.main400)
        .font(Fonts.SFPro.medium(size: 10.scale))
        .lineHeight(12.scale)
        .textAlignment(.center)
    
    private let item: Item
    
    init(item: Item) {
        self.item = item
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update(style: .white)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainTabItemButton {
    func update(style: Style) {
        let iconStyleCode: String = {
            switch style {
            case .white:
                return ".W"
            case .colored:
                return ".C"
            }
        }()
        let iconName: String = {
            switch item {
            case .home:
                return "Main.Tab.Home" + iconStyleCode
            case .secretSantas:
                return "Main.Tab.SecretSantas" + iconStyleCode
            case .settings:
                return "Main.Tab.Settings" + iconStyleCode
            case .paygate:
                return "Main.Tab.Paygate" + iconStyleCode
            }
        }()
        iconView.image = UIImage(named: iconName)
        
        let title: String = {
            switch item {
            case .home:
                return "Main.Tab.Home".localized
            case .secretSantas:
                return "Main.Tab.SecretSantas".localized
            case .settings:
                return "Main.Tab.Settings".localized
            case .paygate:
                return "Main.Tab.Paygate".localized
            }
        }()
        let attrs: TextAttributes = {
            switch style {
            case .white:
                return whiteStyleAttrs
            case .colored:
                return coloredStyleAttrs
            }
        }()
        label.attributedText = title.attributed(with: attrs)
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
            iconView.widthAnchor.constraint(equalToConstant: {
                switch item {
                case .home:
                    return 24.scale
                case .secretSantas:
                    return 24.scale
                case .settings:
                    return 25.scale
                case .paygate:
                    return 21.scale
                }
            }()),
            iconView.heightAnchor.constraint(equalToConstant: {
                switch item {
                case .home:
                    return 24.scale
                case .secretSantas:
                    return 19.scale
                case .settings:
                    return 25.scale
                case .paygate:
                    return 26.scale
                }
            }()),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MainTabItemButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

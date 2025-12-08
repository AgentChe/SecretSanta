//
//  SettingsRouteCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 06.12.2025.
//

import UIKit

final class SettingsRouteCell: UITableViewCell {
    enum Route {
        case contactUs
        case termsOfUse
        case privacyPolicy
    }
    
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var iconView = makeIconView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsRouteCell {
    func setup(route: Route) {
        let title: String = {
            switch route {
            case .contactUs:
                return "Settings.ContactUs".localized
            case .termsOfUse:
                return "Settings.TermsOfUse".localized
            case .privacyPolicy:
                return "Settings.PrivacyPolicy".localized
            }
        }()
        label.attributedText = title.attributed(with: attrs)
    }
}

// MARK: Private
private extension SettingsRouteCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SettingsRouteCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 13.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsRouteCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Settings.Arrow")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

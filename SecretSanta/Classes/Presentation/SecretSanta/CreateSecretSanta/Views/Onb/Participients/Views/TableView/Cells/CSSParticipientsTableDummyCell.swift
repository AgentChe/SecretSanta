//
//  CSSParticipientsTableDummyCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit

final class CSSParticipientsTableDummyCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    lazy var addButton = makeAddButton()
    
    var didTapAdd: (() -> Void)?
    
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
extension CSSParticipientsTableDummyCell {
    func setup(index: Int) {
        let string = String(format: "CSSParticipients.AddUser".localized, index)
        label.attributedText = string.attributed(with: attrs)
    }
}

// MARK: Private
private extension CSSParticipientsTableDummyCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func addTapped() {
        didTapAdd?()
    }
}

// MARK: Make constraints
private extension CSSParticipientsTableDummyCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 48.scale),
            iconView.heightAnchor.constraint(equalToConstant: 48.scale),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 81.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -89.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 34.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -34.scale)
        ])
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 56.scale),
            addButton.heightAnchor.constraint(equalToConstant: 42.scale),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -23.scale),
            addButton.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSParticipientsTableDummyCell {
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
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateSecretSanta.Participients.Avatar")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeAddButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("+".attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main200
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}

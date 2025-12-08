//
//  SettingsPaygateCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 06.12.2025.
//

import UIKit

final class SettingsPaygateCell: UITableViewCell {
    var didTapOpenPaygate: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tryButton = makeTryButton()
    lazy var pictureView = makeImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsPaygateCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func tryTapped() {
        didTapOpenPaygate?()
    }
}

// MARK: Make constraints
private extension SettingsPaygateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale),
            container.heightAnchor.constraint(equalToConstant: 149.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            tryButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            tryButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale),
            tryButton.widthAnchor.constraint(equalToConstant: 155.scale),
            tryButton.heightAnchor.constraint(equalToConstant: 42.scale)
        ])
        
        NSLayoutConstraint.activate([
            pictureView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: container.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            pictureView.widthAnchor.constraint(equalToConstant: 161.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsPaygateCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 24.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.CinzelDecorative.bold(size: 21.scale))
            .lineHeight(28.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Settings.Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.5))
            .font(Fonts.SFPro.regular(size: 15.scale))
            .lineHeight(18.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Settings.Paygate.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTryButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Settings.Paygate.Action".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 16.scale
        view.addTarget(self, action: #selector(tryTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Settings.Paygate")
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

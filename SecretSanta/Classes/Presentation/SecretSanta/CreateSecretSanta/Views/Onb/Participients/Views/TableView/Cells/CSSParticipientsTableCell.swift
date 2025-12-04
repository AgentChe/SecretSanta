//
//  CSSParticipientsTableCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit

final class CSSParticipientsTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var abbreviationView = makeAbbreviationView()
    lazy var abbreviationLabel = makeAbbreviationLabel()
    lazy var dataContainer = makeDataContainer()
    lazy var nameLabel = makeLabel()
    lazy var emailLabel = makeLabel()
    
    private lazy var abbreviationAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    private lazy var emailAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.2))
        .font(Fonts.SFPro.medium(size: 15.scale))
        .lineHeight(18.scale)
        .textAlignment(.left)
        .lineBreakMode(.byTruncatingTail)
    
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
extension CSSParticipientsTableCell {
    func setup(participient: Participient) {
        let abbreviation = participient.name
            .split(whereSeparator: { $0.isWhitespace })
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .prefix(2)
            .joined()
        abbreviationLabel.attributedText = abbreviation.attributed(with: abbreviationAttrs)
        
        nameLabel.attributedText = participient.name.attributed(with: nameAttrs)
        emailLabel.attributedText = participient.email.attributed(with: emailAttrs)
    }
}

// MARK: Private
private extension CSSParticipientsTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension CSSParticipientsTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            abbreviationView.widthAnchor.constraint(equalToConstant: 48.scale),
            abbreviationView.heightAnchor.constraint(equalToConstant: 48.scale),
            abbreviationView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            abbreviationView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            abbreviationLabel.centerXAnchor.constraint(equalTo: abbreviationView.centerXAnchor),
            abbreviationLabel.centerYAnchor.constraint(equalTo: abbreviationView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dataContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 81.scale),
            dataContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -23.scale),
            dataContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 23.scale),
            dataContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -23.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: dataContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: dataContainer.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: dataContainer.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.leadingAnchor.constraint(equalTo: dataContainer.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: dataContainer.trailingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4.scale),
            emailLabel.bottomAnchor.constraint(equalTo: dataContainer.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSParticipientsTableCell {
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
    
    func makeAbbreviationView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 24.scale
        view.backgroundColor = UIColor(integralRed: 250, green: 240, blue: 237)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeAbbreviationLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        abbreviationView.addSubview(view)
        return view
    }
    
    func makeDataContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        dataContainer.addSubview(view)
        return view
    }
}

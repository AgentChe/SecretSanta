//
//  MatchesTableCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 08.12.2025.
//

import UIKit

final class MatchesTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var p1Label = makeNameLabel()
    lazy var xLabel = makeXLabel()
    lazy var p2Label = makeNameLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.main400)
        .font(Fonts.CinzelDecorative.bold(size: 22.scale))
        .lineHeight(30.scale)
        .textAlignment(.center)
    
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
extension MatchesTableCell {
    func setup(element: MatchesElement) {
        p1Label.attributedText = element.participientOne.name.attributed(with: nameAttrs)
        p2Label.attributedText = element.participientTwo.name.attributed(with: nameAttrs)
    }
}

// MARK: Private
private extension MatchesTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension MatchesTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            p1Label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            p1Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            p1Label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            xLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            xLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            xLabel.topAnchor.constraint(equalTo: p1Label.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            p2Label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            p2Label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            p2Label.topAnchor.constraint(equalTo: xLabel.bottomAnchor, constant: 2.scale),
            p2Label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MatchesTableCell {
    func makeContainer() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "SecretSanta.List.BackgroundCell")
        view.layer.cornerRadius = 24.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeXLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 21.scale))
            .lineHeight(25.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "x".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

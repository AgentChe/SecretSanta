//
//  ExcludePairsGoingToSelectCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit

final class ExcludePairsGoingToSelectCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var selectedParticipientView = makeAbbreviationView()
    lazy var participientLabel = makeParticipientLabel()
    lazy var xLabel = makeXLabel()
    lazy var emptyAbbreviationView = makeAbbreviationView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 17.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
    
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
extension ExcludePairsGoingToSelectCell {
    func setup(element: Participient) {
        let abbreviation = element.name
            .split(whereSeparator: { $0.isWhitespace })
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .prefix(2)
            .joined()
        participientLabel.attributedText = abbreviation.attributed(with: attrs)
    }
}

// MARK: Private
private extension ExcludePairsGoingToSelectCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ExcludePairsGoingToSelectCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            selectedParticipientView.widthAnchor.constraint(equalToConstant: 48.scale),
            selectedParticipientView.heightAnchor.constraint(equalToConstant: 48.scale),
            selectedParticipientView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale),
            selectedParticipientView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            participientLabel.centerXAnchor.constraint(equalTo: selectedParticipientView.centerXAnchor),
            participientLabel.centerYAnchor.constraint(equalTo: selectedParticipientView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            xLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            xLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyAbbreviationView.widthAnchor.constraint(equalToConstant: 48.scale),
            emptyAbbreviationView.heightAnchor.constraint(equalToConstant: 48.scale),
            emptyAbbreviationView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -23.scale),
            emptyAbbreviationView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ExcludePairsGoingToSelectCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 255, green: 156, blue: 156, alpha: 0.2)
        view.layer.cornerRadius = 24.scale
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor(integralRed: 255, green: 156, blue: 156).cgColor
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
    
    func makeParticipientLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        selectedParticipientView.addSubview(view)
        return view
    }
    
    func makeXLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "X".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

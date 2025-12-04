//
//  ExcludePairsCollectionPairCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit

final class ExcludePairsCollectionPairCell: UICollectionViewCell {
    var didTapDelete: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var participientOneView = makeParticipientView(label: participientOneLabel)
    lazy var participientOneLabel = UILabel()
    lazy var xLabel = makeXLabel()
    lazy var participientTwoView = makeParticipientView(label: participientTwoLabel)
    lazy var participientTwoLabel = UILabel()
    lazy var deleteButton = makeDeleteButton()
    
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
extension ExcludePairsCollectionPairCell {
    func setup(element: ExcludePairsCollectionPairElement) {
        let participientOneAbbreviation = abbreviation(name: element.participientOne.name)
        participientOneLabel.attributedText = participientOneAbbreviation.attributed(with: attrs)
        
        let participientTwoAbbreviation = abbreviation(name: element.participientTwo.name)
        participientTwoLabel.attributedText = participientTwoAbbreviation.attributed(with: attrs)
    }
}

// MARK: Private
private extension ExcludePairsCollectionPairCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
    
    @objc
    func deleteTapped() {
        didTapDelete?()
    }
    
    func abbreviation(name: String) -> String {
        name
            .split(whereSeparator: { $0.isWhitespace })
            .compactMap { $0.first }
            .map { String($0).uppercased() }
            .prefix(2)
            .joined()
    }
}

// MARK: Make constraints
private extension ExcludePairsCollectionPairCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            participientOneView.widthAnchor.constraint(equalToConstant: 48.scale),
            participientOneView.heightAnchor.constraint(equalToConstant: 48.scale),
            participientOneView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale),
            participientOneView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            xLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            xLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            participientTwoView.widthAnchor.constraint(equalToConstant: 48.scale),
            participientTwoView.heightAnchor.constraint(equalToConstant: 48.scale),
            participientTwoView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -23.scale),
            participientTwoView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 20.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 20.scale),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 5.scale),
            deleteButton.topAnchor.constraint(equalTo: container.topAnchor, constant: -3.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ExcludePairsCollectionPairCell {
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
    
    func makeParticipientView(label: UILabel) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 24.scale
        view.backgroundColor = UIColor(integralRed: 250, green: 240, blue: 237)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
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
    
    func makeDeleteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CreateSecretSanta.ExcludePairs.Delete"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}

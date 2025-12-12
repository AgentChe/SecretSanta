//
//  SecretSantaView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 08.12.2025.
//

import UIKit

final class SecretSantaView: UIView {
    enum ListForm {
        case list, cards
    }
    
    lazy var listFormButton = makeListFormButton()
    lazy var closeButton = makeCloseButton()
    lazy var nameLabel = makeLabel()
    lazy var tableView = makeTableView()
    lazy var cardsView = makeCardsView()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.CinzelDecorative.bold(size: 30.scale))
        .lineHeight(36.scale)
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
    
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
extension SecretSantaView {
    func setup(listForm: ListForm) {
        let iconName: String = {
            switch listForm {
            case .list:
                return "SecretSanta.ListForm.Cards"
            case .cards:
                return "SecretSanta.ListForm.List"
            }
        }()
        listFormButton.setImage(UIImage(named: iconName), for: .normal)
        
        tableView.isHidden = listForm == .cards
        cardsView.isHidden = listForm == .list
    }
    
    func setup(name: String) {
        nameLabel.attributedText = name.attributed(with: nameAttrs)
    }
}

// MARK: Private
private extension SecretSantaView {
    func initialize() {
        backgroundColor = Appearance.main400
    }
}

// MARK: Make constraints
private extension SecretSantaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            listFormButton.widthAnchor.constraint(equalToConstant: 24.scale),
            listFormButton.heightAnchor.constraint(equalToConstant: 24.scale),
            listFormButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            listFormButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 11.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 47.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cardsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardsView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 77.scale),
            cardsView.heightAnchor.constraint(equalToConstant: MatchesCardsView.Constants.cardHeight + 32.scale + 116.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SecretSantaView {
    func makeListFormButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "SecretSanta.Close"), for: .normal)
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
    
    func makeTableView() -> MatchesTableView {
        let view = MatchesTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCardsView() -> MatchesFormView {
        let view = MatchesFormView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

//
//  SecretSantasView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class SecretSantasView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var emptyView = makeEmptyView()
    lazy var createNewEventButton = makeCreateNewEventButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SecretSantasView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
}

// MARK: Make constraints
private extension SecretSantasView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            emptyView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            createNewEventButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            createNewEventButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            createNewEventButton.heightAnchor.constraint(equalToConstant: 60.scale),
            createNewEventButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SecretSantasView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "SecretSantas.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> SecretSantasTableView {
        let view = SecretSantasTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyView() -> SecretSantasEmptyView {
        let view = SecretSantasEmptyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateNewEventButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 129, green: 20, blue: 20))
            .font(Fonts.SFPro.medium(size: 17.scale))
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 234, green: 200, blue: 198)
        view.layer.cornerRadius = 24.scale
        view.layer.borderWidth = 3.scale
        view.layer.borderColor = UIColor(integralRed: 129, green: 20, blue: 20).cgColor
        view.setAttributedTitle("SecretSantas.CreateEvent".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

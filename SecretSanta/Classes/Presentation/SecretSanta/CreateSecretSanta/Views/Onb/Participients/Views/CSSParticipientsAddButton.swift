//
//  CSSParticipientsAddButton.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit

final class CSSParticipientsAddButton: GradientButton {
    lazy var iconView = makeIconView()
    
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
private extension CSSParticipientsAddButton {
    func initialize() {
        gradientLayer.colors = [
            UIColor(integralRed: 21, green: 93, blue: 82).cgColor,
            UIColor(integralRed: 9, green: 57, blue: 49).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1),
        ]
        gradientLayer.cornerRadius = 24.scale
        gradientLayer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension CSSParticipientsAddButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 18.scale),
            iconView.heightAnchor.constraint(equalToConstant: 20.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSParticipientsAddButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CreateSecretSanta.Participients.Add")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

//
//  MainCreateSecretSantaButton.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 06.12.2025.
//

import UIKit

final class MainCreateSecretSantaButton: GradientButton {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MainCreateSecretSantaButton {
    func initialize() {
        gradientLayer.colors = Appearance.main100
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        gradientLayer.cornerRadius = 18.scale
    }
}

// MARK: Private
private extension MainCreateSecretSantaButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2.scale)
        ])
    }
}

// MARK: Private
private extension MainCreateSecretSantaButton {
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.regular(size: 36.scale))
        
        let view = UILabel()
        view.attributedText = "+".attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

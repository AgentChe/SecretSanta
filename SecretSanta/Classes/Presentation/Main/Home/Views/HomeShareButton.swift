//
//  HomeShareButton.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 05.12.2025.
//

import UIKit

final class HomeShareButton: GradientButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
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
private extension HomeShareButton {
    func initialize() {
        gradientLayer.colors = Appearance.main100
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        gradientLayer.cornerRadius = 16.scale
    }
}

// MARK: Make constraints
private extension HomeShareButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 15.scale),
            iconView.heightAnchor.constraint(equalToConstant: 19.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 37.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeShareButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Home.Share")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = UILabel()
        view.attributedText = "Home.Share".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

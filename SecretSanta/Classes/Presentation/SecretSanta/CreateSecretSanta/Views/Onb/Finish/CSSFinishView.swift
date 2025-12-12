//
//  CSSFinishView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit

final class CSSFinishView: UIView {
    weak var vc: UIViewController?
    
    lazy var backgroundView = makeBackgroundView()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var revealNowButton = makeRevealNowButton()
    lazy var skipButton = makeSkipButton()
    
    private let finish: () -> Void
    
    private var secretSantaId: String?
    
    init(finish: @escaping () -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CSSFinishView {
    func setup(secretSantaId: String) {
        self.secretSantaId = secretSantaId
    }
}

// MARK: Private
private extension CSSFinishView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
        layer.masksToBounds = true
    }
    
    @objc
    func revealNowTapped() {
        guard let vc, let secretSantaId else { return }
        
        let ssVC = SecretSantaViewController.make(secretSantaId: secretSantaId, cardsInitialState: .hidden)
        vc.present(ssVC, animated: true)
    }
    
    @objc
    func skipTapped() {
        finish()
    }
}

// MARK: Make constraints
private extension CSSFinishView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 402.scale),
            imageView.heightAnchor.constraint(equalToConstant: 402.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 36.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            revealNowButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            revealNowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            revealNowButton.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale),
            revealNowButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            skipButton.heightAnchor.constraint(equalToConstant: 58.scale),
            skipButton.topAnchor.constraint(equalTo: revealNowButton.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSFinishView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "CreateSecretSanta.Finish.Background")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "CreateSecretSanta.Finish.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSFinish.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100.withAlphaComponent(0.8))
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let titleKey = SessionManager().hasActiveSubscriptions() ? "CSSFinish.SubTitle.AS.True" : "CSSFinish.SubTitle.AS.False"
        
        let view = UILabel()
        view.attributedText = titleKey.localized.attributed(with: attrs)
        view.numberOfLines = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRevealNowButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("CSSFinish.RevealNow".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 20.scale
        view.addTarget(self, action: #selector(revealNowTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSkipButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = TapAreaButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("Skip".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

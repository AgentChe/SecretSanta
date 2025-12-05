//
//  HomeView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 05.12.2025.
//

import UIKit

final class HomeView: UIView {
    lazy var backgroundView = makeBackgroundView()
    lazy var scrollView = makeScrollView()
    lazy var shareButton = makeShareButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var imageView = makeImageView()
    lazy var startSecretSantaButton = makeStartSecretSantaButton()
    lazy var instructionView = makeInstructionView()
    
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
private extension HomeView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
}

// MARK: Make constraints
private extension HomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            shareButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 6.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 54.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13.scale),
            imageView.heightAnchor.constraint(equalToConstant: 230.scale)
        ])
        
        NSLayoutConstraint.activate([
            startSecretSantaButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            startSecretSantaButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            startSecretSantaButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 44.scale),
            startSecretSantaButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            instructionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            instructionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            instructionView.topAnchor.constraint(equalTo: startSecretSantaButton.bottomAnchor, constant: 32.scale),
            instructionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "Home.Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> HomeShareButton {
        let view = HomeShareButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.NewYork.mediumBold(size: 80.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Home.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Home.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeStartSecretSantaButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Home.StartSecretSanta".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
    
    func makeInstructionView() -> HomeInstructionView {
        let view = HomeInstructionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}

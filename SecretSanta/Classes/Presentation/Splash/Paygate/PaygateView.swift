//
//  PaygateView.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 20.02.2024.
//

import UIKit

final class PaygateView: UIView {
    lazy var imageView = makeImageView()
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(number: 1)
    lazy var cell2 = makeCell(number: 2)
    lazy var cell3 = makeCell(number: 3)
    lazy var product1Button = makeProductButton()
    lazy var product2Button = makeProductButton()
    lazy var bestOfferView = makeBestOfferView()
    lazy var enableTrialButton = makeEnableTrialButton()
    lazy var buyButton = makeBuyButton()
    lazy var infoView = makeInfoView()
    lazy var actionsView = makeActionsView()
    lazy var preloader = makePreloader()
    
    private lazy var buyAttrs = TextAttributes()
        .textColor(UIColor(integralRed: 45, green: 12, blue: 78))
        .font(Fonts.SFPro.bold(size: 19.scale))
    
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
extension PaygateView {
    func setup(buyTitle: String) {
        buyButton.setAttributedTitle(buyTitle.attributed(with: buyAttrs), for: .normal)
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 99, green: 111, blue: 180)
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 289.scale : 211.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 8.scale : 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 6.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 6.scale : 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            enableTrialButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            enableTrialButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            enableTrialButton.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 16.scale : 12.scale),
            enableTrialButton.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 66.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            product1Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            product1Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            product1Button.topAnchor.constraint(equalTo: enableTrialButton.bottomAnchor, constant: 16.scale),
            product1Button.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 70.scale : 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            product2Button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            product2Button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15.scale),
            product2Button.topAnchor.constraint(equalTo: product1Button.bottomAnchor, constant: 16.scale),
            product2Button.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 70.scale : 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            bestOfferView.centerYAnchor.constraint(equalTo: product1Button.topAnchor),
            bestOfferView.trailingAnchor.constraint(equalTo: product1Button.trailingAnchor, constant: -9.scale)
        ])
        
        NSLayoutConstraint.activate([
            buyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            buyButton.topAnchor.constraint(equalTo: product2Button.bottomAnchor, constant: ScreenSize.isIphone ? 16.scale : 12.scale),
            buyButton.heightAnchor.constraint(equalToConstant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoView.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            actionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -6.scale),
            actionsView.heightAnchor.constraint(equalToConstant: 22.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: buyButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: ScreenSize.isIphoneXFamily ? "Paygate.Image.X" : "Paygate.Image.8")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close.Black"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFPro.bold(size: 36.scale))
            .lineHeight(48.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(number: Int) -> PaygateInfoCell {
        let view = PaygateInfoCell(text: "Paygate.Info\(number)".localized)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEnableTrialButton() -> PaygateEnableTrialButton {
        let view = PaygateEnableTrialButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProductButton() -> PaygateProductButton {
        let view = PaygateProductButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBestOfferView() -> PaygateBestOfferView {
        let view = PaygateBestOfferView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuyButton() -> UIButton {
        let view = UIButton(type: .system)
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 20.scale
        view.layer.cornerCurve = .continuous
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)

        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
        blur.isUserInteractionEnabled = false
        blur.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blur, at: 0)
        NSLayoutConstraint.activate([
            blur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blur.topAnchor.constraint(equalTo: view.topAnchor),
            blur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let overlay = UIView()
        overlay.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        overlay.isUserInteractionEnabled = false
        overlay.translatesAutoresizingMaskIntoConstraints = false
        blur.contentView.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.leadingAnchor.constraint(equalTo: blur.contentView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: blur.contentView.trailingAnchor),
            overlay.topAnchor.constraint(equalTo: blur.contentView.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: blur.contentView.bottomAnchor)
        ])

        return view
    }
    
    func makeInfoView() -> PaygateInfoView {
        let view = PaygateInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeActionsView() -> PaygateActionsView {
        let view = PaygateActionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        view.color = UIColor.white
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

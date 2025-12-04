//
//  CSSMatchesView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CSSMatchesView: UIView {
    lazy var imageView = makeImageView()
    lazy var progressLabel = makeProgressLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    
    private lazy var viewModel = CSSMatchesViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didReceiveSecretSantaIdTrigger = PublishRelay<String>()
    
    private let finish: (String) -> Void
    
    private lazy var progressAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.Perandory.regular(size: 136.scale))
        .textAlignment(.center)
    
    init(finish: @escaping (String) -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        configure()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CSSMatchesView {
    func setup(secretSantaId: String) {
        didReceiveSecretSantaIdTrigger.accept(secretSantaId)
    }
}

// MARK: Private
private extension CSSMatchesView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
    
    func configure() {
        let output = viewModel.configure(input: CSSMatchesViewModel.Input(
            didReceiveSecretSantaId: didReceiveSecretSantaIdTrigger.asSignal()
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: CSSMatchesViewModel.Action) {
        switch action {
        case .nextStep(let secretSantaId):
            finish(secretSantaId)
        case .setProgress(let progress):
            let text = String(format: "%i%%", progress)
            progressLabel.attributedText = text.attributed(with: progressAttrs)
        }
    }
}

// MARK: Make constraints
private extension CSSMatchesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 19.scale),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 500 / 852)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSMatchesView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = UIImage(named: "CreateSecretSanta.Matches")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSMatches.Title".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(24.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSMatches.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

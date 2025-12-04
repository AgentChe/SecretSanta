//
//  CSSCreateView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit
import RxSwift

final class CSSCreateView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var textField = makeTextField()
    lazy var createButton = makeCreateButton()
    
    private lazy var viewModel = CSSCreateViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let finish: (String) -> Void
    
    init(finish: @escaping (String) -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CSSCreateView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
        
        textField.rx.text
            .map { ($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { $0.isEmpty }
            .bind(to: Binder(createButton) { base, isEmpty in
                base.alpha = isEmpty ? 0.5 : 1
                base.isUserInteractionEnabled = !isEmpty
            })
            .disposed(by: disposeBag)
        
        let hideKeyboardGesture = UITapGestureRecognizer()
        addGestureRecognizer(hideKeyboardGesture)
        hideKeyboardGesture.rx.event
            .mapToVoid()
            .bind(to: rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
    }
    
    func configure() {
        let didTapCreate = createButton.rx.tap
            .compactMap { [weak self] void -> String? in
                self?.textField.text
            }
            .asSignal(onErrorSignalWith: .never())
        
        let output = viewModel.configure(input: CSSCreateViewModel.Input(
            didTapCreate: didTapCreate
        ))
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: CSSCreateViewModel.Action) {
        switch action {
        case .nextStep(let secretSantaId):
            finish(secretSantaId)
        }
    }
}

// MARK: Make constraints
private extension CSSCreateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            textField.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            createButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -11.scale),
            createButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSCreateView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSCreate.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.5))
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSCreate.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField() -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 23.scale)
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = "CSSCreate.Placeholder".localized.attributed(with: placeholderAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCreateButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("CSSCreate.Create".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main200
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

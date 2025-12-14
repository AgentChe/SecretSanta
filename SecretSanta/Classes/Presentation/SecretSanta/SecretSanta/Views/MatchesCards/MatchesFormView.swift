//
//  MatchesFormView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 11.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MatchesFormView: UIView {
    lazy var cardsView = makeCardsView()
    lazy var nextButton = makeNextButton()
    lazy var shareButton = makeShareButton()
    lazy var tapToRevealButton = makeTapToRevealButton()
    
    private lazy var disposeBag = DisposeBag()
    
    private var hideWithPlaceholder: Bool
    
    init(hideWithPlaceholder: Bool) {
        self.hideWithPlaceholder = hideWithPlaceholder
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MatchesFormView {
    func removePlaceholderIfThereIsOne() {
        removePlaceholder(animated: false)
    }
    
    var didTapShare: Signal<MatchesElement> {
        shareButton.rx.tap
            .compactMap { [weak self] in self?.cardsView.currentElement }
            .asSignal(onErrorSignalWith: .never())
    }
}

// MARK: Private
private extension MatchesFormView {
    func initialize() {
        backgroundColor = UIColor.clear
        
        let nextSwipe = UISwipeGestureRecognizer()
        nextSwipe.direction = .left
        cardsView.addGestureRecognizer(nextSwipe)
        
        let previousSwipe = UISwipeGestureRecognizer()
        previousSwipe.direction = .right
        cardsView.addGestureRecognizer(previousSwipe)
        
        Signal
            .merge(
                nextButton.rx.tap.asSignal(),
                nextSwipe.rx.event.mapToVoid().asSignal(onErrorSignalWith: .never())
            )
            .filter { [weak self] void in self?.hideWithPlaceholder == false }
            .emit(to: Binder(cardsView) { base, void in
                base.switchToNext()
            })
            .disposed(by: disposeBag)
        
        previousSwipe.rx.event.mapToVoid()
            .filter { [weak self] void in self?.hideWithPlaceholder == false }
            .asSignal(onErrorSignalWith: .never())
            .emit(to: Binder(cardsView) { base, void in
                base.switchToPrevious()
            })
            .disposed(by: disposeBag)
        
        tapToRevealButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.removePlaceholder(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func removePlaceholder(animated: Bool) {
        cardsView.reveal(animated: animated) { [weak self] in
            self?.hideWithPlaceholder = false
            self?.updateUI()
        }
    }
    
    func updateUI() {
        nextButton.isHidden = hideWithPlaceholder
        shareButton.isHidden = hideWithPlaceholder
        tapToRevealButton.isHidden = !hideWithPlaceholder
    }
}

// MARK: Make constraints
private extension MatchesFormView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            cardsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardsView.topAnchor.constraint(equalTo: topAnchor),
            cardsView.heightAnchor.constraint(equalToConstant: MatchesCardsView.Constants.cardHeight)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            nextButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            shareButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
        
        NSLayoutConstraint.activate([
            tapToRevealButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tapToRevealButton.topAnchor.constraint(equalTo: cardsView.bottomAnchor, constant: 53.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MatchesFormView {
    func makeCardsView() -> MatchesCardsView {
        let view = MatchesCardsView(hideWithPlaceholder: hideWithPlaceholder)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Next".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main100
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
    
    func makeShareButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = UIButton()
        view.backgroundColor = UIColor.clear
        view.setAttributedTitle("SecretSanta.Share".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTapToRevealButton() -> TapAreaButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = TapAreaButton()
        view.setAttributedTitle("SecretSanta.TapToReveal".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

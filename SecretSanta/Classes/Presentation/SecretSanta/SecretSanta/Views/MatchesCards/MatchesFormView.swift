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
    
    private lazy var disposeBag = DisposeBag()
    
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
            .emit(to: Binder(cardsView) { base, void in
                base.switchToNext()
            })
            .disposed(by: disposeBag)
        
        previousSwipe.rx.event.mapToVoid()
            .asSignal(onErrorSignalWith: .never())
            .emit(to: Binder(cardsView) { base, void in
                base.switchToPrevious()
            })
            .disposed(by: disposeBag)
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
    }
}

// MARK: Lazy initialization
private extension MatchesFormView {
    func makeCardsView() -> MatchesCardsView {
        let view = MatchesCardsView()
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
}

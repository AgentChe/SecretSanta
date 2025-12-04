//
//  CSSExcludePairsView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 02.12.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CSSExcludePairsView: UIView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tableView = makeTableView()
    lazy var pairsView = makePairsView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var viewModel = CSSExcludePairsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let finish: (String) -> Void
    
    private lazy var didReceiveSecretSantaIdTrigger = PublishRelay<String>()
    
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
extension CSSExcludePairsView {
    func setup(secretSantaId: String) {
        didReceiveSecretSantaIdTrigger.accept(secretSantaId)
    }
}

// MARK: Private
private extension CSSExcludePairsView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
    
    func configure() {
        let output = viewModel.configure(input: CSSExcludePairsViewModel.Input(
            didReceiveSecretSantaId: didReceiveSecretSantaIdTrigger.asSignal(),
            didSelectParticipient: tableView.didSelect,
            didTapDeletePair: pairsView.collectionView.didTapDeletePair,
            didTapContinue: continueButton.rx.tap.asSignal()
        ))
        
        output.elements
            .drive(Binder(tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.pairsElements
            .drive(Binder(self) { base, pairsElements in
                base.pairsView.collectionView.setup(elements: pairsElements)
                base.pairsView.isHidden = pairsElements.isEmpty
                
                base.tableView.contentInset.bottom = pairsElements.isEmpty ? 24.scale : 161.scale
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: CSSExcludePairsViewModel.Action) {
        switch action {
        case .nextStep(let secretSantaId):
            finish(secretSantaId)
        case .matchingError:
            let alert = UIAlertController(title: nil, message: "CSSExcludePairs.MatchingError".localized, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK".localized, style: .cancel)
            alert.addAction(okAction)
            
            vc?.present(alert, animated: true)
        }
    }
}

// MARK: Make constraints
private extension CSSExcludePairsView {
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
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 2.scale),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            pairsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pairsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pairsView.bottomAnchor.constraint(equalTo: continueButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSExcludePairsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSExcludePairs.Title".localized.attributed(with: attrs)
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
        view.attributedText = "CSSExcludePairs.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CSSExcludePairsTableView {
        let view = CSSExcludePairsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePairsView() -> ExcludePairsView {
        let view = ExcludePairsView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
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

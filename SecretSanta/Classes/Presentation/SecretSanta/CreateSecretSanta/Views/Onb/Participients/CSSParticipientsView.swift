//
//  CSSParticipientsView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class CSSParticipientsView: UIView {
    weak var vc: UIViewController?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var tableView = makeTableView()
    lazy var addButton = makeAddButton()
    lazy var continueButton = makeContinueButton()
    
    private lazy var viewModel = CSSParticipientsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let finish: (String) -> Void
    
    private lazy var didReceiveSecretSantaIdTrigger = PublishRelay<String>()
    private lazy var didDeletionConfirmedTrigger = PublishRelay<Participient>()
    
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
extension CSSParticipientsView {
    func setup(secretSantaId: String) {
        didReceiveSecretSantaIdTrigger.accept(secretSantaId)
    }
}

// MARK: Private
private extension CSSParticipientsView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
    
    func configure() {
        let didTapAddParticipient: Signal<Void> = Signal
            .merge(
                tableView.didTapAdd,
                addButton.rx.tap.asSignal()
            )
        
        let output = viewModel.configure(input: CSSParticipientsViewModel.Input(
            didReceiveSecretSantaId: didReceiveSecretSantaIdTrigger.asSignal(),
            didTapAddParticipient: didTapAddParticipient,
            didTapEditParticipient: tableView.didTapEdit,
            didTapDeleteParticipient: tableView.didTapDelete,
            didDeletionConfirmed: didDeletionConfirmedTrigger.asSignal(),
            didTapContinue: continueButton.rx.tap.asSignal(onErrorSignalWith: .never())
        ))
        
        output.elements
            .drive(Binder(tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.canSave
            .drive(Binder(continueButton) { base, canSave in
                base.alpha = canSave ? 1 : 0.5
                base.isUserInteractionEnabled = canSave
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    func action(_ action: CSSParticipientsViewModel.Action) {
        switch action {
        case .addParticipient(let secretSantaId):
            let vc = ParticipientViewController.make(secretSantaId: secretSantaId)
            self.vc?.present(vc, animated: true)
        case .editParticipient(let secretSantaId, let participient):
            let vc = ParticipientViewController.make(secretSantaId: secretSantaId, participient: participient)
            self.vc?.present(vc, animated: true)
        case .requestConfirmDelete(let participient):
            requestConfirmDelete(participient: participient)
        case .nextStep(let secretSantaId):
            finish(secretSantaId)
        }
    }
    
    func requestConfirmDelete(participient: Participient) {
        let message = String(format: "CSSParticipients.ConfirmDelete".localized, participient.name)
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
            self?.didDeletionConfirmedTrigger.accept(participient)
        }
        alert.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        alert.addAction(cancelAction)
        
        vc?.present(alert, animated: true)
    }
}

// MARK: Make constraints
private extension CSSParticipientsView {
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
            addButton.widthAnchor.constraint(equalToConstant: 58.scale),
            addButton.heightAnchor.constraint(equalToConstant: 60.scale),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            addButton.centerYAnchor.constraint(equalTo: continueButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 10.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSParticipientsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CSSParticipients.Title".localized.attributed(with: attrs)
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
        view.attributedText = "CSSParticipients.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> CSSParticipientsTableView {
        let view = CSSParticipientsTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAddButton() -> CSSParticipientsAddButton {
        let view = CSSParticipientsAddButton()
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

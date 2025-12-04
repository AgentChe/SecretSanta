//
//  ParticipientViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 01.12.2025.
//

import UIKit
import RxSwift

final class ParticipientViewController: UIViewController {
    private let mainView: ParticipientView
    
    private let viewModel: ParticipientViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(secretSantaId: String, participient: Participient?) {
        mainView = ParticipientView(participient: participient)
        viewModel = ParticipientViewModel(secretSantaId: secretSantaId, participient: participient)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hideKeyboardGesture = UITapGestureRecognizer()
        mainView.addGestureRecognizer(hideKeyboardGesture)
        hideKeyboardGesture.rx.event
            .mapToVoid()
            .bind(to: mainView.rx.hideKeyboardObserver)
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: ParticipientViewModel.Input(
            didEnterName: mainView.nameTextField.rx.text
                .asSignal(onErrorSignalWith: .never()),
            didEnterEmail: mainView.emailTextField.rx.text
                .asSignal(onErrorSignalWith: .never()),
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapSave: mainView.saveButton.rx.tap.asSignal()
        ))
        
        output.canSave
            .drive(Binder(mainView.saveButton) { base, canSave in
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
}

// MARK: Public
extension ParticipientViewController {
    static func make(secretSantaId: String, participient: Participient? = nil) -> ParticipientViewController {
        ParticipientViewController(secretSantaId: secretSantaId, participient: participient)
    }
}

// MARK: Private
private extension ParticipientViewController {
    func action(_ action: ParticipientViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        }
    }
}

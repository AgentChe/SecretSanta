//
//  SecretSantaViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 08.12.2025.
//

import UIKit
import RxSwift

final class SecretSantaViewController: UIViewController {
    enum CardsInitialState {
        case hidden, open
    }
    
    private let mainView: SecretSantaView
    
    private let viewModel: SecretSantaViewModel
    
    private lazy var disposeBag = DisposeBag()
    
    private init(secretSantaId: String, cardsInitialState: CardsInitialState) {
        mainView = SecretSantaView(cardsInitialState: cardsInitialState)
        viewModel = SecretSantaViewModel(secretSantaId: secretSantaId)
        
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
        
        let output = viewModel.configure(input: SecretSantaViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapListForm: mainView.listFormButton.rx.tap.asSignal(),
            didSelectElementInList: mainView.tableView.didSelect,
            didTapShare: mainView.cardsView.didTapShare
        ))
        
        output.name
            .drive(Binder(mainView) { base, name in
                base.setup(name: name)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.listForm
            .drive(Binder(mainView) { base, listForm in
                base.setup(listForm: listForm)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView) { base, elements in
                base.tableView.setup(elements: elements)
                base.cardsView.cardsView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SecretSantaViewController {
    static func make(secretSantaId: String, cardsInitialState: CardsInitialState) -> SecretSantaViewController {
        let vc = SecretSantaViewController(secretSantaId: secretSantaId, cardsInitialState: cardsInitialState)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension SecretSantaViewController {
    func action(_ action: SecretSantaViewModel.Action) {
        switch action {
        case .close:
            dismiss(animated: true)
        case .targetCard(let id):
            mainView.cardsView.removePlaceholderIfThereIsOne()
            mainView.cardsView.cardsView.select(elementId: id)
        case .openPaygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        case .share(let element):
            guard let pdfUrl = MailGenerate.pdfURL(participient: element.participientTwo) else { return }

            let vc = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
            
            if let pop = vc.popoverPresentationController {
                pop.sourceView = mainView
                pop.sourceRect = mainView.bounds
            }

            present(vc, animated: true)
        }
    }
}

//
//  SecretSantasViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class SecretSantasViewController: UIViewController {
    private lazy var mainView = SecretSantasView()
    
    private lazy var viewModel = SecretSantasViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SecretSantasViewModel.Input(
            didTapCreateSecretSanta: Signal.merge(
                mainView.emptyView.createButton.rx.tap.asSignal(),
                mainView.createNewEventButton.rx.tap.asSignal()
            ),
            didSelectElement: mainView.tableView.didSelectElement
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.isEmpty
            .drive(Binder(mainView) { base, isEmpty in
                base.emptyView.isHidden = !isEmpty
                base.createNewEventButton.isHidden = isEmpty
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension SecretSantasViewController {
    static func make() -> SecretSantasViewController {
        let vc = SecretSantasViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SecretSantasViewController {
    func action(_ action: SecretSantasViewModel.Action) {
        switch action {
        case .createSecretSanta:
            break // TODO: open screen
        case .editSecretSanta(let id):
            break // TODO: open screen
        case .openSecretSanta(let id):
            break // TODO: open screen
        }
    }
}

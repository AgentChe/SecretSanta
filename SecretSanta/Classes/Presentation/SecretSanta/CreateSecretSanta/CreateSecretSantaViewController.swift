//
//  CreateSecretSantaViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit
import RxSwift

final class CreateSecretSantaViewController: UIViewController {
    private let mainView: CreateSecretSantaView
    
    private lazy var disposeBag = DisposeBag()
    
    private init(secretSantaId: String?) {
        mainView = CreateSecretSantaView(secretSantaId: secretSantaId)
        
        super.init(nibName: nil, bundle: nil)
        
        mainView.vc = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.navigationView.closeButton
            .rx.tap.asSignal()
            .emit(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mainView.finish = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}

// MARK: Public
extension CreateSecretSantaViewController {
    static func make(secretSantaId: String? = nil) -> CreateSecretSantaViewController {
        let vc = CreateSecretSantaViewController(secretSantaId: secretSantaId)
        vc.navigationItem.backButtonTitle = " "
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

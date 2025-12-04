//
//  CSSCreateViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import RxSwift
import RxCocoa

final class CSSCreateViewModel {
    enum Action {
        case nextStep(String)
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
}

// MARK: Public
extension CSSCreateViewModel {
    struct Input {
        let didTapCreate: Signal<String>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didTapCreate: input.didTapCreate)
        )
    }
}

// MARK: Private
private extension CSSCreateViewModel {
    func makeAction(didTapCreate: Signal<String>) -> Driver<Action> {
        didTapCreate
            .flatMapLatest { [weak self] name -> Driver<Action> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .createSecretSanta(name: name)
                    .map { secretSanta -> Action in
                        Action.nextStep(secretSanta.id)
                    }
                    .asDriver(onErrorDriveWith: .never())
            }
    }
}

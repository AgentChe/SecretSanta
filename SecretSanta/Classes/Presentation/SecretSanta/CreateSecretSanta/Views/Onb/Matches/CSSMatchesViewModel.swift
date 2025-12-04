//
//  CSSMatchesViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

import RxSwift
import RxCocoa

final class CSSMatchesViewModel {
    enum Action {
        case setProgress(Int)
        case nextStep(String)
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
}

// MARK: Public
extension CSSMatchesViewModel {
    struct Input {
        let didReceiveSecretSantaId: Signal<String>
    }
    
    struct Output {
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            action: makeAction(didReceiveSecretSantaId: input.didReceiveSecretSantaId)
        )
    }
}

// MARK: Private
private extension CSSMatchesViewModel {
    // TODO: запрос на сервер для рассылки писем на почту
    func makeAction(didReceiveSecretSantaId: Signal<String>) -> Driver<Action> {
        didReceiveSecretSantaId
            .asObservable()
            .flatMapLatest { secretSantaId -> Observable<Action> in
                let totalPercent = 100
                let interval = RxTimeInterval.milliseconds(40) 
                
                let progress = Observable<Int>
                    .interval(interval, scheduler: MainScheduler.instance)
                    .map { tick in min(Int(tick) + 1, totalPercent) }
                    .take(totalPercent)
                    .map { percent in Action.setProgress(percent) }
                
                let finish = Observable.just(Action.nextStep(secretSantaId))
                
                return Observable.concat(progress, finish)
            }
            .asDriver(onErrorDriveWith: .never())
    }
}

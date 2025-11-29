//
//  SecretSantasViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import RxSwift
import RxCocoa

final class SecretSantasViewModel {
    enum Action {
        case createSecretSanta
        case editSecretSanta(String)
        case openSecretSanta(String)
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
}

// MARK: Public
extension SecretSantasViewModel {
    struct Input {
        let didTapCreateSecretSanta: Signal<Void>
        let didSelectElement: Signal<SecretSantasTableElement>
    }
    
    struct Output {
        let elements: Driver<[SecretSantasTableElement]>
        let isEmpty: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let elements = makeElements(
            secretSantas: makeSecretSantas(),
            participients: makeParticipients(),
            checkinCompleted: makeCheckinCompleted()
        )
        
        return Output(
            elements: elements,
            isEmpty: elements.map { $0.isEmpty },
            action: makeAction(
                didTapCreateSecretSanta: input.didTapCreateSecretSanta,
                didSelectElement: input.didSelectElement
            )
        )
    }
}

// MARK: Private
private extension SecretSantasViewModel {
    func makeElements(
        secretSantas: Driver<[SecretSanta]>,
        participients: Driver<[SecretSantaParticipientsCount]>,
        checkinCompleted: Driver<[SecretSantaCheckinCompleted]>
    ) -> Driver<[SecretSantasTableElement]> {
        Driver
            .combineLatest(secretSantas, participients, checkinCompleted)
            .map { secretSantas, participients, checkinCompleted -> [SecretSantasTableElement] in
                secretSantas.map { secretSanta -> SecretSantasTableElement in
                    SecretSantasTableElement(
                        secretSantaId: secretSanta.id,
                        name: secretSanta.name,
                        participientsCount: participients.first(where: { $0.secretSantaId == secretSanta.id })?.count,
                        isDraft: !(checkinCompleted.first(where: { $0.secretSantaId == secretSanta.id })?.completed ?? false)
                    )
                }
            }
    }
    
    func makeSecretSantas() -> Driver<[SecretSanta]> {
        let initial = secretSantaManager
            .fetchSecretSantas()
            .asDriver(onErrorJustReturn: [])
        
        return initial
            .flatMapLatest { initial -> Driver<[SecretSanta]> in
                enum Action {
                    case initial([SecretSanta])
                    case create(SecretSanta)
                }
                
                let action = Driver
                    .merge(
                        SecretSantaMediator.shared.didCreatedSecretSanta
                            .map { Action.create($0) }
                            .asDriver(onErrorDriveWith: .never())
                    )
                    .startWith(.initial(initial))
                
                return action
                    .scan([]) { current, action -> [SecretSanta] in
                        switch action {
                        case .initial(let secretSantas):
                            return secretSantas
                        case .create(let secretSanta):
                            return current + [secretSanta]
                        }
                    }
            }
            .map { _ -> [SecretSanta] in
                // TODO: delete
                [
                    SecretSanta(id: "1", name: "Secret Santa")
                ]
            }
    }
    
    func makeParticipients() -> Driver<[SecretSantaParticipientsCount]> {
        let trigger = Signal
            .merge(
                SecretSantaMediator.shared
                    .didCreatedParticipient
                    .map { _ in Void() },
                
                SecretSantaMediator.shared
                    .didDeletedParticipient
                    .map { _ in Void() }
            )
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[SecretSantaParticipientsCount]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchSecretSantaParticipientsCount()
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeCheckinCompleted() -> Driver<[SecretSantaCheckinCompleted]> {
        let trigger = SecretSantaMediator.shared
            .didCreatedMatches
            .map { _ in Void() }
            .startWith(())
            .asDriver(onErrorDriveWith: .never())
        
        return trigger
            .flatMapLatest { [weak self] void -> Driver<[SecretSantaCheckinCompleted]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchSecretSantasCheckinCompletion()
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeAction(
        didTapCreateSecretSanta: Signal<Void>,
        didSelectElement: Signal<SecretSantasTableElement>
    ) -> Driver<Action> {
        let createSecretSanta = didTapCreateSecretSanta
            .map { Action.createSecretSanta }
            .asDriver(onErrorDriveWith: .never())
        
        let select = didSelectElement
            .map { $0.isDraft ? Action.editSecretSanta($0.secretSantaId) : Action.openSecretSanta($0.secretSantaId) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(createSecretSanta, select)
    }
}

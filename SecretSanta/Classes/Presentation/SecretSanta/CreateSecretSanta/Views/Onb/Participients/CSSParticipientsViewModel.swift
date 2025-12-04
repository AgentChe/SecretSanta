//
//  CSSParticipientsViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 30.11.2025.
//

import RxSwift
import RxCocoa

final class CSSParticipientsViewModel {
    enum Action {
        case addParticipient(String)
        case editParticipient(String, Participient)
        case requestConfirmDelete(Participient)
        case nextStep(String)
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
}

// MARK: Public
extension CSSParticipientsViewModel {
    struct Input {
        let didReceiveSecretSantaId: Signal<String>
        let didTapAddParticipient: Signal<Void>
        let didTapEditParticipient: Signal<Participient>
        let didTapDeleteParticipient: Signal<Participient>
        let didDeletionConfirmed: Signal<Participient>
        let didTapContinue: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CSSParticipientsTableElement]>
        let canSave: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let participients = makeParticipients(
            didReceiveSecretSantaId: input.didReceiveSecretSantaId,
            didDeletionConfirmed: input.didDeletionConfirmed
        )
        
        return Output(
            elements: makeElements(participients: participients),
            canSave: participients.map { $0.count >= 3 },
            action: makeAction(
                didTapAddParticipient: input.didTapAddParticipient,
                didTapEditParticipient: input.didTapEditParticipient,
                didReceiveSecretSantaId: input.didReceiveSecretSantaId,
                didTapDeleteParticipient: input.didTapDeleteParticipient,
                didTapContinue: input.didTapContinue
            )
        )
    }
}

// MARK: Private
private extension CSSParticipientsViewModel {
    func makeElements(participients: Driver<[Participient]>) -> Driver<[CSSParticipientsTableElement]> {
        participients
            .map { participients -> [CSSParticipientsTableElement] in
                switch participients.count {
                case 0:
                    return (1...3).map { .dummy($0) }
                case 1:
                    return (1...2).map { .dummy($0) } + participients.map { .participient($0) }
                case 2:
                    return [.dummy(1)] + participients.map { .participient($0) }
                default:
                    return participients.map { .participient($0) }
                }
            }
    }
    
    func makeParticipients(
        didReceiveSecretSantaId: Signal<String>,
        didDeletionConfirmed: Signal<Participient>
    ) -> Driver<[Participient]> {
        didReceiveSecretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<[Participient]> in
                guard let self else { return .never() }
                
                let initial = secretSantaManager
                    .fetchParticipents(secretSantaId: secretSantaId)
                    .asDriver(onErrorJustReturn: [])
                
                return initial
                    .flatMapLatest { initial -> Driver<[Participient]> in
                        enum Action {
                            case initial([Participient])
                            case created(Participient)
                            case edited(Participient)
                            case deleted(String)
                        }
                           
                        let action = Driver
                            .merge(
                                SecretSantaMediator.shared
                                    .didCreatedParticipient
                                    .asDriver(onErrorDriveWith: .never())
                                    .map { Action.created($0) },
                                
                                SecretSantaMediator.shared
                                    .didEditedParticipient
                                    .asDriver(onErrorDriveWith: .never())
                                    .map { Action.edited($0) },
                                
                                didDeletionConfirmed
                                    .flatMapLatest { [weak self] participient -> Driver<Action> in
                                        guard let self else { return .never() }
                                        
                                        return secretSantaManager
                                            .deleteParticipient(id: participient.id)
                                            .asDriver(onErrorDriveWith: .never())
                                            .map { Action.deleted($0) }
                                    }
                            )
                            .startWith(.initial(initial))
                        
                        return action
                            .scan(initial) { current, action -> [Participient] in
                                switch action {
                                case .initial(let participients):
                                    return participients
                                case .created(let participient):
                                    return current + [participient]
                                case .edited(let participient):
                                    var result = current
                                    if let index = result.firstIndex(where: { $0.id == participient.id }) {
                                        result[index] =  participient
                                    }
                                    return result
                                case .deleted(let id):
                                    var result = current
                                    result.removeAll(where: { $0.id == id })
                                    return result
                                }
                            }
                    }
            }
    }
    
    func makeAction(
        didTapAddParticipient: Signal<Void>,
        didTapEditParticipient: Signal<Participient>,
        didReceiveSecretSantaId: Signal<String>,
        didTapDeleteParticipient: Signal<Participient>,
        didTapContinue: Signal<Void>
    ) -> Driver<Action> {
        let add = didTapAddParticipient
            .withLatestFrom(didReceiveSecretSantaId)
            .map { Action.addParticipient($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let edit = didTapEditParticipient
            .withLatestFrom(didReceiveSecretSantaId) { ($0, $1) }
            .map { Action.editParticipient($1, $0) }
            .asDriver(onErrorDriveWith: .never())
        
        let requestConfirmDelete = didTapDeleteParticipient
            .map { Action.requestConfirmDelete($0) }
            .asDriver(onErrorDriveWith: .never())
        
        let nextStep = didTapContinue
            .withLatestFrom(didReceiveSecretSantaId)
            .map { Action.nextStep($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(add, edit, requestConfirmDelete, nextStep)
    }
}

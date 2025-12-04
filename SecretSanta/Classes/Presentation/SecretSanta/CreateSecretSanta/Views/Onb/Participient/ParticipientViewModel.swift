//
//  ParticipientViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 01.12.2025.
//

import RxSwift
import RxCocoa

final class ParticipientViewModel {
    enum Action {
        case close
    }
    
    fileprivate enum Mode {
        case create
        case edit(Participient)
    }
    
    private let secretSantaId: Driver<String>
    private let mode: Driver<Mode>
    
    private lazy var secretSantaManager = SecretSantaManager()
    
    init(secretSantaId: String, participient: Participient?) {
        self.secretSantaId = BehaviorRelay(value: secretSantaId).asDriver()
        
        let mode: Mode = {
            if let participient {
                return Mode.edit(participient)
            }
            return Mode.create
        }()
        self.mode = BehaviorRelay(value: mode).asDriver()
    }
}

// MARK: Public
extension ParticipientViewModel {
    struct Input {
        let didEnterName: Signal<String?>
        let didEnterEmail: Signal<String?>
        let didTapClose: Signal<Void>
        let didTapSave: Signal<Void>
    }
    
    struct Output {
        let canSave: Driver<Bool>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let name: Driver<String?> = Driver
            .merge(
                input.didEnterName
                    .asDriver(onErrorDriveWith: .never()),
                
                mode
                    .map { mode -> String? in
                        guard case .edit(let participient) = mode else { return nil }
                        return participient.name
                    }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        let email: Driver<String?> = Driver
            .merge(
                input.didEnterEmail
                    .asDriver(onErrorDriveWith: .never()),
                
                mode
                    .map { mode -> String? in
                        guard case .edit(let participient) = mode else { return nil }
                        return participient.email
                    }
                    .asDriver(onErrorDriveWith: .never())
            )
        
        return Output(
            canSave: makeCanSave(
                name: name,
                email: email
            ),
            action: makeAction(
                didTapClose: input.didTapClose,
                didTapSave: input.didTapSave,
                name: name,
                email: email,
                secretSantaId: secretSantaId,
                mode: mode
            )
        )
    }
}

// MARK: Private
private extension ParticipientViewModel {
    func makeCanSave(
        name: Driver<String?>,
        email: Driver<String?>
    ) -> Driver<Bool> {
        let validName = name
            .map { name -> Bool in
                guard let name else { return false }
                return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        
        let validEmail = email
            .map { email -> Bool in
                guard let email else { return false }
                
                let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else { return false }
                
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
                return predicate.evaluate(with: trimmed)
            }
        
        return Driver
            .combineLatest(validName, validEmail) { $0 && $1 }
    }
    
    func makeAction(
        didTapClose: Signal<Void>,
        didTapSave: Signal<Void>,
        name: Driver<String?>,
        email: Driver<String?>,
        secretSantaId: Driver<String>,
        mode: Driver<Mode>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let pairs = Driver
            .combineLatest(
                name.asDriver(onErrorDriveWith: .never()),
                email.asDriver(onErrorDriveWith: .never())
            )
        
        let save = didTapSave
            .withLatestFrom(pairs)
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(secretSantaId) { ($0.0, $0.1, $1) }
            .withLatestFrom(mode) { ($0.0, $0.1, $0.2, $1) }
            .flatMapLatest { [weak self] name, email, secretSantaId, mode -> Driver<Action> in
                guard let self, let name, !name.isEmpty, let email, !email.isEmpty else { return .never() }
                
                switch mode {
                case .create:
                    return secretSantaManager
                        .createParticipient(
                            secretSantaId: secretSantaId,
                            name: name,
                            email: email
                        )
                        .asDriver(onErrorDriveWith: .never())
                        .map { _ in Action.close }
                case .edit(let participient):
                    return secretSantaManager
                        .editParticipient(
                            id: participient.id,
                            secretSantaId: secretSantaId,
                            name: name,
                            email: email
                        )
                        .asDriver(onErrorDriveWith: .never())
                        .map { _ in Action.close }
                }
            }
        
        return Driver
            .merge(close, save)
    }
}

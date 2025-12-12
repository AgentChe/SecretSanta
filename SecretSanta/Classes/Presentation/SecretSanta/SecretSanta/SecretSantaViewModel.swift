//
//  SecretSantaViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 08.12.2025.
//

import RxSwift
import RxCocoa

final class SecretSantaViewModel {
    enum CardsInitialState {
        case hidden, open
    }
    
    enum Action {
        case close
        case targetCard(String)
        case openPaygate
        case share(MatchesElement)
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
    
    private let secretSantaId: Driver<String>
    private let cardsInitialState: Driver<CardsInitialState>
    
    init(secretSantaId: String, cardsInitialState: CardsInitialState) {
        self.secretSantaId = BehaviorRelay(value: secretSantaId).asDriver()
        self.cardsInitialState = BehaviorRelay(value: cardsInitialState).asDriver()
    }
}

// MARK: Public
extension SecretSantaViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapListForm: Signal<Void>
        let didSelectElementInList: Signal<MatchesElement>
        let didTapShare: Signal<MatchesElement>
    }
    
    struct Output {
        let name: Driver<String>
        let action: Driver<Action>
        let listForm: Driver<SecretSantaView.ListForm>
        let elements: Driver<[MatchesElement]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            name: makeName(secretSantaId: secretSantaId),
            action: makeAction(
                didTapClose: input.didTapClose,
                didSelectElementInList: input.didSelectElementInList,
                didTapShare: input.didTapShare
            ),
            listForm: makeListForm(
                didTapListForm: input.didTapListForm,
                didSelectElementInList: input.didSelectElementInList
            ),
            elements: makeElements(
                secretSantaId: secretSantaId,
                participiens: makeParticipients()
            )
        )
    }
}

// MARK: Private
private extension SecretSantaViewModel {
    func makeAction(
        didTapClose: Signal<Void>,
        didSelectElementInList: Signal<MatchesElement>,
        didTapShare: Signal<MatchesElement>
    ) -> Driver<Action> {
        let close = didTapClose
            .map { Action.close }
            .asDriver(onErrorDriveWith: .never())
        
        let targetCard = didSelectElementInList
            .map { Action.targetCard($0.id) }
            .asDriver(onErrorDriveWith: .never())
        
        let share = didTapShare
            .map { element -> Action in
                SessionManager().hasActiveSubscriptions() ? .share(element) : .openPaygate
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(close, targetCard, share)
    }
    
    func makeName(secretSantaId: Driver<String>) -> Driver<String> {
        secretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<String> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchSecretSanta(id: secretSantaId)
                    .asDriver(onErrorJustReturn: nil)
                    .map { $0?.name ?? "" }
            }
    }
    
    func makeListForm(
        didTapListForm: Signal<Void>,
        didSelectElementInList: Signal<MatchesElement>
    ) -> Driver<SecretSantaView.ListForm> {
        enum Event {
            case toggle
            case selectElement
        }

        let events = Signal.merge(
            didTapListForm.map { Event.toggle },
            didSelectElementInList.map { _ in Event.selectElement }
        )

        return events
            .scan(SecretSantaView.ListForm.cards) { current, event -> SecretSantaView.ListForm in
                switch event {
                case .toggle:
                    switch current {
                    case .list:
                        return .cards
                    case .cards:
                        return .list
                    }
                case .selectElement:
                    return .cards
                }
            }
            .startWith(.cards)
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeElements(
        secretSantaId: Driver<String>,
        participiens: Driver<[Participient]>
    ) -> Driver<[MatchesElement]> {
        let matches = secretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<[Match]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchMatches(secretSantaId: secretSantaId)
                    .asDriver(onErrorJustReturn: [])
            }
        
        return Driver
            .combineLatest(matches, participiens)
            .map { matches, participiens -> [MatchesElement] in
                matches
                    .compactMap { match -> MatchesElement? in
                        let p1 = participiens.first(where: { $0.id == match.participientOneId })
                        let p2 = participiens.first(where: { $0.id == match.participientTwoId })
                        
                        guard let p1, let p2 else { return nil }
                        
                        return MatchesElement(participientOne: p1, participientTwo: p2)
                    }
            }
    }
    
    func makeParticipients() -> Driver<[Participient]> {
        secretSantaManager
            .fetchParticipents()
            .asDriver(onErrorJustReturn: [])
    }
}

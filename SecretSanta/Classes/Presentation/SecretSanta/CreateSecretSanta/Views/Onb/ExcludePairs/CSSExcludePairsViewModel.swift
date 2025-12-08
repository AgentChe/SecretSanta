//
//  CSSExcludePairsViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 02.12.2025.
//

import RxSwift
import RxCocoa

final class CSSExcludePairsViewModel {
    enum Action {
        case nextStep(String)
        case matchingError
        case openPaygate
    }
    
    private lazy var secretSantaManager = SecretSantaManager()
}

// MARK: Public
extension CSSExcludePairsViewModel {
    struct Input {
        let didReceiveSecretSantaId: Signal<String>
        let didSelectParticipient: Signal<Participient>
        let didTapDeletePair: Signal<ExcludePairsCollectionPairElement>
        let didTapContinue: Signal<Void>
    }
    
    struct Output {
        let elements: Driver<[CSSExcludePairsTableElement]>
        let pairsElements: Driver<[ExcludePairsCollectionElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        let participients = makeParticipients(didReceiveSecretSantaId: input.didReceiveSecretSantaId)
        let pairsElements = makePairsElements(
            didSelectParticipient: input.didSelectParticipient,
            didTapDeletePair: input.didTapDeletePair
        )
        
        return Output(
            elements: makeElements(
                participients: participients,
                pairsElements: pairsElements
            ),
            pairsElements: pairsElements,
            action: makeAction(
                didSelectParticipient: input.didSelectParticipient,
                didTapContinue: input.didTapContinue,
                didReceiveSecretSantaId: input.didReceiveSecretSantaId,
                participients: participients,
                pairsElements: pairsElements
            )
        )
    }
}

// MARK: Private
private extension CSSExcludePairsViewModel {
    func makeParticipients(didReceiveSecretSantaId: Signal<String>) -> Driver<[Participient]> {
        didReceiveSecretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<[Participient]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchParticipents(secretSantaId: secretSantaId)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeElements(
        participients: Driver<[Participient]>,
        pairsElements: Driver<[ExcludePairsCollectionElement]>
    ) -> Driver<[CSSExcludePairsTableElement]> {
        Driver
            .combineLatest(participients, pairsElements)
            .map { participients, pairs -> [CSSExcludePairsTableElement] in
                participients.map { participient -> CSSExcludePairsTableElement in
                    CSSExcludePairsTableElement(
                        participient: participient,
                        selected: pairs.contains(where: { $0.contains(participientId: participient.id) })
                    )
                }
            }
    }
    
    func makePairsElements(
        didSelectParticipient: Signal<Participient>,
        didTapDeletePair: Signal<ExcludePairsCollectionPairElement>
    ) -> Driver<[ExcludePairsCollectionElement]> {
        enum Event {
            case select(Participient)
            case delete(ExcludePairsCollectionPairElement)
        }
        
        let events = Signal.merge(
            didSelectParticipient.filter { _ in SessionManager().hasActiveSubscriptions() }.map(Event.select),
            didTapDeletePair.map(Event.delete)
        )
        
        return events
            .scan([]) { current, event -> [ExcludePairsCollectionElement] in
                var result = current
                
                switch event {
                case .select(let participient):
                    if let index = result.firstIndex(where: { element in
                        if case .goingToSelect(let p) = element {
                            return p.id == participient.id
                        }
                        return false
                    }) {
                        result.remove(at: index)
                        return result
                    }
                    
                    if let index = result.firstIndex(where: { element in
                        if case .goingToSelect = element { return true }
                        return false
                    }) {
                        guard case .goingToSelect(let first) = result[index] else {
                            return result
                        }
                        
                        let pair = ExcludePairsCollectionPairElement(
                            id: UUID().uuidString,
                            participientOne: first,
                            participientTwo: participient
                        )
                        
                        result[index] = .excludePair(pair)
                        return result
                    }
                    
                    result.append(.goingToSelect(participient))
                    return result
                case .delete(let pairToDelete):
                    result.removeAll(where: { element in
                        if case .excludePair(let pair) = element {
                            return pair.id == pairToDelete.id
                        }
                        return false
                    })
                    return result
                }
            }
            .startWith([])
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeAction(
        didSelectParticipient: Signal<Participient>,
        didTapContinue: Signal<Void>,
        didReceiveSecretSantaId: Signal<String>,
        participients: Driver<[Participient]>,
        pairsElements: Driver<[ExcludePairsCollectionElement]>
    ) -> Driver<Action> {
        let openPaygate = didSelectParticipient
            .filter { _ in !SessionManager().hasActiveSubscriptions() }
            .map { _ in Action.openPaygate }
            .asDriver(onErrorDriveWith: .never())
        
        let nextStep = didTapContinue
            .withLatestFrom(didReceiveSecretSantaId)
            .asDriver(onErrorDriveWith: .never())
            .withLatestFrom(participients) { ($0, $1) }
            .withLatestFrom(pairsElements) { ($0.0, $0.1, $1) }
            .flatMap { [weak self] secretSantaId, participients, pairsElements -> Driver<Action> in
                guard let self else { return .never() }
                
                let excludePairs = pairsElements.compactMap { element -> ExcludePair? in
                    guard case .excludePair(let element) = element else { return nil }
                    
                    return ExcludePair(
                        id: element.id,
                        secretSantaId: secretSantaId,
                        participientOneId: element.participientOne.id,
                        participientTwoId: element.participientTwo.id
                    )
                }
                
                return secretSantaManager
                    .createMatches(
                        secretSantaId: secretSantaId,
                        participients: participients,
                        excludePairs: excludePairs
                    )
                    .map { _ in Action.nextStep(secretSantaId) }
                    .asDriver(onErrorJustReturn: Action.matchingError)
            }
        
        return Driver
            .merge(openPaygate, nextStep)
    }
}

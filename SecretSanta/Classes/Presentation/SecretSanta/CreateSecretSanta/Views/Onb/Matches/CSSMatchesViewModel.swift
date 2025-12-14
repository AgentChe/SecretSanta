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
    
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    private lazy var secretSantaManager = SecretSantaManager()
    private lazy var restApiTransport = RestAPITransport()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
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
    func makeAction(didReceiveSecretSantaId: Signal<String>) -> Driver<Action> {
        didReceiveSecretSantaId
            .asObservable()
            .flatMapLatest { [weak self] secretSantaId -> Observable<Action> in
                guard let self else { return .empty() }

                let totalPercent = 100
                let interval = RxTimeInterval.milliseconds(40)

                let percentStream = Observable<Int>
                    .interval(interval, scheduler: MainScheduler.instance)
                    .map { tick in min(Int(tick) + 1, totalPercent) }
                    .take(totalPercent)
                    .share(replay: 1, scope: .whileConnected)

                let progressActions = percentStream
                    .map { Action.setProgress($0) }

                let progressReached100 = percentStream
                    .filter { $0 == totalPercent }
                    .take(1)
                    .map { _ in () }

                let shareCompleted = makeShare(didReceiveSecretSantaId: Signal.just(secretSantaId))
                    .asObservable()
                    .take(1) 

                let nextStep = Observable
                    .zip(progressReached100, shareCompleted)
                    .map { _ in Action.nextStep(secretSantaId) }

                return Observable.merge(progressActions, nextStep)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeShare(didReceiveSecretSantaId: Signal<String>) -> Driver<Void> {
        guard SessionManager().hasActiveSubscriptions() else {
            return .deferred { .just(Void()) }
        }
        
        let matches = makeMatches(didReceiveSecretSantaId: didReceiveSecretSantaId)
        let participients = makeParticipients(didReceiveSecretSantaId: didReceiveSecretSantaId)
        let matchesElements = makeElements(matches: matches, participiens: participients)
        let pairs = makePairs(matchesElements: matchesElements)
        
        return pairs
            .flatMapLatest { [weak self] pairs -> Driver<Void> in
                guard let self else { return .never() }
                
                func source() -> Single<Void> {
                    let request = ShareDataRequest(pairs: pairs)
                    
                    return restApiTransport
                        .share(data: request)
                        .map { response in
                            guard
                                let json = response as? [String: Any],
                                let error = json["error"] as? String,
                                !error.isEmpty
                            else { return Void() }
                            
                            throw ContentError(.notContent)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    tryAgain?(error) ?? .empty()
                }
                
                return observableRetrySingle
                    .retry(
                        source: { source() },
                        trigger: { trigger(error: $0) }
                    )
                    .asDriver(onErrorDriveWith: .never())
            }
    }
    
    func makePairs(matchesElements: Driver<[MatchesElement]>) -> Driver<[String: URL]> {
        matchesElements
            .flatMapFirst { matchesElements -> Driver<[String: URL]> in
                Single<[String: URL]>
                    .create { single in
                        MailGenerate.pdfDataByEmail(matchesElements: matchesElements) { pairs in
                            single(.success(pairs))
                        }
                        
                        return Disposables.create()
                    }
                    .asDriver(onErrorJustReturn: [:])
            }
    }
    
    func makeElements(
        matches: Driver<[Match]>,
        participiens: Driver<[Participient]>
    ) -> Driver<[MatchesElement]> {
        Driver
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
    
    func makeMatches(didReceiveSecretSantaId: Signal<String>) -> Driver<[Match]> {
        didReceiveSecretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<[Match]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchMatches(secretSantaId: secretSantaId)
                    .asDriver(onErrorJustReturn: [])
            }
    }
    
    func makeParticipients(didReceiveSecretSantaId: Signal<String>) -> Driver<[Participient]> {
        didReceiveSecretSantaId
            .flatMapLatest { [weak self] secretSantaId -> Driver<[Participient]> in
                guard let self else { return .never() }
                
                return secretSantaManager
                    .fetchParticipents(secretSantaId: secretSantaId)
                    .asDriver(onErrorJustReturn: [])
            }
    }
}

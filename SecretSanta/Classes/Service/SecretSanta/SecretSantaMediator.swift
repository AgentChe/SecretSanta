//
//  SecretSantaMediator.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import RxSwift
import RxCocoa

final class SecretSantaMediator {
    static let shared = SecretSantaMediator()
    
    private lazy var didCreatedSecretSantaTrigger = PublishRelay<SecretSanta>()
    private lazy var didCreatedParticipientTrigger = PublishRelay<Participient>()
    private lazy var didEditedParticipientTrigger = PublishRelay<Participient>()
    private lazy var didDeletedParticipientTrigger = PublishRelay<String>()
    private lazy var didCreatedExcludePairTrigger = PublishRelay<ExcludePair>()
    private lazy var didDeletedExcludePairTrigger = PublishRelay<String>()
    private lazy var didCreatedMatchesTrigger = PublishRelay<[Match]>()
    
    private init() {}
}

// MARK: Public
extension SecretSantaMediator {
    func createdSecretSanta(_ secretSanta: SecretSanta) {
        didCreatedSecretSantaTrigger.accept(secretSanta)
    }
    
    func createdParticipient(_ participient: Participient) {
        didCreatedParticipientTrigger.accept(participient)
    }
    
    func editedParticipient(_ participient: Participient) {
        didEditedParticipientTrigger.accept(participient)
    }
    
    func deletedParticipient(_ participientId: String) {
        didDeletedParticipientTrigger.accept(participientId)
    }
    
    func createdExcludePair(_ excludePair: ExcludePair) {
        didCreatedExcludePairTrigger.accept(excludePair)
    }
    
    func deletedExcludePair(_ excludePairId: String) {
        didDeletedExcludePairTrigger.accept(excludePairId)
    }
    
    func createdMatches(_ matches: [Match]) {
        didCreatedMatchesTrigger.accept(matches)
    }
    
    var didCreatedSecretSanta: Signal<SecretSanta> {
        didCreatedSecretSantaTrigger.asSignal()
    }
    
    var didCreatedParticipient: Signal<Participient> {
        didCreatedParticipientTrigger.asSignal()
    }
    
    var didEditedParticipient: Signal<Participient> {
        didEditedParticipientTrigger.asSignal()
    }
    
    var didDeletedParticipient: Signal<String> {
        didDeletedParticipientTrigger.asSignal()
    }
    
    var didCreatedExcludePair: Signal<ExcludePair> {
        didCreatedExcludePairTrigger.asSignal()
    }
    
    var didDeletedExcludePair: Signal<String> {
        didDeletedExcludePairTrigger.asSignal()
    }
    
    var didCreatedMatches: Signal<[Match]> {
        didCreatedMatchesTrigger.asSignal()
    }
}

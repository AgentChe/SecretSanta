//
//  SecretSantaManager.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 28.11.2025.
//

import RxSwift
import GRDB

protocol SecretSantaProtocol {
    func createSecretSanta(name: String) -> Single<SecretSanta>
    func fetchSecretSantas() -> Single<[SecretSanta]>
    func createParticipient(secretSantaId: String, name: String, email: String) -> Single<Participient>
    func editParticipient(id: String, secretSantaId: String, name: String, email: String) -> Single<Participient>
    func deleteParticipient(id: String) -> Single<Void>
    func fetchParticipents(secretSantaId: String) -> Single<[Participient]>
    func fetchParticipents() -> Single<[Participient]>
    func createExcludePair(secretSantaId: String, participientOneId: String, participientTwoId: String) -> Single<ExcludePair>
    func deleteExcludePair(id: String) -> Single<Void>
    func fetchExcludePairs(secretSantaId: String) -> Single<[ExcludePair]>
    func createMatches(secretSantaId: String, participients: [Participient], excludePairs: [ExcludePair]) -> Single<[Match]>
    func fetchMatches(secretSantaId: String) -> Single<[Match]>
    func fetchMatches() -> Single<[Match]>
    func fetchSecretSantasCheckinCompletion() -> Single<[SecretSantaCheckinCompleted]>
    func fetchSecretSantaParticipientsCount() -> Single<[SecretSantaParticipientsCount]>
}

final class SecretSantaManager {
    enum SecretSantaError: Error {
        case dbNotInitialized
        case matchingFailed
    }
    
    private let dbQueue: DatabaseQueue?
    
    init() {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("secretsanta.sqlite")
        
        let dbQueue = try? DatabaseQueue(path: fileURL.path)
        self.dbQueue = dbQueue
        
        if let dbQueue {
            try? migrator.migrate(dbQueue)
        }
    }
}

// MARK: SecretSantaProtocol
extension SecretSantaManager: SecretSantaProtocol {
    func createSecretSanta(name: String) -> Single<SecretSanta> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            let secretSanta = SecretSanta(
                id: UUID().uuidString,
                name: name
            )

            do {
                try dbQueue.write { db in
                    try secretSanta.insert(db)
                }
                single(.success(secretSanta))
                
                SecretSantaMediator.shared.createdSecretSanta(secretSanta)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func fetchSecretSantas() -> Single<[SecretSanta]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try SecretSanta.fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func createParticipient(
        secretSantaId: String,
        name: String,
        email: String
    ) -> Single<Participient> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            let participient = Participient(
                id: UUID().uuidString,
                secretSantaId: secretSantaId,
                name: name,
                email: email
            )

            do {
                try dbQueue.write { db in
                    try participient.insert(db)
                }
                single(.success(participient))
                
                SecretSantaMediator.shared.createdParticipient(participient)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func editParticipient(
        id: String,
        secretSantaId: String,
        name: String,
        email: String
    ) -> Single<Participient> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            let participient = Participient(
                id: id,
                secretSantaId: secretSantaId,
                name: name,
                email: email
            )

            do {
                try dbQueue.write { db in
                    try participient.update(db)
                }
                single(.success(participient))
                
                SecretSantaMediator.shared.editedParticipient(participient)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func deleteParticipient(id: String) -> Single<Void> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                try dbQueue.write { db in
                    _ = try Participient.deleteOne(db, key: id)
                }
                single(.success(()))
                
                SecretSantaMediator.shared.deletedParticipient(id)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func fetchParticipents(secretSantaId: String) -> Single<[Participient]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try Participient
                        .filter(Column("secretSantaId") == secretSantaId)
                        .fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
    
    func fetchParticipents() -> Single<[Participient]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try Participient.fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func createExcludePair(
        secretSantaId: String,
        participientOneId: String,
        participientTwoId: String
    ) -> Single<ExcludePair> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            let excludePair = ExcludePair(
                id: UUID().uuidString,
                secretSantaId: secretSantaId,
                participientOneId: participientOneId,
                participientTwoId: participientTwoId
            )

            do {
                try dbQueue.write { db in
                    try excludePair.insert(db)
                }
                single(.success(excludePair))
                
                SecretSantaMediator.shared.createdExcludePair(excludePair)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func deleteExcludePair(id: String) -> Single<Void> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                try dbQueue.write { db in
                    _ = try ExcludePair.deleteOne(db, key: id)
                }
                single(.success(()))
                
                SecretSantaMediator.shared.deletedExcludePair(id)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func fetchExcludePairs(secretSantaId: String) -> Single<[ExcludePair]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try ExcludePair
                        .filter(Column("secretSantaId") == secretSantaId)
                        .fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func createMatches(
        secretSantaId: String,
        participients: [Participient],
        excludePairs: [ExcludePair]
    ) -> Single<[Match]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let matches = try dbQueue.write { db in
                    try Match
                        .filter(Column("secretSantaId") == secretSantaId)
                        .deleteAll(db)

                    let participantIds = participients.map { $0.id }

                    let excludedSet = Self.makeExcludedSet(from: excludePairs)

                    guard let receivers = Self.makeValidPermutation(
                        participants: participantIds,
                        excludedPairs: excludedSet
                    ) else {
                        throw SecretSantaError.matchingFailed
                    }

                    var result = [Match]()

                    for (giverId, receiverId) in zip(participantIds, receivers) {
                        let match = Match(
                            id: UUID().uuidString,
                            secretSantaId: secretSantaId,
                            participientOneId: giverId,
                            participientTwoId: receiverId
                        )
                        try match.insert(db)
                        result.append(match)
                    }

                    return result
                }

                single(.success(matches))
                
                SecretSantaMediator.shared.createdMatches(matches)
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func fetchMatches(secretSantaId: String) -> Single<[Match]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try Match
                        .filter(Column("secretSantaId") == secretSantaId)
                        .fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
    
    func fetchMatches() -> Single<[Match]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result = try dbQueue.read { db in
                    try Match.fetchAll(db)
                }
                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
    
    func fetchSecretSantasCheckinCompletion() -> Single<[SecretSantaCheckinCompleted]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let result: [Row] = try dbQueue.read { db in
                    try Row.fetchAll(
                        db,
                        sql: """
                        SELECT SecretSanta.id AS id,
                               COUNT(Match.id) AS matchesCount
                        FROM SecretSanta
                        LEFT JOIN Match ON Match.secretSantaId = SecretSanta.id
                        GROUP BY SecretSanta.id
                        """
                    )
                }

                var checkinResult = [SecretSantaCheckinCompleted]()
                checkinResult.reserveCapacity(result.count)

                for row in result {
                    let id = row["id"] as String
                    let matchesCount = row["matchesCount"] as Int
                    
                    let checkin = SecretSantaCheckinCompleted(
                        secretSantaId: id,
                        completed: matchesCount > 0
                    )
                    checkinResult.append(checkin)
                }

                single(.success(checkinResult))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }

    func fetchSecretSantaParticipientsCount() -> Single<[SecretSantaParticipientsCount]> {
        Single.create { [weak self] single in
            guard let dbQueue = self?.dbQueue else {
                single(.failure(SecretSantaError.dbNotInitialized))
                return Disposables.create()
            }

            do {
                let rows: [Row] = try dbQueue.read { db in
                    try Row.fetchAll(
                        db,
                        sql: """
                        SELECT SecretSanta.id AS id,
                               COUNT(Participient.id) AS participientsCount
                        FROM SecretSanta
                        LEFT JOIN Participient
                          ON Participient.secretSantaId = SecretSanta.id
                        GROUP BY SecretSanta.id
                        """
                    )
                }

                var result = [SecretSantaParticipientsCount]()
                result.reserveCapacity(rows.count)

                for row in rows {
                    let id = row["id"] as String
                    let count = row["participientsCount"] as Int

                    let item = SecretSantaParticipientsCount(
                        secretSantaId: id,
                        count: count
                    )
                    result.append(item)
                }

                single(.success(result))
            } catch {
                single(.failure(error))
            }

            return Disposables.create()
        }
    }
}

// MARK: Private
private extension SecretSantaManager  {
    struct UnorderedPair: Hashable {
        let a: String
        let b: String

        init(_ x: String, _ y: String) {
            if x < y {
                self.a = x
                self.b = y
            } else {
                self.a = y
                self.b = x
            }
        }
    }

    static func makeExcludedSet(from excludePairs: [ExcludePair]) -> Set<UnorderedPair> {
        var set = Set<UnorderedPair>()
        for pair in excludePairs {
            set.insert(UnorderedPair(pair.participientOneId, pair.participientTwoId))
        }
        return set
    }
    
    static func makeValidPermutation(
        participants: [String],
        excludedPairs: Set<UnorderedPair>
    ) -> [String]? {
        let n = participants.count
        guard n > 1 else { return nil }

        var allowedReceivers: [[String]] = []
        allowedReceivers.reserveCapacity(n)

        for giver in participants {
            var allowed: [String] = []
            
            for receiver in participants where receiver != giver {
                let pair = UnorderedPair(giver, receiver)
                if !excludedPairs.contains(pair) {
                    allowed.append(receiver)
                }
            }
            
            if allowed.isEmpty {
                return nil
            }
            
            allowedReceivers.append(allowed.shuffled())
        }

        var receivers = Array<String?>(repeating: nil, count: n)
        var usedReceivers = Set<String>()

        func backtrack(_ index: Int) -> Bool {
            if index == n {
                return true
            }

            for receiver in allowedReceivers[index] {
                if usedReceivers.contains(receiver) {
                    continue
                }

                receivers[index] = receiver
                usedReceivers.insert(receiver)

                if backtrack(index + 1) {
                    return true
                }

                receivers[index] = nil
                usedReceivers.remove(receiver)
            }

            return false
        }

        guard backtrack(0) else { return nil }

        return receivers.compactMap { $0 }
    }
    
    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createSecretSantaSchema") { db in
            try db.create(table: "SecretSanta") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
            }

            try db.create(table: "Participient") { t in
                t.column("id", .text).primaryKey()
                t.column("secretSantaId", .text)
                    .notNull()
                    .indexed()
                    .references("SecretSanta", onDelete: .cascade)
                t.column("name", .text).notNull()
                t.column("email", .text).notNull()
            }

            try db.create(table: "ExcludePair") { t in
                t.column("id", .text).primaryKey()
                t.column("secretSantaId", .text)
                    .notNull()
                    .indexed()
                    .references("SecretSanta", onDelete: .cascade)
                t.column("participientOneId", .text)
                    .notNull()
                    .indexed()
                    .references("Participient", onDelete: .cascade)
                t.column("participientTwoId", .text)
                    .notNull()
                    .indexed()
                    .references("Participient", onDelete: .cascade)
            }

            try db.create(table: "Match") { t in
                t.column("id", .text).primaryKey()
                t.column("secretSantaId", .text)
                    .notNull()
                    .indexed()
                    .references("SecretSanta", onDelete: .cascade)
                t.column("participientOneId", .text)
                    .notNull()
                    .indexed()
                    .references("Participient", onDelete: .cascade)
                t.column("participientTwoId", .text)
                    .notNull()
                    .indexed()
                    .references("Participient", onDelete: .cascade)
            }
        }
        return migrator
    }
}


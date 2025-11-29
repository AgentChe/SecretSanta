//
//  SecretSanta.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 28.11.2025.
//

import GRDB

struct SecretSanta: Codable, Identifiable, FetchableRecord, PersistableRecord {
    let id: String
    let name: String
}

struct Participient: Codable, Identifiable, FetchableRecord, PersistableRecord {
    let id: String
    let secretSantaId: String
    let name: String
    let email: String
}

struct ExcludePair: Codable, Identifiable, FetchableRecord, PersistableRecord {
    let id: String
    let secretSantaId: String
    let participientOneId: String
    let participientTwoId: String
}

struct Match: Codable, Identifiable, FetchableRecord, PersistableRecord {
    let id: String
    let secretSantaId: String
    let participientOneId: String
    let participientTwoId: String
}

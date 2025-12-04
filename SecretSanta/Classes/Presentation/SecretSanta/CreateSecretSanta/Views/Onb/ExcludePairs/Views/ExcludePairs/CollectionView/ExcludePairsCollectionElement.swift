//
//  ExcludePairsCollectionElement.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 04.12.2025.
//

enum ExcludePairsCollectionElement {
    case excludePair(ExcludePairsCollectionPairElement)
    case goingToSelect(Participient)
    
    func contains(participientId: String) -> Bool {
        switch self {
        case .excludePair(let element):
            return (element.participientOne.id == participientId || element.participientTwo.id == participientId)
        case .goingToSelect(let element):
            return element.id == participientId
        }
    }
}

struct ExcludePairsCollectionPairElement {
    let id: String
    let participientOne: Participient
    let participientTwo: Participient
}

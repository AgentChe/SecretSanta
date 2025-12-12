//
//  MatchesElement.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 10.12.2025.
//

import Foundation

struct MatchesElement {
    let id: String
    let participientOne: Participient
    let participientTwo: Participient
    
    init(participientOne: Participient, participientTwo: Participient) {
        self.id = UUID().uuidString
        self.participientOne = participientOne
        self.participientTwo = participientTwo
    }
}

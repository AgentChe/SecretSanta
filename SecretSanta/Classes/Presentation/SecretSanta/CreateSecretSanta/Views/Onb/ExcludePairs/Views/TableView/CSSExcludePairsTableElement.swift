//
//  CSSExcludePairsTableElement.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 02.12.2025.
//

final class CSSExcludePairsTableElement {
    let participient: Participient
    var selected: Bool
    
    init(participient: Participient, selected: Bool) {
        self.participient = participient
        self.selected = selected
    }
}

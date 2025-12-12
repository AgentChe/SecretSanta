//
//  MatchesCardsView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 10.12.2025.
//

import UIKit

final class MatchesCardsView: UIView {
    enum Constants {
        static let cardWidth = 329.scale
        static let cardHeight = 440.scale
    }
    
    private lazy var elements = [MatchesElement]()
    
    private var previousCardView: MatchCardView?
    private var currentCardView: MatchCardView?
    private var nextCardView: MatchCardView?
}

// MARK: Public
extension MatchesCardsView {
    func select(elementId: String) {
        clear()
        
        reload(setupElementId: elementId, force: true)
    }
    
    func setup(elements: [MatchesElement], startWith: String? = nil) {
        self.elements = elements
        
        clear()
        
        if let setupElementId = startWith ?? elements.first?.id {
            reload(setupElementId: setupElementId, force: true)
        }
    }
    
    func switchToNext() {
        guard
            let currentElement = currentCardView?.element,
            let currentElementIndex = elements.firstIndex(where: { $0.id == currentElement.id }),
            let nextElement = elements[safe: currentElementIndex + 1]
        else { return }
        
        reload(setupElementId: nextElement.id, force: false)
    }
    
    func switchToPrevious() {
        guard
            let currentElement = currentCardView?.element,
            let currentElementIndex = elements.firstIndex(where: { $0.id == currentElement.id }),
            let previousElement = elements[safe: currentElementIndex - 1]
        else { return }
        
        reload(setupElementId: previousElement.id, force: false)
    }
}

// MARK: Private
private extension MatchesCardsView {
    func clear() {
        previousCardView?.removeFromSuperview()
        currentCardView?.removeFromSuperview()
        nextCardView?.removeFromSuperview()
        
        self.previousCardView = nil
        self.currentCardView = nil
        self.nextCardView = nil
    }
    
    func reload(setupElementId: String, force: Bool) {
        force ? creation(currentElementId: setupElementId) : switching(toElementId: setupElementId)
    }
    
    func creation(currentElementId: String) {
        if let currentCardIndex = elements.firstIndex(where: { $0.id == currentElementId }) {
            let previousIndex = currentCardIndex - 1
            if let previousCard = elements[safe: previousIndex] {
                let cardView = MatchCardView(element: previousCard)
                cardView.alpha = 0.2
                cardView.frame.size = CGSize(
                    width: Constants.cardWidth,
                    height: Constants.cardHeight
                )
                cardView.frame.origin = CGPoint(x: -(Constants.cardWidth - 16.scale), y: 0)
                addSubview(cardView)
                
                self.previousCardView = cardView
            }
        }
        
        if let currentCard = elements.first(where: { $0.id == currentElementId }) {
            let cardView = MatchCardView(element: currentCard)
            cardView.frame.size = CGSize(
                width: Constants.cardWidth,
                height: Constants.cardHeight
            )
            cardView.frame.origin = CGPoint(x: 32.scale, y: 0)
            addSubview(cardView)
            
            self.currentCardView = cardView
        }
        
        if let currentCardIndex = elements.firstIndex(where: { $0.id == currentElementId }) {
            let nextIndex = currentCardIndex + 1
            if let nextCard = elements[safe: nextIndex] {
                let cardView = MatchCardView(element: nextCard)
                cardView.alpha = 0.2
                cardView.frame.size = CGSize(
                    width: Constants.cardWidth,
                    height: Constants.cardHeight
                )
                cardView.frame.origin = CGPoint(x: 377.scale, y: 0)
                addSubview(cardView)
                
                self.nextCardView = cardView
            }
        }
    }
    
    func switching(toElementId: String) {
        guard let currentCardView, currentCardView.element.id != toElementId else { return }
        
        enum Direction {
            case left, right
        }
        
        let direction: Direction? = {
            if previousCardView?.element.id == toElementId {
                return .left
            } else if nextCardView?.element.id == toElementId {
                return .right
            }
            return nil
        }()
        guard let direction else { return }
        
        switch direction {
        case .left:
            let newPreviousCardView: MatchCardView? = {
                guard
                    let currentPreviousId = previousCardView?.element.id,
                    let currentPreviousIndex = elements.firstIndex(where: { $0.id == currentPreviousId }),
                    let newPreviousCard = elements[safe: currentPreviousIndex - 1]
                else { return nil }
                
                let cardView = MatchCardView(element: newPreviousCard)
                cardView.alpha = 0.2
                cardView.frame.size = CGSize(
                    width: Constants.cardWidth,
                    height: Constants.cardHeight
                )
                cardView.frame.origin = CGPoint(x: -ScreenSize.width + 16.scale - Constants.cardWidth, y: 0)
                addSubview(cardView)
                return cardView
            }()
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                
                if let previousCardView {
                    previousCardView.frame.origin = CGPoint(x: 32.scale, y: 0)
                    previousCardView.alpha = 1
                }
                
                currentCardView.frame.origin = CGPoint(x: 377.scale, y: 0)
                currentCardView.alpha = 0.2
                
                if let nextCardView {
                    nextCardView.frame.origin = CGPoint(x: ScreenSize.width + 16.scale + Constants.cardWidth, y: 0)
                }
                
                if let newPreviousCardView {
                    newPreviousCardView.frame.origin = CGPoint(x: -(Constants.cardWidth - 16.scale), y: 0)
                }
            }, completion: { [weak self] _ in
                self?.nextCardView = self?.currentCardView
                self?.currentCardView = self?.previousCardView
                self?.previousCardView = newPreviousCardView
            })
        case .right:
            let newNextCardView: MatchCardView? = {
                guard
                    let currentNextId = nextCardView?.element.id,
                    let currentNextIndex = elements.firstIndex(where: { $0.id == currentNextId }),
                    let newNextCard = elements[safe: currentNextIndex + 1]
                else { return nil }
                
                let cardView = MatchCardView(element: newNextCard)
                cardView.alpha = 0.2
                cardView.frame.size = CGSize(
                    width: Constants.cardWidth,
                    height: Constants.cardHeight
                )
                cardView.frame.origin = CGPoint(x: ScreenSize.width - 16.scale + Constants.cardWidth, y: 0)
                addSubview(cardView)
                return cardView
            }()
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else { return }
                
                if let previousCardView {
                    previousCardView.frame.origin = CGPoint(x: -MatchesCardsView.Constants.cardWidth, y: 0)
                }
                
                currentCardView.frame.origin = CGPoint(x: -(Constants.cardWidth - 16.scale), y: 0)
                currentCardView.alpha = 0.2
                
                if let nextCardView {
                    nextCardView.frame.origin = CGPoint(x: 32.scale, y: 0)
                    nextCardView.alpha = 1
                }
                
                if let newNextCardView {
                    newNextCardView.frame.origin = CGPoint(x: 377.scale, y: 0)
                }
            }, completion: { [weak self] _ in
                self?.previousCardView = self?.currentCardView
                self?.currentCardView = self?.nextCardView
                self?.nextCardView = newNextCardView
            })
        }
    }
}

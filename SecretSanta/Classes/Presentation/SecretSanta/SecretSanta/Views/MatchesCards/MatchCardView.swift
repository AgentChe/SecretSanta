//
//  MatchCardView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 10.12.2025.
//

import UIKit

final class MatchCardView: UIView {
    enum Constants {
        static let bigLineHeight = 89.scale
    }
    
    let element: MatchesElement
    
    lazy var container = makeContainer()
    lazy var p1NameLabel = makeNameLabel(
        name: element.participientOne.name,
        fitsInOneLine: p1NameFitsInOneLine
    )
    lazy var giftLabel = makeOffersGiftToLabel()
    lazy var p2NameLabel = makeNameLabel(
        name: element.participientTwo.name,
        fitsInOneLine: p2NameFitsInOneLine
    )
    
    private let bigAttrs: TextAttributes
    private let smallAttrs: TextAttributes
    
    private let p1NameFitsInOneLine: Bool
    private let p2NameFitsInOneLine: Bool
    
    init(element: MatchesElement) {
        self.element = element
        
        let bigAttrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.CinzelDecorative.bold(size: 66.scale))
            .lineHeight(Constants.bigLineHeight)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        let smallAttrs = TextAttributes()
            .textColor(Appearance.main400)
            .font(Fonts.CinzelDecorative.bold(size: 42.scale))
            .lineHeight(57.scale)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        self.bigAttrs = bigAttrs
        self.smallAttrs = smallAttrs
        
        let maxWidth = MatchesCardsView.Constants.cardWidth - 56.scale
        
        func isFitsInOneLine(name: String) -> Bool {
            let font = Fonts.CinzelDecorative.bold(size: 66.scale)
            let size = (name as NSString).size(withAttributes: [.font: font])
            return ceil(size.width) <= maxWidth
        }
        
        self.p1NameFitsInOneLine = isFitsInOneLine(name: element.participientOne.name)
        self.p2NameFitsInOneLine = isFitsInOneLine(name: element.participientTwo.name)
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension MatchCardView {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 40.scale
        layer.masksToBounds = true
    }
}

// MARK: Make constraints
private extension MatchCardView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            p1NameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28.scale),
            p1NameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -28.scale),
            p1NameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: p1NameFitsInOneLine ? 75.scale : 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            giftLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            giftLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            p2NameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 28.scale),
            p2NameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -28.scale),
            p2NameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: p2NameFitsInOneLine ? -75.scale : -50.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension MatchCardView {
    func makeContainer() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "SecretSanta.Card.Background")
        view.layer.cornerRadius = 40.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameLabel(name: String, fitsInOneLine: Bool) -> UILabel {
        let attrs = fitsInOneLine ? bigAttrs : smallAttrs
        
        let view = UILabel()
        view.attributedText = name.attributed(with: attrs)
        view.numberOfLines = fitsInOneLine ? 1 : 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeOffersGiftToLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 21.scale))
            .lineHeight(25.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "SecretSanta.OffersGiftTo".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}

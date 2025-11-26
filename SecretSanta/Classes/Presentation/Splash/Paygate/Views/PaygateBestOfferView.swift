//
//  PaygateBestOfferView.swift
//  LocationTracker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

final class PaygateBestOfferView: UIView {
    lazy var label = makeLabel()
    
    private lazy var markedAttrs = TextAttributes()
        .textColor(Appearance.mono100)
        .font(Fonts.SFPro.regular(size: 12.scale))
        .lineHeight(19.scale)
        .textAlignment(.center)
    private lazy var normalAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.regular(size: 12.scale))
        .lineHeight(19.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        update(marked: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateBestOfferView {
    func initialize() {
        layer.cornerRadius = 10.scale
    }
    
    func update(marked: Bool) {
        let attrs = marked ? markedAttrs : normalAttrs
        label.attributedText = "Paygate.BestOffer".localized.attributed(with: attrs)
        
        backgroundColor = marked ? UIColor(integralRed: 115, green: 34, blue: 34) : Appearance.mono100
        layer.borderWidth = marked ? 0 : 1.scale
        layer.borderColor = marked ? UIColor(integralRed: 219, green: 223, blue: 230).cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension PaygateBestOfferView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateBestOfferView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

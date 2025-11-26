//
//  PaygateBestOfferView.swift
//  LocationTracker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

final class PaygateBestOfferView: UIView {
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateBestOfferView {
    func initialize() {
        backgroundColor = UIColor.white
        layer.borderWidth = 1.scale
        layer.borderColor = UIColor(integralRed: 219, green: 223, blue: 230).cgColor
        layer.cornerRadius = 10.scale
    }
    
    func update(marked: Bool) {}
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
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFPro.regular(size: 12.scale))
            .lineHeight(19.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.BestOffer".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

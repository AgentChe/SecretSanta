//
//  SecretSantasTableCell.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class SecretSantasTableCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    lazy var draftLabel = makeDraftLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.SFPro.medium(size: 23.scale))
        .lineHeight(28.scale)
        .textAlignment(.left)
    private lazy var participientsCountAttrs = TextAttributes()
        .textColor(Appearance.mono200.withAlphaComponent(0.6))
        .font(Fonts.SFPro.medium(size: 13.scale))
        .lineHeight(16.scale)
        .textAlignment(.left)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SecretSantasTableCell {
    func setup(element: SecretSantasTableElement) {
        let string: NSAttributedString = {
            let result = NSMutableAttributedString()
            
            result.append(element.name.attributed(with: nameAttrs))
            
            if let participientsCount = element.participientsCount {
                let string = String(format: "SecretSantas.ParticipientsCount".localized, participientsCount)
                result.append(string.attributed(with: participientsCountAttrs))
            }
            
            return result
        }()
        label.attributedText = string
        
        draftLabel.isHidden = !element.isDraft
    }
}

// MARK: Private
private extension SecretSantasTableCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension SecretSantasTableCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 23.scale),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -23.scale),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            draftLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -9.scale),
            draftLabel.centerYAnchor.constraint(equalTo: container.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SecretSantasTableCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeDraftLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 13.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)
        
        let angle = CGFloat(3.57 * .pi / 180)
        
        let view = PaddingLabel()
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.transform = CGAffineTransform(rotationAngle: angle)
        view.backgroundColor = UIColor(integralRed: 129, green: 20, blue: 20)
        view.attributedText = "SecretSantas.Draft".localized.attributed(with: attrs)
        view.insets = UIEdgeInsets(vertical: 4.scale, horizontal: 11.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

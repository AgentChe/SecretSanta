//
//  HomeInstructionItemView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 05.12.2025.
//

import UIKit

final class HomeInstructionItemView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    private let step: Int
    
    init(step: Int) {
        self.step = step
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension HomeInstructionItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension HomeInstructionItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 160.scale),
            imageView.heightAnchor.constraint(equalToConstant: 160.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -48.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeInstructionItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Home.Instruction.Step\(step)")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
            .lineHeight(18.scale)
        
        let view = UILabel()
        view.attributedText = "Home.Instruction.Step\(step)".localized.attributed(with: attrs)
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

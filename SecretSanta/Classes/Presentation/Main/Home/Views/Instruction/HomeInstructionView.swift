//
//  HomeInstructionView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 05.12.2025.
//

import UIKit

final class HomeInstructionView: UIView {
    lazy var blurView = makeBlurView()
    lazy var titleLabel = makeTitleLabel()
    lazy var scrollView = makeScrollView()
    lazy var item1View = makeItemView(step: 1)
    lazy var item2View = makeItemView(step: 2)
    lazy var item3View = makeItemView(step: 3)
    lazy var item4View = makeItemView(step: 4)
    lazy var item5View = makeItemView(step: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension HomeInstructionView {
    func initialize() {
        backgroundColor = Appearance.mono100.withAlphaComponent(0.16)
        layer.cornerRadius = 20.scale
        layer.masksToBounds = true 
    }
}

// MARK: Make constraints
private extension HomeInstructionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.scale),
            scrollView.heightAnchor.constraint(equalToConstant: 208.scale)
        ])
        
        NSLayoutConstraint.activate([
            item1View.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            item1View.topAnchor.constraint(equalTo: scrollView.topAnchor),
            item1View.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            item2View.leadingAnchor.constraint(equalTo: item1View.trailingAnchor, constant: 8.scale),
            item2View.topAnchor.constraint(equalTo: scrollView.topAnchor),
            item2View.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            item3View.leadingAnchor.constraint(equalTo: item2View.trailingAnchor, constant: 8.scale),
            item3View.topAnchor.constraint(equalTo: scrollView.topAnchor),
            item3View.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            item4View.leadingAnchor.constraint(equalTo: item3View.trailingAnchor, constant: 8.scale),
            item4View.topAnchor.constraint(equalTo: scrollView.topAnchor),
            item4View.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            item5View.leadingAnchor.constraint(equalTo: item4View.trailingAnchor, constant: 8.scale),
            item5View.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            item5View.topAnchor.constraint(equalTo: scrollView.topAnchor),
            item5View.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension HomeInstructionView {
    func makeBlurView() -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: effect)
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.alpha = 0.28
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.NewYork.mediumBold(size: 25.scale))
            .lineHeight(30.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Home.Instruction.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeItemView(step: Int) -> HomeInstructionItemView {
        let view = HomeInstructionItemView(step: step)
        view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view)
        return view
    }
}

//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: GradientView {
    fileprivate enum Slide: Hashable {
        case create
        case exclude
        case reveal
        case notifications
    }
    
    private lazy var slidesViews: [Slide: UIView] = [
        .create: OIntroView(intro: .create) { [weak self] in
            self?.scroll(from: .create, to: .exclude)
        },
        .exclude: OIntroView(intro: .exclude) { [weak self] in
            self?.scroll(from: .exclude, to: .reveal)
        },
        .reveal: OIntroView(intro: .reveal) { [weak self] in
            self?.scroll(from: .reveal, to: .notifications)
        },
        .notifications: OIntroView(intro: .notifications) { [weak self] in
            self?.finish()
        }
    ]
    
    private let finish: () -> Void
    
    init(finish: @escaping () -> Void) {
        self.finish = finish
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.forEach { slideView in
            slideView.frame.size = bounds.size
        }
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        backgroundColor = Appearance.main300
        
        if let view = slidesViews[.create] {
            view.frame.origin = CGPoint.zero
            addSubview(view)
        }
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        scrollToView.frame.origin = CGPoint(x: bounds.size.width, y: 0)
        
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: -bounds.size.width, y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { result in
            currentView.removeFromSuperview()
        })
    }
}

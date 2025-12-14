//
//  CreateSecretSantaView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit
import RxSwift

final class CreateSecretSantaView: UIView {
    var finish: (() -> Void)?
    
    weak var vc: UIViewController? {
        didSet {
            participientsView.vc = vc
            excludePairsView.vc = vc
            matchesView.vc = vc
            finishView.vc = vc
        }
    }
    
    lazy var container = makeContainer()
    lazy var navigationView = makeNavigationView()
    
    fileprivate enum Slide: Int, Hashable {
        case create = 0, participients, excludePairs, matches, finish
    }
    
    private enum Mode {
        case create, edit(String)
    }
    
    private lazy var slidesViews: [Slide: UIView] = [
        .create: createView,
        .participients: participientsView,
        .excludePairs: excludePairsView,
        .matches: matchesView,
        .finish: finishView
    ]
    private lazy var createView = CSSCreateView { [weak self] secretSantaId in
        self?.scroll(from: .create, to: .participients)
        self?.participientsView.setup(secretSantaId: secretSantaId)
    }
    private lazy var participientsView = CSSParticipientsView { [weak self] secretSantaId in
        self?.scroll(from: .participients, to: .excludePairs)
        self?.excludePairsView.setup(secretSantaId: secretSantaId)
    }
    private lazy var excludePairsView = CSSExcludePairsView { [weak self] secretSantaId in
        self?.scroll(from: .excludePairs, to: .matches)
        self?.matchesView.setup(secretSantaId: secretSantaId)
    }
    private lazy var matchesView = CSSMatchesView { [weak self] secretSantaId in
        self?.scroll(from: .matches, to: .finish)
        self?.finishView.setup(secretSantaId: secretSantaId)
    }
    private lazy var finishView = CSSFinishView { [weak self] in
        self?.finish?()
    }
    
    private let mode: Mode
    
    private lazy var currentSlide = Slide.create
    
    private lazy var disposeBag = DisposeBag()
    
    init(secretSantaId: String?) {
        self.mode = {
            if let secretSantaId {
                return .edit(secretSantaId)
            }
            
            return .create
        }()
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        
        if let secretSantaId {
            participientsView.setup(secretSantaId: secretSantaId)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        slidesViews.map { $1 }.forEach { slideView in
            slideView.frame.size = container.bounds.size
        }
    }
}

// MARK: Private
private extension CreateSecretSantaView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
        
        let initialView: UIView? = {
            switch mode {
            case .create:
                return slidesViews[.create]
            case .edit:
                return slidesViews[.participients]
            }
        }()
        if let initialView {
            initialView.frame.origin = CGPoint.zero
            container.addSubview(initialView)
        }
        
        updateNavigationView(currentSlide: {
            switch mode {
            case .create:
                return .create
            case .edit:
                return .participients
            }
        }())
        
        navigationView.backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                guard let previousSlide = Slide(rawValue: base.currentSlide.rawValue - 1) else { return }
                
                base.scroll(from: base.currentSlide, to: previousSlide)
            })
            .disposed(by: disposeBag)
    }
    
    func scroll(from: Slide, to: Slide) {
        guard let currentView = slidesViews[from], let scrollToView = slidesViews[to] else { return }
        
        let direction: CGFloat = from.rawValue > to.rawValue ? -1 : 1
        
        scrollToView.frame.origin = CGPoint(x: container.bounds.size.width * direction, y: 0)
        
        container.addSubview(scrollToView)
        
        updateNavigationView(currentSlide: to)
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self else { return }
            
            currentView.frame.origin = CGPoint(x: -container.bounds.size.width * direction, y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            currentView.removeFromSuperview()
            
            self?.currentSlide = to
        })
    }
    
    func updateNavigationView(currentSlide: Slide) {
        navigationView.backButton.isHidden = (currentSlide == .create || currentSlide == .participients)
        navigationView.isHidden = (currentSlide == .matches || currentSlide == .finish)
        navigationView.progressView.progress({
            switch currentSlide {
            case .create:
                return 1
            case .participients:
                return 2
            case .excludePairs:
                return 3
            default:
                return 3
            }
        }())
    }
}

// MARK: Make constraints
private extension CreateSecretSantaView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            navigationView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationView.heightAnchor.constraint(equalToConstant: 44.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CreateSecretSantaView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavigationView() -> CSSNavigationView {
        let view = CSSNavigationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

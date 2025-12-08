//
//  MainViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var coordinator = MainViewCoordinator(
        parentVC: self,
        container: mainView.container
    )
    
    private let requestReview: Bool
    
    private init(requestReview: Bool) {
        self.requestReview = requestReview
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Signal
            .merge([
                mainView.tabView.homeButtom
                    .rx.tap.map { MainViewCoordinator.Route.home }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.secretSantasButton
                    .rx.tap.map { MainViewCoordinator.Route.secretSantas }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.createSecretSantaButton
                    .rx.tap.map { MainViewCoordinator.Route.createSecretSanta }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.settingsButton
                    .rx.tap.map { MainViewCoordinator.Route.settings }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.paygateButton
                    .rx.tap.map { SessionManager().hasActiveSubscriptions() ? MainViewCoordinator.Route.home : MainViewCoordinator.Route.paygate }
                    .asSignal(onErrorSignalWith: .never()),
            ])
            .emit(to: Binder(coordinator) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        Signal
            .merge([
                mainView.tabView.homeButtom
                    .rx.tap.map { MainTabView.DrawsItem.home }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.secretSantasButton
                    .rx.tap.map { MainTabView.DrawsItem.secretSantas }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.settingsButton
                    .rx.tap.map { MainTabView.DrawsItem.settings }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.paygateButton
                    .rx.tap.compactMap { SessionManager().hasActiveSubscriptions() ? MainTabView.DrawsItem.home : nil }
                    .asSignal(onErrorSignalWith: .never())
            ])
            .startWith(.home)
            .emit(to: Binder(mainView.tabView) { base, item in
                base.update(selectedItem: item)
            })
            .disposed(by: disposeBag)
        
        Signal
            .merge([
                mainView.tabView.homeButtom
                    .rx.tap.map { MainTabView.Style.colored }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.secretSantasButton
                    .rx.tap.map { MainTabView.Style.normal }
                    .asSignal(onErrorSignalWith: .never()),
                
                mainView.tabView.settingsButton
                    .rx.tap.map { MainTabView.Style.normal }
                    .asSignal(onErrorSignalWith: .never())
            ])
            .startWith(.colored)
            .emit(to: Binder(mainView.tabView) { base, style in
                base.update(style: style)
            })
            .disposed(by: disposeBag)
        
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .bind(to: Binder(self) { base, void in
                base.coordinator.route(.home)
            })
            .disposed(by: disposeBag)
        
        if requestReview {
            RequestReview.request()
        }
    }
}

// MARK: Make
extension MainViewController {
    static func make(requestReview: Bool = false) -> NavigationController {
        let vc = MainViewController(requestReview: requestReview)
        vc.navigationItem.backButtonTitle = " "
        
        return NavigationController(rootViewController: vc)
    }
}

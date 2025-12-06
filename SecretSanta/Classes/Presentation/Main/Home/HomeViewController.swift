//
//  HomeViewController.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 05.12.2025.
//

import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private lazy var mainView = HomeView()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.shareButton.rx.tap
            .bind(to: Binder(self) { base, void in 
                ShareHelper.shareApp(from: base, sourceView: base.mainView.shareButton)
            })
            .disposed(by: disposeBag)
        
        mainView.startSecretSantaButton.rx.tap
            .bind(to: Binder(self) { base, void in
                let vc = CreateSecretSantaViewController.make()
                base.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: Public
extension HomeViewController {
    static func make() -> HomeViewController {
        let vc = HomeViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: ShareHelper
private enum ShareHelper {
    static func shareApp(from viewController: UIViewController, sourceView: UIView? = nil) {
        let items: [Any] = [GlobalDefinitions.appStoreUrl]

        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = sourceView ?? viewController.view
            popover.sourceRect = sourceView?.bounds ?? CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }

        viewController.present(activityVC, animated: true)
    }
}

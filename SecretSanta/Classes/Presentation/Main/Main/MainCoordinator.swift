//
//  MainCoordinator.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class MainViewCoordinator {
    enum Route {
        case home, secretSantas, createSecretSanta, settings, paygate
    }
    
    lazy var homeVC = UIViewController()
    lazy var secretSantasVC = SecretSantasViewController.make()
    lazy var settingsVC = UIViewController()
    
    private weak var parentVC: UIViewController?
    private weak var container: UIView?
    
    private var previousVC: UIViewController?
    
    init(parentVC: UIViewController, container: UIView) {
        self.parentVC = parentVC
        self.container = container
    }
}

// MARK: Public
extension MainViewCoordinator {
    func route(_ route: Route) {
        switch route {
        case .home:
            changeVC(on: homeVC)
        case .secretSantas:
            changeVC(on: secretSantasVC)
        case .createSecretSanta:
            break // TODO: open screen
        case .settings:
            changeVC(on: settingsVC)
        case .paygate:
            let vc = PaygateViewController.make()
            parentVC?.present(vc, animated: true)
        }
    }
}

// MARK: Private
private extension MainViewCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC, let container else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = container.bounds
        container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}

//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    private lazy var mainView = OnboardingView { [weak self] in
        self?.markAsViewed()
        self?.route()
    }
    
    override func loadView() {
        view = mainView
    }
}

// MARK: Public
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
    
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func route() {
        guard let window = UIApplication.shared.window else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                self?.route()
            }
            
            return
        }
        
        if SessionManager().hasActiveSubscriptions() {
//            window.rootViewController = MainViewController.make(requestReview: true, notificationsModel: nil) // TODO
        } else {
            let vc = PaygateViewController.make {
//                window.rootViewController = MainViewController.make(requestReview: true, notificationsModel: nil) // TODO
            }
            present(vc, animated: true)
        }
    }
    
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
}

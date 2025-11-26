//
//  SplashViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

final class SplashViewController: UIViewController {
    private lazy var mainView = SplashView()
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkInitialize.observe { [weak self] in
            self?.route() 
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private
private extension SplashViewController {
    func route() {
        DispatchQueue.main.async { [weak self] in
            guard let window = UIApplication.shared.window else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                    self?.route()
                }
                
                return
            }
            
            if SessionManager().hasActiveSubscriptions() {
//                window.rootViewController = MainViewController.make() // TODO
            } else {
                let vc = PaygateViewController.make { [weak window] in
//                    window?.rootViewController = MainViewController.make() // TODO
                }
                self?.present(vc, animated: true)
            }
        }
    }
}

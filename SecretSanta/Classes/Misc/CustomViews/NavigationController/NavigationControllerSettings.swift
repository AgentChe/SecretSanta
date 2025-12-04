//
//  NursingNavigationControllerSettings.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct NavigationControllerSettings {
    let backgroundImage: UIImage
    let shadowImage: UIImage
    let isTranslucent: Bool
    let tintColor: UIColor
    let titleTextAttrributes: [NSAttributedString.Key: Any]
}

// MARK: Make
extension NavigationControllerSettings {
    static func `default`() -> NavigationControllerSettings {
        NavigationControllerSettings(
            backgroundImage: UIImage(),
            shadowImage: UIImage(),
            isTranslucent: true,
            tintColor: Appearance.main400,
            titleTextAttrributes: TextAttributes()
                .textColor(Appearance.main400)
                .font(Fonts.CinzelDecorative.bold(size: 17.scale))
                .textAlignment(.center)
                .dictionary
        )
    }
}

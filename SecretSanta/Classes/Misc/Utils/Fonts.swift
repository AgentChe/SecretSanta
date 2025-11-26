//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: NewYork
    struct NewYork {
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "NewYork", size: size)!
        }
        
        static func mediumBold(size: CGFloat) -> UIFont {
            UIFont(name: "New York Medium", size: size)!
        }
    }
    
    // MARK: SFPro
    struct SFPro {
        static func regular(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .regular)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .bold)
        }
    }
    
    // MARK: CinzelDecorative
    struct CinzelDecorative {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "CinzelDecorative-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "CinzelDecorative-Regular", size: size)!
        }
    }
}

//
//  GradientButton.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 26.11.2025.
//

import UIKit

class GradientButton: UIButton {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
}

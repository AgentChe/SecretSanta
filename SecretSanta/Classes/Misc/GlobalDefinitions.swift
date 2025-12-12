//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

// TODO
final class GlobalDefinitions {
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "qWzYSh1J5aHKtG6l"
    
    static let termsOfServiceUrl = URL(string: "https://apps-and-taps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://apps-and-taps.com/policy")!
    static let contactUsUrl = URL(string: "https://apps-and-taps.com/#contact")!
    
    static let appStoreUrl = URL(string: "https://apps-and-taps.com/#contact")!
    
    static let developerEmail = "help@apps-and-taps.com"
    
    enum Paygate {
        static let yearly = "iphone.santa.tracker.yearly"
        static let weekly = "iphone.santa.tracker.weekly"
    }
}

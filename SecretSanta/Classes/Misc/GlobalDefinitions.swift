//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://secretsanta.korrekted.com"
    static let apiKey = "qKvYQPtFjTdkxi9le8f"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "hv2qNXwYbXwi8Hrm"
    
    static let termsOfServiceUrl = URL(string: "https://apps-and-taps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://apps-and-taps.com/policy")!
    static let contactUsUrl = URL(string: "https://apps-and-taps.com/#contact")!
    
    static let appStoreUrl = URL(string: "https://appstoreconnect.apple.com/apps/6756610091")!
    
    static let developerEmail = "help@apps-and-taps.com"
    
    enum Paygate {
        static let yearly = "iphone.secretsanta.yearly"
        static let weekly = "iphone.secretsanta.weekly"
    }
}

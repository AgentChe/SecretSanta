//
//  SettingsViewModel.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 06.12.2025.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Action {
        case openPaygate
        case openUrl(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didSelect: Signal<SettingsTableElement>
    }
    
    struct Output {
        let elements: Driver<[SettingsTableElement]>
        let action: Driver<Action>
    }
    
    func configure(input: Input) -> Output {
        Output(
            elements: makeElements(activeSubscription: makeActiveSubscription()),
            action: makeAction(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements(activeSubscription: Driver<Bool>) -> Driver<[SettingsTableElement]> {
        activeSubscription
            .map { activeSubscription -> [SettingsTableElement] in
                [
                    activeSubscription ? nil : .paygate,
                    .contactUs,
                    .termsOfUse,
                    .privacyPolicy
                ].compactMap { $0 }
            }
    }
    
    func makeAction(didSelect: Signal<SettingsTableElement>) -> Driver<Action> {
        didSelect
            .map { element -> Action in
                switch element {
                case .paygate:
                    return .openPaygate
                case .contactUs:
                    return .openUrl(GlobalDefinitions.contactUsUrl)
                case .termsOfUse:
                    return .openUrl(GlobalDefinitions.termsOfServiceUrl)
                case .privacyPolicy:
                    return .openUrl(GlobalDefinitions.privacyPolicyUrl)
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .startWith(())
            .map { SessionManager().hasActiveSubscriptions() }
            .asDriver(onErrorDriveWith: .never())
    }
}

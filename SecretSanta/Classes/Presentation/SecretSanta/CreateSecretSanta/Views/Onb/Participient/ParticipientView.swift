//
//  ParticipientView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 01.12.2025.
//

import UIKit

final class ParticipientView: UIView {
    enum Mode {
        case create, edit
    }
    
    lazy var closeButton = makeCloseButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var nameTextField = makeTextField(placeholder: "Participient.Name".localized)
    lazy var emailTextField = makeTextField(placeholder: "Participient.Email".localized)
    lazy var saveButton = makeSaveButton()
    
    private let mode: Mode
    
    init(participient: Participient?) {
        self.mode = participient == nil ? .create : .edit
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        
        nameTextField.text = participient?.name
        emailTextField.text = participient?.email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ParticipientView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 255, green: 240, blue: 237)
    }
}

// MARK: Make constraints
private extension ParticipientView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            saveButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -11.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 58.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ParticipientView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.NewYork.mediumBold(size: 30.scale))
            .lineHeight(36.scale)
            .textAlignment(.center)
        
        let title: String = {
            switch mode {
            case .create:
                return "Participient.Title.Add".localized
            case .edit:
                return "Participient.Title.Edit".localized
            }
        }()
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextField(placeholder: String) -> PaddingTextField {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        let placeholderAttrs = TextAttributes()
            .textColor(Appearance.mono200.withAlphaComponent(0.2))
            .font(Fonts.SFPro.medium(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.left)
        
        let view = PaddingTextField()
        view.textPadding = UIEdgeInsets(vertical: 20.scale, horizontal: 23.scale)
        view.backgroundColor = Appearance.mono100
        view.layer.cornerRadius = 24.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.6).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.defaultTextAttributes = attrs.dictionary
        view.attributedPlaceholder = placeholder.attributed(with: placeholderAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> GradientButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.medium(size: 15.scale))
        
        let view = GradientButton()
        view.setAttributedTitle("Save".localized.attributed(with: attrs), for: .normal)
        view.gradientLayer.colors = Appearance.main200
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.gradientLayer.locations = [
            NSNumber(value: 0),
            NSNumber(value: 1)
        ]
        view.gradientLayer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

//
//  CSSProgressView.swift
//  SecretSanta
//
//  Created by Андрей Чернышев on 29.11.2025.
//

import UIKit

final class CSSProgressView: UIView {
    lazy var segment1View = makeSegmentView()
    lazy var segment2View = makeSegmentView()
    lazy var segment3View = makeSegmentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CSSProgressView {
    func progress(_ progress: Int) {
        segment1View.alpha = progress >= 1 ? 1 : 0.2
        segment2View.alpha = progress >= 2 ? 1 : 0.2
        segment3View.alpha = progress >= 3 ? 1 : 0.2
    }
}

// MARK: Private
private extension CSSProgressView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension CSSProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            segment1View.leadingAnchor.constraint(equalTo: leadingAnchor),
            segment1View.topAnchor.constraint(equalTo: topAnchor),
            segment1View.bottomAnchor.constraint(equalTo: bottomAnchor),
            segment1View.heightAnchor.constraint(equalToConstant: 4.scale),
            segment1View.widthAnchor.constraint(equalToConstant: 76.scale)
        ])
        
        NSLayoutConstraint.activate([
            segment2View.leadingAnchor.constraint(equalTo: segment1View.trailingAnchor, constant: 8.scale),
            segment2View.topAnchor.constraint(equalTo: topAnchor),
            segment2View.bottomAnchor.constraint(equalTo: bottomAnchor),
            segment2View.heightAnchor.constraint(equalToConstant: 4.scale),
            segment2View.widthAnchor.constraint(equalToConstant: 76.scale)
        ])
        
        NSLayoutConstraint.activate([
            segment3View.leadingAnchor.constraint(equalTo: segment2View.trailingAnchor, constant: 8.scale),
            segment3View.trailingAnchor.constraint(equalTo: trailingAnchor),
            segment3View.topAnchor.constraint(equalTo: topAnchor),
            segment3View.bottomAnchor.constraint(equalTo: bottomAnchor),
            segment3View.heightAnchor.constraint(equalToConstant: 4.scale),
            segment3View.widthAnchor.constraint(equalToConstant: 76.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CSSProgressView {
    func makeSegmentView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.main400
        view.layer.cornerRadius = 2.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

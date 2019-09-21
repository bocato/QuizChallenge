//
//  KeywordsBottomView.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

protocol KeywordsBottomViewProtocol {
    func setLeftText(_ text: String)
    func setRightText(_ text: String)
}

final class KeywordsBottomView: UIView, KeywordsBottomViewProtocol {
    
    // MARK: - Properties
    
    private(set) var buttonAction: (() -> Void)
    
    // MARK: UI
    
    private lazy var leftTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.text = "leftTextLabel" // TODO: Remove
        return label
    }()
    
    private lazy var rightTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.text = "rightTextLabel" // TODO: Remove
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textColor = .white
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .quizOrange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 12.0
        button.anchor(heightConstant: Metrics.Height.fatButton)
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        
        let labelsStackView = StackViewBuilder {
            $0.arrangedSubviews = [
                self.leftTextLabel,
                self.rightTextLabel
            ]
            $0.axis = .horizontal
            $0.distribution = .fill
        }.build()
        
        return StackViewBuilder {
            $0.spacing = Metrics.Margin.default
            $0.arrangedSubviews = [
                labelsStackView,
                self.button
            ]
            $0.axis = .vertical
            $0.distribution = .fillProportionally
        }.build()
        
    }()
    
    // MARK: - Initialization
    
    init(buttonAction: @escaping (() -> Void)) {
        self.buttonAction = buttonAction
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .quizGray
        constrainContentStackView()
    }
    
    // MARK: - Constraints
    
    private func constrainContentStackView() {
        addSubview(contentStackView)
        contentStackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: Metrics.Margin.default,
            leftConstant: Metrics.Margin.default,
            bottomConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
    }
    
    // MARK: - Public Methods
    
    func setLeftText(_ text: String) {
        leftTextLabel.text = text
    }
    
    func setRightText(_ text: String) {
        rightTextLabel.text = text
    }
    
    // MARK: - Actions
    
    @objc private func buttonDidReceiveTouchUpInside() {
        buttonAction()
    }
    
}

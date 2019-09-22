//
//  KeywordsView.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class KeywordsView: UIView, ScrollableContentKeyboardObserving {
   
    // MARK: - Private Properties
    
    private var bottomViewButtonAction: (() -> Void)
    private var textDidReturnClosure: ((String?) -> Void)

    // MARK: UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.apply(typography: .largeTitle, with: .black)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.backgroundColor = .quizGray
        textField.layer.cornerRadius = 12
        textField.addPadding(left: 12, right: 12)
        textField.anchor(heightConstant: Metrics.Height.textField)
        textField.delegate = self
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        
        // layout
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.isHidden = true
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: QuizTableViewCell.className)
        
        return tableView
    }()
    
    private lazy var topContainerStackView: UIStackView = {
        return StackViewBuilder {
            $0.arrangedSubviews = [
                self.titleLabel,
                self.textField
            ]
            $0.spacing = Metrics.Margin.default
            $0.axis = .vertical
            $0.distribution = .fill
        }.build()
    }()
    
    private lazy var bottomView: KeywordsBottomView = {
        let view = KeywordsBottomView { [weak self] in
            self?.bottomViewButtonDidReceiveTouchUpInside()
        }
        return view
    }()
    
    // MARK: - Initialization
    
    init(
        tableViewDataSource: UITableViewDataSource,
        bottomViewButtonAction: @escaping (() -> Void),
        textDidReturnClosure: @escaping((String?) -> Void)
    ) {
        self.bottomViewButtonAction = bottomViewButtonAction
        self.textDidReturnClosure = textDidReturnClosure
        super.init(frame: UIScreen.main.bounds)
        self.tableView.dataSource = tableViewDataSource
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .white
        addSubViews()
        setupKeyboardHandlers()
    }
    
    private func setupKeyboardHandlers() {
        
        observeKeyboardWillShowNotification(tableView) { [bottomView] keyboardSize in
            guard let keyboardHeight = keyboardSize?.height else { return }
            ThreadUtils.runOnMainThread {
                bottomView.bottomConstraint?.constant = keyboardHeight
            }
        }
        
        observeKeyboardWillHideNotification(tableView) { [bottomView] _ in
            ThreadUtils.runOnMainThread {
                bottomView.bottomConstraint?.constant = -Metrics.Margin.default
            }
        }
        
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainBottomView()
        constrainTopContainerStackView()
        constrainTableView()
    }
    
    private func constrainBottomView() {
        addSubview(bottomView)
        bottomView.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            heightConstant: 140
        )
    }
    
    private func constrainTopContainerStackView() {
        addSubview(topContainerStackView)
        topContainerStackView.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: Metrics.Margin.top,
            leftConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
    }
    
    private func constrainTableView() {
        addSubview(tableView)
        tableView.anchor(
            top: topContainerStackView.bottomAnchor,
            left: leftAnchor,
            bottom: bottomView.topAnchor,
            right: rightAnchor,
            topConstant: Metrics.Margin.default,
            leftConstant: Metrics.Margin.default,
            bottomConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
    }
    
    // MARK: Public Functions
    
    func setTitle(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.titleLabel.text = text
        }
    }
    
    func setTextFieldPlaceHolder(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.textField.placeholder = text
        }
    }
    
    func setBottomLeftText(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setLeftText(text)
        }
    }
    
    func setBottomRightText(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setRightText(text)
        }
    }
    
    func setBottomButtonTitle(_ title: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setButtonTitle(title)
        }
    }
    
    func resetTextField() {
        textField.text = nil
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showTableView(_ show: Bool = true) {
        tableView.isHidden = !show
    }
    
    // MARK: - Actions
    
    private func bottomViewButtonDidReceiveTouchUpInside() {
        bottomViewButtonAction()
    }

}
extension KeywordsView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textDidReturnClosure(textField.text)
        textField.text = ""
        return true
    }
    
}

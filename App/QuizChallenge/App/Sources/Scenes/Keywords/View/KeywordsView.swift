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
    private var botttomViewBottomConstraint: NSLayoutConstraint?

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
    
    /// Initializes a KeywordsView
    ///
    /// - Parameters:
    ///   - tableViewDataSource: the inner tableView dataSource
    ///   - bottomViewButtonAction: a closure, to represent the action that needs to be done when the bottom buttom is touched
    ///   - textDidReturnClosure: a closure, to be run when `textFieldShouldReturn` happens on the search textfield
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
        
        observeKeyboardWillShowNotification(tableView) { [botttomViewBottomConstraint] keyboardSize in
            guard let keyboardHeight = keyboardSize?.height else { return }
            botttomViewBottomConstraint?.constant = -keyboardHeight
        }
        
        observeKeyboardWillHideNotification(tableView) { [botttomViewBottomConstraint] _ in
            botttomViewBottomConstraint?.constant = 0
        }
        
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainTopContainerStackView()
        constrainTableView()
        constrainBottomView()
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
            right: rightAnchor,
            topConstant: Metrics.Margin.default,
            leftConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
    }
    
    private func constrainBottomView() {
        addSubview(bottomView)
        bottomView.anchor(
            top: tableView.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
        let bottomConstraint = NSLayoutConstraint(
            item: bottomView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        botttomViewBottomConstraint = bottomConstraint
        NSLayoutConstraint.activate([bottomConstraint])
    }
    
    // MARK: Public Functions
    
    /// Sets the `titleLabel` text
    func setTitle(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.titleLabel.text = text
        }
    }
    
    /// Sets the textField `placeholder` text
    func setTextFieldPlaceHolder(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.textField.placeholder = text
        }
    }
    
    /// Sets the leftTextfield's text of the `BottomView`
    func setBottomLeftText(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setLeftText(text)
        }
    }
    
    // Sets the rightTextfield's text of the `BottomView`
    func setBottomRightText(_ text: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setRightText(text)
        }
    }
    
    // Sets the button's title of the `BottomView`
    func setBottomButtonTitle(_ title: String?) {
        ThreadUtils.runOnMainThread {
            self.bottomView.setButtonTitle(title)
        }
    }
    
    /// Resets the textField
    func resetTextField() {
        textField.text = nil
    }
    
    /// Reloads the tableView
    func reloadTableView() {
        tableView.reloadData()
    }
    
    /// Shows the tableView
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
        return true
    }
    
}

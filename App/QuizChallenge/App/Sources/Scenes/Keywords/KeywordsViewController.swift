//
//  KeywordsViewController.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class KeywordsViewController: UIViewController, CustomViewController, LoadingPresentable {
    
    // MARK: - Aliases
    
    typealias CustomView = KeywordsView
    
    // MARK: - Properties
    
    let viewModel: KeywordsViewModelDisplayLogic & KeywordsViewModelBusinessLogic
    let modalHelper: ModalHelperProtocol
    
    // MARK: - Initialization
    
    init(
        viewModel: KeywordsViewModelDisplayLogic & KeywordsViewModelBusinessLogic,
        modalHelper: ModalHelperProtocol = ModalHelper()
    ) {
        self.viewModel = viewModel
        self.modalHelper = modalHelper
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }
    
    override func loadView() {
        setupCustomView()
    }
    
    // MARK: - Setup
    
    private func setupCustomView () {
        
        let bottomViewButtonAction: (() -> Void) = { [viewModel] in
            viewModel.toggleTimer()
        }
        
        let textDidReturnClosure: ((String?) -> Void) = { [viewModel] newText in
            viewModel.verifyTextFieldInput(newText)
        }
        
        view = CustomView(
            tableViewDataSource: self,
            bottomViewButtonAction: bottomViewButtonAction,
            textDidReturnClosure: textDidReturnClosure
        )
        
    }
    
    // MARK: - Helpers
    private func showErrorModal(_ data: SimpleModalViewData) {
        modalHelper.showAlert(
            inController: self,
            data: data,
            buttonActionHandler: nil,
            presentationCompletion: nil
        )
    }

}

// MARK: - ViewStateRendering
extension KeywordsViewController: ViewStateRendering {
    
    func render(_ state: ViewState) {
        switch state {
        case .loading:
            showLoading()
        case .content:
            hideLoading()
            customView.reloadTableView()
            customView.showTableView()
        case let .error(filler):
            hideLoading()
            renderError(filler)
        default:
            return
        }
        
    }
    
    private func renderError(_ filler: ViewFiller?) {
        guard let title = filler?.title, let subtitle = filler?.subtitle else { return }
        let data = SimpleModalViewData(title: title, subtitle: subtitle)
        showErrorModal(data)
    }
    
}

// MARK: - KeywordsViewModelBinding
extension KeywordsViewController: KeywordsViewModelBinding {
    
    func showErrorModalWithData(_ modalData: SimpleModalViewData) {
        showErrorModal(modalData)
    }
    
    func viewTitleDidChange(_ title: String?) {
        customView.setTitle(title)
    }
    
    func textFieldPlaceholderDidChange(_ text: String?) {
        customView.setTextFieldPlaceHolder(text)
    }
    
    func bottomButtonTitleDidChange(_ title: String?) {
        customView.setBottomButtonTitle(title)
    }
    
    func bottomRightTextDidChange(_ text: String?) {
        customView.setBottomRightText(text)
    }
    
    func bottomLeftTextDidChange(_ text: String?) {
        customView.setBottomLeftText(text)
    }
    
    func showTimerFinishedModalWithData(_ modalData: SimpleModalViewData) {
        
        let buttonActionHandler: (() -> Void) = { [viewModel] in
            viewModel.resetQuiz()
        }
        
        modalHelper.showAlert(
            inController: self,
            data: modalData,
            buttonActionHandler: buttonActionHandler,
            presentationCompletion: nil
        )
        
    }
    
    func showWinnerModalWithData(_ modalData: SimpleModalViewData) {
        
        let buttonActionHandler: (() -> Void) = { [viewModel] in
            viewModel.resetQuiz()
        }
        
        modalHelper.showAlert(
            inController: self,
            data: modalData,
            buttonActionHandler: buttonActionHandler,
            presentationCompletion: nil
        )
        
    }
    
}

extension KeywordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAnswers
    }
    
    // TODO: Refactor
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: QuizTableViewCell.className,
            for: indexPath
        ) as? QuizTableViewCell,
        let answer = viewModel.answerItem(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.configure(with: answer)
        return cell
    }
    
}

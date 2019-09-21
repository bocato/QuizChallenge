//
//  KeywordsViewController.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class KeywordsViewController: UIViewController, CustomViewController {
    
    // MARK: - Aliases
    
    typealias CustomView = KeywordsView
    
    // MARK: - Properties
    
    let viewModel: KeywordsViewModel
    
    // MARK: - Initialization
    
    init(viewModel: KeywordsViewModel) {
        self.viewModel = viewModel
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
        
        let bottomViewButtonAction: (() -> Void) = {
            debugPrint("bottomViewButtonAction")
        }
        
        view = CustomView(
            tableViewDataSource: self,
            bottomViewButtonAction: bottomViewButtonAction
        )
    }
    
    // MARK: - Layout
    
    

}

// MARK: - KeywordsViewModelDelegate
extension KeywordsViewController: KeywordsViewModelDelegate {
    
    func viewTitleDidChange(_ title: String?) {
        customView.setTitle(title)
    }
    
    func bottomButtonTitleDidChange(_ title: String?) {
        customView.bottomView.setButtonTitle(title)
    }
    
    
    func renderTitle(_ title: String) {
        
    }
    
    func render(_ state: ViewState) {
        switch state {
        case .loading:
            debugPrint("render: \(state)")
        case .content:
            customView.reloadTableView()
            customView.showTableView()
        case let .error(withFiller: filler):
            debugPrint("render: \(filler.debugDescription)")
        default:
            return
        }
        
    }
}

extension KeywordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfAnswers
    }
    
    // TODO: Refactor
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.className, for: indexPath) as? QuizTableViewCell else {
            return UITableViewCell()
        }
        let answer = viewModel.answerItem(at: indexPath.row)
        cell.configure(with: answer)
        return cell
    }
    
}

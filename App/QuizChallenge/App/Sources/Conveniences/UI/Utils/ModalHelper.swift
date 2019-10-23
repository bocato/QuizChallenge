//
//  ModalHelper.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

struct SimpleModalViewData {
    let title: String
    let subtitle: String
    let buttonText: String?
    
    init(
        title: String,
        subtitle: String,
        buttonText: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
    }
}

protocol ModalHelperProtocol {
    
    /// Presents an Alert Controller with an alert message.
    ///
    /// - Parameters:
    ///   - controller: the View Controller where the alert will be presented.
    ///   - data: the data that needs to ne shown on the alert
    ///   - buttonActionHandler: what needs to be done when the button is pressed
    ///   - completionHandler: a Closure to be executed right after presenting the alert.
    func showAlert(
        inController controller: UIViewController?,
        data: SimpleModalViewData,
        buttonActionHandler: (() -> Void)?,
        presentationCompletion: (() -> Void)?)
}

final class ModalHelper: ModalHelperProtocol {
    
    /// Presents an Alert Controller with an alert message.
    ///
    /// - Parameters:
    ///   - controller: the View Controller where the alert will be presented.
    ///   - data: the data that needs to ne shown on the alert
    ///   - buttonActionHandler: what needs to be done when the button is pressed
    ///   - completionHandler: a Closure to be executed right after presenting the alert.
    func showAlert(inController controller: UIViewController?,
                          data: SimpleModalViewData,
                          buttonActionHandler: (() -> Void)? = nil,
                          presentationCompletion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: data.title, message: data.subtitle, preferredStyle: .alert)
        
        let buttonActionTitle = data.buttonText ?? "Ok"
        var buttonAction = UIAlertAction(title: buttonActionTitle, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        if let buttonActionHandler = buttonActionHandler {
            buttonAction = UIAlertAction(title: buttonActionTitle, style: .cancel, handler: { _ in
                buttonActionHandler()
            })
        }
        
        alert.addAction(buttonAction)
        
        DispatchQueue.main.async {
            controller?.present(alert, animated: true, completion: presentationCompletion)
        }
        
    }
    
}

//
//  QuizService.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import Networking

/// Defines possible errors within the QuizServiceProvider context
///
/// - networking: an error comming from the networking dispatcher
enum QuizServiceError: Error {
    case networking(NetworkingError)
}
protocol QuizServiceProvider {
    
    /// Requests a QuizEntity from a URLRequest
    ///
    /// - Parameter completion: the result of the request
    func getQuiz(_ completion: @escaping (Result<QuizEntity, QuizServiceError>) -> Void)
}

final class QuizService: QuizServiceProvider, CodableRequesting {
    
    // MARK: - Properties
    
    var dispatcher: URLRequestDispatching
    
    // MARK: - Initialization
    
    init(dispatcher: URLRequestDispatching = DependencyInjection.urlSessionDispatcher) {
        self.dispatcher = dispatcher
    }
    
    // MARK: - QuizServiceProvider
    
    func getQuiz(_ completion: @escaping (Result<QuizEntity, QuizServiceError>) -> Void) {
        let request: QuizRequest = .quiz
        requestCodable(request, ofType: QuizEntity.self) { networkingResult in
            let resultToReturn = networkingResult.mapError { QuizServiceError.networking($0) }
            completion(resultToReturn)
        }
    }
    
}

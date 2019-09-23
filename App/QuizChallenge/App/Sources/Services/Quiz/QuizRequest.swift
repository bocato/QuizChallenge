//
//  QuizRequest.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import Networking

/// Defines the requests for the quiz endpoint
enum QuizRequest: URLRequestProtocol {
    
    case quiz
    
    var baseURL: URL {
        return Environment.shared.baseURL
    }
    
    var path: String? {
        switch self {
        case .quiz:
            return "quiz/1"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .quiz:
            return .get
        }
    }
    
    var parameters: URLRequestParameters? {
        switch self {
        case .quiz:
            return nil
        }
    }
    
    var headers: [String : Any]? {
        return ["content-type": "application/json"]
    }
    
}

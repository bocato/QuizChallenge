//
//  UseCaseEvent.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Represents events that encapsulate results and errors.
/// These events will be how you will consume `UseCase`s
struct UseCaseEvent<Data, Error: Swift.Error> {
    
    /// Event status.
    let status: Status<Data, Error>
    
    /// Factory function for `loading` use case event.
    ///
    /// - Returns: Returns a UseCaseEvent with `.loading` status.
    static func loading() -> UseCaseEvent {
        return UseCaseEvent(status: .loading)
    }
    
    /// Factory function for `idle` use case event.
    ///
    /// - Returns: Returns a UseCaseEvent with `.idle` status.
    static func idle() -> UseCaseEvent {
        return UseCaseEvent(status: .idle)
    }
    
    /// Factory function for business error use case event.
    ///
    /// - Parameter error: An error that represents why the use case event failed.
    /// - Returns: Returns a UseCaseEvent with `.businessError` status.
    static func businessError(_ error: Error) -> UseCaseEvent {
        return UseCaseEvent(status: .businessError(error))
    }
    
    /// Factory function for service error.
    ///
    /// - Parameter error: An error that represents why use case event failed.
    /// - Returns: returns a UseCaseEvent with `.serviceError` status.
    static func serviceError(_ error: Swift.Error) -> UseCaseEvent {
        return UseCaseEvent(status: .serviceError(error))
    }
    
    /// Factory function for data use case event.
    ///
    /// - Parameter data: An object that represents `data`.
    /// - Returns: Returns an Event with `.data` status.
    static func data(_ data: Data) -> UseCaseEvent {
        return UseCaseEvent(status: .data(data))
    }
    
}
extension UseCaseEvent {
    
    /// Represents the different statuses that can happen to any UseCase.
    ///
    /// - idle: Nothing happened yet.
    /// - loading: Some requests started to happen.
    /// - data: Request was succeeded. The response is provided by its parameter.
    /// - error: Some error hapenned. For more information check out its parameter.
    enum Status<Data, Error: Swift.Error> {
        case idle
        case loading
        case data(Data)
        case businessError(Error)
        case serviceError(Swift.Error)
    }
    
}

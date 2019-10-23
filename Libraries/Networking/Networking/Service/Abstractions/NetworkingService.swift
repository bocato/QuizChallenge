//
//  NetworkingService.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines an API service.
public protocol NetworkingService {
    
    /// The dispatcher to take care of the network requests.
    var dispatcher: URLRequestDispatching { get }
    
    /// Intializer to inject the dispatcher.
    ///
    /// - Parameter dispatcher: The dispatcher to take care of the network requests.
    init(dispatcher: URLRequestDispatching)
}

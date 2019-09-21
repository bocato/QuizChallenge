//
//  URLRequestProtocol.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines the Request protocol, which can be implemented as a class, struct or enum.
public protocol URLRequestProtocol {
    
    /// The API's base url.
    var baseURL: URL { get }
    
    /// Defines the endpoint we want to hit.
    var path: String? { get }
    
    /// Relative to the method we want to call, which was defined with an enum above.
    var method: HTTPMethod { get }
    
    /// Parameters we want to pass with the request that can be used for the body or the URL.
    var parameters: URLRequestParameters? { get }
    
    /// Defines the list of headers we want to pass along with each request.
    var headers: [String: Any]? { get }
    
}

extension URLRequestProtocol {
    
    func build() throws -> URLRequest {
        return try URLRequestBuilder(with: baseURL, path: path)
            .set(method: method)
            .set(headers: headers)
            .set(parameters: parameters)
            .build()
    }
    
}

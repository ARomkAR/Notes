//
//  URLRequestBuilder.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// Types adopting the `URLRequestBuilder` protocol can be used to build URL requests.
protocol URLRequestBuilder {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - Returns: A URL request.
    /// - Throws: An `Error` if the unable to build `URLRequest`.
    func buildRequest() throws -> URLRequest
}

/// `URLRequestBuilderError` is the error type for `URLRequestBuilder` errors.
enum URLRequestBuilderError: Error {
    case invalidURL(String)
}

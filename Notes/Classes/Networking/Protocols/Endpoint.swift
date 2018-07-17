//
//  Endpoint.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// Endpoint protocol provides blue print for network end point
protocol Endpoint {

    /// Base or Host url
    static var base: String { get }

    /// Path
    var path: String { get }

    /// Method check `HTTPMethod`
    var method: HTTPMethod { get }

    /// Headers cehck `HTTPHeader`
    var headers: [HTTPHeader]? { get }

    /// Parameters
    var parameters: [String: Any]? { get }

    /// Supported parameter encoding check `ParameterEncoding`
    var parameterEncoding: ParameterEncoding? { get }
}

extension Endpoint {
    var parameters: [String: Any]? {
        return nil
    }

    var headers: [HTTPHeader]? {
        return nil
    }

}

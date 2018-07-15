//
//  Endpoint.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

protocol Endpoint {
    static var base: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader]? { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParameterEncoding? { get }
    func buildRequest() throws -> URLRequest
}

extension Endpoint {
    var parameters: [String: Any]? {
        return nil
    }

    var headers: [HTTPHeader]? {
        return nil
    }

}

//
//  URLRequestConvertible.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    func buildRequest() throws -> URLRequest
}

extension URLRequestConvertible where Self: Endpoint {

    func buildRequest() throws -> URLRequest {
        guard let url = URL(string: type(of: self).base) else {
            throw NotesAPIError.invalidURL
        }
        var request = URLRequest(url: url.appendingPathComponent(self.path))
        request.httpMethod = self.method.rawValue
        self.headers?.forEach({
            request.addValue($0.value, forHTTPHeaderField: $0.field)
        })
        if let parameters = self.parameters, let encoding = self.parameterEncoding {
            let encoder: RequestParameterEncoder
            let contentType: HTTPHeader
            switch encoding {
            case .json:
                contentType = HTTPHeader.contentType(.json)
                encoder = JSONParameterEncoder()

            case .url:
                contentType = HTTPHeader.contentType(.formUrlEncoded)
                encoder = FormURLParameterEncoder()
            }
            request.httpBody = try encoder.encode(parameters)
            request.setValue(contentType.value, forHTTPHeaderField: contentType.field)
        }
        return request
    }
}

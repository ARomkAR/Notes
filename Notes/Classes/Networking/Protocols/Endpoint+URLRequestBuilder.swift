//
//  Endpoint+URLRequestBuilder.swift
//  Notes
//
//  Created by Omkar khedekar on 17/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

///Extending `URLRequestBuilder` to endpoint 
extension URLRequestBuilder where Self: Endpoint {
    func buildRequest() throws -> URLRequest {
        let selfType = type(of: self)
        guard let url = URL(string: selfType.base) else {
            throw URLRequestBuilderError.invalidURL(String(describing: selfType.base))
        }
        var request = URLRequest(url: url.appendingPathComponent(self.path))

        request.httpMethod = self.method.rawValue
        request.timeoutInterval = NetworkConstants.defaultTimeout

        self.headers?.forEach({
            request.addValue($0.value, forHTTPHeaderField: $0.field)
        })

        if let parameters = self.parameters, let encoding = self.parameterEncoding {
            let encoder: RequestEncoder
            let contentType: HTTPHeader
            switch encoding {
            case .json:
                contentType = HTTPHeader.contentType(.json)
                encoder = JSONRequestEncoder()
            }
            request.httpBody = try encoder.encode(parameters)
            request.setValue(contentType.value, forHTTPHeaderField: contentType.field)
        }
        return request
    }
}

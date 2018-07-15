//
//  JSONParameterEncoder.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

struct JSONParameterEncoder: RequestParameterEncoder {

    func encode(_ parameters: [String: Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

struct FormURLParameterEncoder: RequestParameterEncoder {
    
    func encode(_ parameters: [String: Any]) throws -> Data {
        let encodedBodyString = parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
        guard let data = encodedBodyString.data(using: .utf8) else { throw NSError() as Error }
        return data
    }
}

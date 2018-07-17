//
//  RequestEncoders.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// JSON paramater encoder
struct JSONRequestEncoder: RequestEncoder {
    func encode(_ parameters: [String: Any]) throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

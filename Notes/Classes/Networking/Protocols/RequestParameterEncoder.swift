//
//  RequestParameterEncoder.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation
protocol RequestParameterEncoder {
    func encode(_ parameters: [String: Any]) throws -> Data
}

enum ParameterEncoderError: Error {

    case encodingFailed(String)
    
}

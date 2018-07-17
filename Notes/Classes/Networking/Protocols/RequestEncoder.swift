//
//  RequestEncoder.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation
/// Types adopting the `RequestEncoder` protocol can be used to encode request paramaters.
protocol RequestEncoder {

    /// Returns a encoded data or throws if an `Error` was encountered.
    ///
    /// - Parameter parameters: A paramater dictionary.
    /// - Returns: A encoded data.
    /// - Throws: An 'Error' us unable encode paramaters.
    func encode(_ parameters: [String: Any]) throws -> Data
}


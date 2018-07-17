//
//  NetworkManager.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/**
  Types adopting the `NetworkManager` are responsible for executing `URLRequestBuilder` objects, as well as their underlying `URLRequest` and `NSURLSession`.
 */
protocol NetworkManager {

    /// Executes provided `URLRequestBuilder`.
    ///
    /// - Parameters:
    ///   - request: A request of type `URLRequestBuilder`.
    ///   - completion: Completion handle.
    static func execute(request: URLRequestBuilder, then completion: @escaping (Result<Data?>) -> Void)
}

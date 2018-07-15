//
//  NetworkManager.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

protocol NetworkManager {
    static func execute(request: URLRequestConvertible, then completion: @escaping (Result<Data?>) -> Void)
}

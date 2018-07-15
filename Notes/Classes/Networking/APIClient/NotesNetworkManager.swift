//
//  NotesNetworkManager.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

final class NotesNetworkManager: NetworkManager {
    
    private typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    private static let urlSession = URLSession.shared
    
    static func execute(request: URLRequestConvertible,
                        then completion: @escaping (Result<Data?>) -> Void) {
        do {
            let urlRequest = try request.buildRequest()
            let completionHandler: URLSessionCompletionHandler = { (data, urlResponse, error) in
                if let error = error {
                    completion(.failed(error))
                    return
                }
                
                guard let response = urlResponse as? HTTPURLResponse,
                    NetworkConstants.acceptableStatusCodes.contains(response.statusCode)
                    else {
                        completion(.failed(NotesAPIError.invalidResponse))
                        return
                }
                
                completion(.success(data))
            }
            let task = self.urlSession.dataTask(with: urlRequest, completionHandler: completionHandler)
            task.resume()
        } catch let error {
            completion(.failed(error))
        }
    }
}

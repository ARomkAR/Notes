//
//  NotesNetworkManager.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation
import Reachability

enum NotesNetworkManagerError: CustomLocalizableError {
    static private let errorTitle = "NETWORK_CONNECTIVITY_ERROR_TITLE"
    static private let errorMessage = "NETWORK_ERROR_MESSAGE"

    case networkUnreachable

    var localisedTitle: String {
        return type(of: self).errorTitle.localised
    }

    var localisedMessage: String {
        return type(of: self).errorMessage.localised
    }
}

final class NotesNetworkManager: NetworkManager {
    
    private typealias URLSessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    private static let urlSession = URLSession.shared
    private static let rechability = Reachability()
    
    static func execute(request: URLRequestBuilder,
                        then completion: @escaping (Result<Data?>) -> Void) {
        guard let connectivityType = self.rechability?.connection, connectivityType != .none else {
            completion(.failed(NotesNetworkManagerError.networkUnreachable))
            return
        }
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

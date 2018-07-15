//
//  NotesAPIError.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation
enum NotesAPIError: CustomLocalizableError {
    private static let defaultTitle = "DEFAULT_ERROR_TITLE"
    private static let defaultMessage = "REQUEST_ERROR_MESSAGE"

    case invalidURL
    case invalidResponse
    case noData

    var localisedTitle: String {
        return type(of: self).defaultTitle.localised
    }

    var localisedMessage: String {
        return type(of: self).defaultMessage.localised
    }
}

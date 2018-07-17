//
//  NotesAPIError.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

 /// `NotesAPIError` is the error type returned by NotesAPI endpoint.
enum NotesAPIError: CustomLocalizableError {
    private static let defaultTitle = "DEFAULT_ERROR_TITLE"
    private static let defaultMessage = "REQUEST_ERROR_MESSAGE"

    case invalidResponse
    case noData

    var localisedTitle: String {
        return type(of: self).defaultTitle.localised
    }

    var localisedMessage: String {
        return type(of: self).defaultMessage.localised
    }
}

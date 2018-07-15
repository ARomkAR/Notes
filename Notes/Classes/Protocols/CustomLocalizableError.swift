//
//  CustomLocalizableError.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

private let defaultTitle = "DEFAULT_ERROR_TITLE"
private let defaultMessage = "DEFAULT_ERROR_MESSAGE"

protocol CustomLocalizableError: LocalizedError {
    var localisedTitle: String { get }
    var localisedMessage: String { get }
}
/*
extension NSError: CustomLocalizableError {
    var localisedTitle: String {
        return defaultTitle.localised
    }

    var localisedMessage: String {
        return self.localizedDescription
    }
}
*/

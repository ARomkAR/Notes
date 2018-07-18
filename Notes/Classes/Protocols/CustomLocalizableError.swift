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

/**
 Types adopting the `CustomLocalizableError` protocol provides user-presentable localised title message for the error.
 Message conditionaly can be retrived using `Error.localizedDescription` or can be provided by adapting error type.
*/
protocol CustomLocalizableError: LocalizedError {

    var localisedTitle: String { get }
    var localisedMessage: String { get }
}

extension CustomLocalizableError {

    var localisedMessage: String {
        return self.localizedDescription
    }
}

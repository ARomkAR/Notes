//
//  NoteValidator.swift
//  Notes
//
//  Created by Omkar khedekar on 16/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// VAlidated note
enum NoteValidator {

    /// Vallidation error
    enum Error: CustomLocalizableError {

        static private let validationErrorTitle = "NOTE_VALIDATION_ERROR"
        static private let validationErrorMessage = "NOTE_VALIDATION_ERROR_MESSAGE"

        /// Note title is empty
        case emptyNote

        var localisedTitle: String {
            switch self {
            case .emptyNote:
                return type(of: self).validationErrorTitle.localised
            }
        }

        var localisedMessage: String {
            switch self {
            case .emptyNote:
                return type(of: self).validationErrorMessage.localised
            }
        }
    }

    static func validateNoteText(_ text: String?) -> Result<String> {
        guard
            let text = text,
            !text.isEmpty,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else { return .failed(NoteValidator.Error.emptyNote) }

        return .success(text)
    }
}

//
//  NoteViewModel.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

enum NoteValidationError: CustomLocalizableError {

    static private let validationErrorTitle = "NOTE_VALIDATION_ERROR"
    static private let validationErrorMessage = "NOTE_VALIDATION_ERROR_MESSAGE"

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

private enum NoteValidationState {
    case success(String)
    case failed(NoteValidationError)
}

final class NoteViewModel {
    
    enum State {
        case created
        case updated
        case deleted
        case error
        case noChange
    }

    let title: Observable<String?>
    private(set) var state: State
    private(set) var note: Note!

    init(_ note: Note?) {
        self.note = note
        self.title = Observable(note?.title)
        self.state = note == nil ? .created : .noChange
    }
}

extension NoteViewModel {

    typealias CompletionHandler = (Result<Note>) -> Void

    func create(then completion: CompletionHandler?) {
        let validationState = self.validateNoteText(self.title.value)
        switch validationState {
        case .success(let title):

            let completionhandler: (Result<Note>) -> Void = { result in
                switch result {
                case .success(let newNote):
                    self.note = newNote
                    self.title.value = newNote.title
                    self.state = .created
                    completion?(.success(newNote))
                case .failed(let error):
                    completion?(.failed(error))
                }
            }
            NotesAPIClient.careateNote(withTitle: title,
                                       using: NotesNetworkManager.self,
                                       then: completionhandler)
        case .failed(let error):
            completion?(.failed(error))
        }
    }

    func update(then completion: CompletionHandler?) {
        let validationState = self.validateNoteText(self.title.value)
        switch validationState {
        case .success(let title):
            guard let note = self.note else { return }
            let completionhandler: (Result<Note>) -> Void = { result in
                switch result {
                case .success(let note):
                    self.state = .updated
                    completion?(.success(note))
                case .failed(let error):
                    completion?(.failed(error))

                }
            }
            NotesAPIClient.updateNote(note: Note(id: note.id, title: title),
                                      using: NotesNetworkManager.self,
                                      then: completionhandler)
        case .failed(let error):
            completion?(.failed(error))
        }
    }

    func delete(then completion: CompletionHandler?) {
        guard let note = self.note else { return }
        let completionhandler: (Result<Note>) -> Void = { result in
            switch result {
            case .success(let note):
                self.state = .deleted
                completion?(.success(note))
            case .failed(let error):
                completion?(.failed(error))

            }
        }
        NotesAPIClient.deleteNote(note: note,
                                  using: NotesNetworkManager.self,
                                  then: completionhandler)
    }

    private func validateNoteText(_ text: String?) -> NoteValidationState {
        guard
            let text = text,
            !text.isEmpty,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else { return .failed(NoteValidationError.emptyNote) }

        return .success(text)
    }
}

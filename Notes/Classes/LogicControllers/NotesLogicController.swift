//
//  NotesLogicController.swift
//  Notes
//
//  Created by Omkar khedekar on 16/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/**
 `NotesLogicController` is responsible for handling all data related logic.
 Including data validation, retrival and emits `NotesLogicController.State` upon completion which is then supposed to be handled by underling hadler.
 */
final class NotesLogicController {

    /// States
    ///
    /// - loading: Loading data.
    /// - available: List of notes are available.
    /// - created: New note created.
    /// - updated: Note is updated.
    /// - deleted: Note is deleted.
    /// - failed: Operation failed.
    enum State {
        case loading(String)
        case available([Note])
        case created(Note)
        case updated(Note)
        case deleted(Note)
        case failed(Error)
    }

    typealias Completion = (State) -> Void

    /// Fetch availble notes from server.
    ///
    /// - Parameter handle: Completion handle.
    func fetch(then handle: @escaping Completion) {

        let completion: (Result<[Note]>) -> Void = { result in
            switch result {
            case .success(let notes):
                let sortedNotes = notes.sorted(by: { $0.id > $1.id })
                handle(.available(sortedNotes))
            case .failed(let error):
                handle(.failed(error))
            }
        }

        NotesAPIClient.getNotes(using: NotesNetworkManager.self, then: completion)
    }

    /// Create new note.
    ///
    /// - Parameters:
    ///   - title: Title for note.
    ///   - handle: Completion handle
    func create(with title: String?, then handle: @escaping Completion) {

        let validationState = NoteValidator.validateNoteText(title)

        switch validationState {
        case .success(let title):

            let completionhandler: (Result<Note>) -> Void = { result in
                switch result {
                case .success(let newNote):
                    handle(.created(newNote))
                case .failed(let error):
                    handle(.failed(error))
                }
            }
            NotesAPIClient.careateNote(withTitle: title,
                                       using: NotesNetworkManager.self,
                                       then: completionhandler)
        case .failed(let error):
            handle(.failed(error))
        }
    }

    /// Updates existing note.
    ///
    /// - Parameters:
    ///   - note: Note to update.
    ///   - handle: Completion handle
    func update(_ note: Note, then handle: @escaping Completion) {
        let validationState = NoteValidator.validateNoteText(note.title)

        switch validationState {
        case .success(let title):
            let completionhandler: (Result<Note>) -> Void = { result in
                
                switch result {
                case .success(let note):
                    handle(.updated(note))

                case .failed(let error):
                    handle(.failed(error))
                }
            }

            NotesAPIClient.updateNote(note: Note(id: note.id, title: title),
                                      using: NotesNetworkManager.self,
                                      then: completionhandler)
        case .failed(let error):
            handle(.failed(error))
        }
    }

    /// Delets provided note
    ///
    /// - Parameters:
    ///   - note: Note to delete.
    ///   - handle: Completion handle
    func delete(_ note: Note, then handle: @escaping Completion) {
        let complation: (Result<Note>) -> Void = {  result in
            switch result {
            case .success(let note):
                handle(.deleted(note))
            case .failed(let error):
                handle(.failed(error))
            }
        }

        NotesAPIClient.deleteNote(note: note, using: NotesNetworkManager.self, then: complation)
    }
}

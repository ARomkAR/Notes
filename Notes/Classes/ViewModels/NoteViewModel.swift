//
//  NoteViewModel.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

final class NoteViewModel {
    
    enum State {
        case new
        case edited
        case deleted
        case saved
    }

    let title: Observable<String>
    let state: Observable<State>
    private(set) var note: Note

    init(_ note: Note?) {
        let state: State = note == nil ? .new : .saved
        self.note = note ?? Note(id: Int.min, title: "")
        self.title = Observable(self.note.title)
        self.state = Observable(state)
        self.title.bind({ [unowned self] change in
            if self.state.value != .new, change.oldValue != change.newValue {
                self.state.value = .edited
            }
        })
    }
}

extension NoteViewModel {

    func update(then completion: ((Result<Note>) -> Void)?) {

        let completionhandler: (Result<Note>) -> Void = { result in
            if case .success = result {
                self.state.value = .saved
            }
            completion?(result)
        }

        switch self.state.value {
        case .new:
            NotesAPIClient.careateNote(withTitle: self.title.value,
                                       using: NotesNetworkManager.self,
                                       then: completionhandler)
        case .edited:
            NotesAPIClient.updateNote(note: self.note,
                                      using: NotesNetworkManager.self,
                                      then: completionhandler)
        case .deleted:
            NotesAPIClient.deleteNote(note: self.note,
                                      using: NotesNetworkManager.self,
                                      then: completionhandler)
        case .saved: return
        }
    }

}

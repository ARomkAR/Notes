//
//  NotesAPIClient.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

private func performOnMain(_ workItem: () -> Void) {
    if Thread.isMainThread {
        workItem()
    } else {
        DispatchQueue.main.sync {
            workItem()
        }
    }
}

final class NotesAPIClient {
    
    static func getNotes<Manager: NetworkManager>(using manager: Manager.Type, then completion: @escaping (Result<[Note]>) -> Void) {
        manager.execute(request: NotesEndpoint.allNotes) { result in
            
            let resultToSend: Result<[Note]>
            
            switch result {
            case .success(let json):
                do {
                    let notes = try self.parse([Note].self, from: json)
                    resultToSend = .success(notes)
                } catch let error {
                    resultToSend = .failed(error)
                }
            case .failed(let error):
                resultToSend = .failed(error)
            }
            
            performOnMain {
                completion(resultToSend)
            }
        }
    }
    
    static func getNoteDetails<Manager: NetworkManager>(withID id: Int,
                                                        using manager: Manager.Type,
                                                        then completion: @escaping (Result<Note>) -> Void) {
        manager.execute(request: NotesEndpoint.note(id)) { result in
            
            let resultToSend: Result<Note>
            
            switch result {
            case .success(let json):
                do {
                    let note = try self.parse(Note.self, from: json)
                    resultToSend = .success(note)
                } catch let error {
                    resultToSend = .failed(error)
                }
            case .failed(let error):
                resultToSend = .failed(error)
            }
            
            performOnMain {
                completion(resultToSend)
            }
        }
    }
    
    static func careateNote<Manager: NetworkManager>(withTitle title: String,
                                                     using manager: Manager.Type,
                                                     then completion: @escaping (Result<Note>) -> Void) {
        manager.execute(request: NotesEndpoint.create(title)) { result in
            
            let resultToSend: Result<Note>
            
            switch result {
            case .success(let json):
                do {
                    let note = try self.parse(Note.self, from: json)
                    resultToSend = .success(note)
                } catch let error {
                    resultToSend = .failed(error)
                }
            case .failed(let error):
                resultToSend = .failed(error)
            }
            
            performOnMain {
                completion(resultToSend)
            }
        }
    }
    
    static func updateNote<Manager: NetworkManager>(note: Note,
                                                    using manager: Manager.Type,
                                                    then completion: @escaping (Result<Note>) -> Void) {
        
        manager.execute(request: NotesEndpoint.update(note.id, note.title)) { result in
            
            let resultToSend: Result<Note>
            
            switch result {
            case .success(let json):
                do {
                    let note = try self.parse(Note.self, from: json)
                    resultToSend = .success(note)
                } catch let error {
                    resultToSend = .failed(error)
                }
            case .failed(let error):
                resultToSend = .failed(error)
            }
            
            performOnMain {
                completion(resultToSend)
            }
        }
    }
    
    static func deleteNote<Manager: NetworkManager>(note: Note,
                                                    using manager: Manager.Type,
                                                    then completion: @escaping (Result<Note>) -> Void) {
        manager.execute(request: NotesEndpoint.delete(note.id)) { result in
            let resultToSend: Result<Note>
            switch result {
            case .success:
                resultToSend = .success(note)
            case .failed(let error):
                resultToSend = .failed(error)
            }
            
            performOnMain {
                completion(resultToSend)
            }
        }
    }
    
    private static func parse<T: Decodable>(_ : T.Type, from data: Data?) throws -> T {
        guard let json = data else { throw NotesAPIError.noData }
        return try JSONDecoder().decode(T.self, from: json)
    }
}

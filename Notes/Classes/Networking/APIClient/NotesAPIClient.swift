//
//  NotesAPIClient.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/**
 `NotesAPIClient` is responsible for handling all communcation with notes api with provided network manager
 as well as serializing results based on request response and requesters requirement.
 */
final class NotesAPIClient {

    /// Retrives all notes.
    ///
    /// - Parameters:
    ///   - manager: A `NetworkManager`
    ///   - completion: Completion handle
    static func getNotes<Manager: NetworkManager>(using manager: Manager.Type,
                                                  then completion: @escaping (Result<[Note]>) -> Void) {
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

    /// Retrives details for single note with given `id` if present.
    ///
    /// - Parameters:
    ///   - id: An `id` for which details to be retrived.
    ///   - manager: A `NetworkManager`
    ///   - completion: A callback handle to be invoked on completion.
    static func getNoteDetails<Manager: NetworkManager>(withID id: Int,
                                                        using manager: Manager.Type,
                                                        then completion: @escaping (Result<Note>) -> Void) {
        manager.execute(request: NotesEndpoint.noteDetails(id)) { result in
            
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
    
    /// Create new note with provided title.
    ///
    /// - Parameters:
    ///   - title: A title.
    ///   - manager: A `NetworkManager`
    ///   - completion: A callback handle to be invoked on completion.
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
    
    /// Updates provided `Note`.
    ///
    /// - Parameters:
    ///   - note: A `note` to be updated.
    ///   - manager: A `NetworkManager`
    ///   - completion: A callback handle to be invoked on completion.
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
    
    /// Deletes provided `Note`.
    ///
    /// - Parameters:
    ///   - note: A `note` to be deleted.
    ///   - manager: A `NetworkManager`
    ///   - completion: A callback handle to be invoked on completion.
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

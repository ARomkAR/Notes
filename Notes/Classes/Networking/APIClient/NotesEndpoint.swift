//
//  NotesEndpoint.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// Responsible for managing the endpoints of Notes API.
enum NotesEndpoint: Endpoint, URLRequestBuilder {

    // Path fragment
    private static let notesPathFragment = "notes"
    // Title parameter keys
    private static let titleParameterKey = "title"

    // Retrives All notes
    case allNotes

    // Retrives details for provided `id`
    case note(Int)

    // Creates new note with provided `title`
    case create(String)

    // Updates note of given `id` with provided title.
    case update(Int, String)

    // Deletes note of provided `id`.
    case delete(Int)

    static var base: String {
        return NetworkConstants.baseURLString
    }

    var path: String {
        func pathWithNoteID(id: Int) -> String {
            return "\(type(of: self).notesPathFragment)/\(id)"
        }
        switch self {
        case .allNotes, .create:
            return type(of: self).notesPathFragment
        case .note(let id):
            return pathWithNoteID(id: id)
        case .update(let id, _), .delete(let id):
            return pathWithNoteID(id: id)
        }
    }

    var method: HTTPMethod {
        switch self {
        case .allNotes, .note:
            return .get
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }

    var headers: [HTTPHeader]? {
        switch self {
        case .create, .update:
            return [HTTPHeader.contentType(.json)]
        default:
            return nil
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .create(let title):
            return [type(of: self).titleParameterKey: title]
        case .update(_, let title):
            return [type(of: self).titleParameterKey: title]
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding? {
        switch self {
        case .create, .update:
            return .json
        default:
            return nil
        }
    }
}

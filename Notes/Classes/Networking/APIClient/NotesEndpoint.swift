//
//  NotesEndpoint.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

enum NotesEndpoint: Endpoint, URLRequestConvertible {

    private static let notesPathFragment = "notes"
    private static let titleParameterKey = "title"

    case allNotes
    case note(Int)
    case create(String)
    case update(Int, String)
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

//
//  Note.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

struct Note: Decodable, Equatable {
    let id: Int
    let title: String

    static func == (lhs: Note, rhs: Note) -> Bool {
        return (lhs.id == rhs.id) && (lhs.title == rhs.title)
    }
}

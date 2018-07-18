//
//  NotesTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 13/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class NoteTests: XCTestCase {

    func testNoteDecoading() {
        guard let validTestJSON  = "{\"id\": 1, \"title\": \"title\"}".data(using: .utf8) else {
            XCTFail("Unable to create data")
            return
        }
        XCTAssertNotNil(validTestJSON)
        let expectedNote = Note(id: 1, title: "title")
        let note = try? JSONDecoder().decode(Note.self, from: validTestJSON)
        XCTAssertNotNil(note)
        XCTAssertEqual(note?.title, "title")
        XCTAssertEqual(note?.id, 1)
        XCTAssertEqual(note, expectedNote)
    }
}

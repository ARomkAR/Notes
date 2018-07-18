//
//  NoteValidatorTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 18/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class NoteValidatorTests: XCTestCase {
    func testValidNoteTitle() {
        let result = NoteValidator.validateNoteText("valid")
        XCTAssertEqual(result, .success("valid"))
    }

    func testEmptyNoteTitle() {
        let result = NoteValidator.validateNoteText("")
        XCTAssertEqual(result, .failed(NoteValidator.Error.emptyNote))
    }

    func testNilNoteTitle() {
        let result = NoteValidator.validateNoteText(nil)
        XCTAssertEqual(result, .failed(NoteValidator.Error.emptyNote))
    }
}

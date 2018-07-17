//
//  NotesEndpointTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 17/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class NotesEndpointTests: XCTestCase {

    func testBaseURL() {
        XCTAssertEqual(NotesEndpoint.base, NetworkConstants.baseURLString)
        XCTAssertNotNil(URL(string: NotesEndpoint.base))
    }

    func testAllNotesEndPoint() {
        let getAllNotes = NotesEndpoint.allNotes
        XCTAssertEqual(getAllNotes.path, NotesEndpoint.notesPathFragment)
        XCTAssertEqual(getAllNotes.method, .get)
        XCTAssertNil(getAllNotes.headers)
        XCTAssertNil(getAllNotes.parameters)
        XCTAssertNil(getAllNotes.parameterEncoding)
        guard let request = try? getAllNotes.buildRequest() else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.url?.absoluteString, "\(NotesEndpoint.base)/\(getAllNotes.path)")
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertNil(request.httpBody)

    }

    func testNoteDetailsEndPoint() {
        let testNoteID = 1
        let noteDetails = NotesEndpoint.noteDetails(testNoteID)
        let exptectedPath = "\(NotesEndpoint.notesPathFragment)/\(testNoteID)"

        XCTAssertEqual(noteDetails.path, exptectedPath)
        XCTAssertEqual(noteDetails.method, .get)
        XCTAssertNil(noteDetails.headers)
        XCTAssertNil(noteDetails.parameters)
        XCTAssertNil(noteDetails.parameterEncoding)

        guard let request = try? noteDetails.buildRequest() else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.url?.absoluteString, "\(NotesEndpoint.base)/\(exptectedPath)")
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertNil(request.httpBody)

    }

    func testCreateNoteEndPoint() {
        let testNoteTitle = "test"
        let createNote = NotesEndpoint.create(testNoteTitle)
        let expectedHeaders = [HTTPHeader.contentType(.json)]
        let exptectedPath = "\(NotesEndpoint.notesPathFragment)"
        let expectedParameters = [NotesEndpoint.titleParameterKey: testNoteTitle]
        let exptectedRequestBodyString = "{\"\(NotesEndpoint.titleParameterKey)\":\"\(testNoteTitle)\"}"

        XCTAssertEqual(createNote.path, exptectedPath)
        XCTAssertEqual(createNote.method, .post)
        XCTAssertTrue(expectedHeaders == createNote.headers)

        guard let parameters = createNote.parameters as? [String: String] else {
            XCTFail("Create endpoint must have parameters [\"title\": <string title>]")
            return
        }
        XCTAssertEqual(parameters, expectedParameters)
        XCTAssertTrue(createNote.parameterEncoding == .json)

        guard let request = try? createNote.buildRequest() else {
            XCTFail()
            return
        }

        XCTAssertEqual(request.url?.absoluteString, "\(NotesEndpoint.base)/\(exptectedPath)")
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
        self.varifyBody(in: request, expectedBodyAsString: exptectedRequestBodyString)
        self.varifyContentTypeJSONHeader(in: request)
    }

    func testUpdateNoteEndPoint() {
        let testNoteID = 1
        let testNoteTitle = "test"
        let noteUpdate = NotesEndpoint.update(testNoteID, testNoteTitle)
        let expectedHeaders = [HTTPHeader.contentType(.json)]
        let exptectedPath = "\(NotesEndpoint.notesPathFragment)/\(testNoteID)"
        let expectedParameters = [NotesEndpoint.titleParameterKey: testNoteTitle]
        let exptectedRequestBodyString = "{\"\(NotesEndpoint.titleParameterKey)\":\"\(testNoteTitle)\"}"

        XCTAssertEqual(noteUpdate.path, exptectedPath)
        XCTAssertEqual(noteUpdate.method, .put)
        XCTAssertTrue(expectedHeaders == noteUpdate.headers)
        guard let parameters = noteUpdate.parameters as? [String: String] else {
            XCTFail("Update endpoint must have parameters [\"title\": <string title>]")
            return
        }
        XCTAssertEqual(parameters, expectedParameters)
        XCTAssertTrue(noteUpdate.parameterEncoding == .json)

        guard let request = try? noteUpdate.buildRequest() else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.url?.absoluteString, "\(NotesEndpoint.base)/\(exptectedPath)")
        XCTAssertEqual(request.httpMethod, HTTPMethod.put.rawValue)
        self.varifyBody(in: request, expectedBodyAsString: exptectedRequestBodyString)
       self.varifyContentTypeJSONHeader(in: request)
    }

    func testDeleteNoteEndPoint() {
        let testNoteID = 1
        let deleteNote = NotesEndpoint.delete(testNoteID)
        let exptectedPath = "\(NotesEndpoint.notesPathFragment)/\(testNoteID)"

        XCTAssertEqual(deleteNote.path, exptectedPath)
        XCTAssertEqual(deleteNote.method, .delete)
        XCTAssertNil(deleteNote.headers)
        XCTAssertNil(deleteNote.parameters)
        XCTAssertNil(deleteNote.parameterEncoding)

        guard let request = try? deleteNote.buildRequest() else {
            XCTFail()
            return
        }
        XCTAssertEqual(request.url?.absoluteString, "\(NotesEndpoint.base)/\(exptectedPath)")
        XCTAssertEqual(request.httpMethod, HTTPMethod.delete.rawValue)
        XCTAssertNil(request.httpBody)

    }

    private func varifyBody(in request: URLRequest, expectedBodyAsString: String) {
        guard let httpBody = request.httpBody else {
            XCTFail("Request body should not be nil")
            return
        }

        guard let stringBody = String(bytes: httpBody, encoding: .utf8) else {
            XCTFail("Request body should be \(expectedBodyAsString)")
            return
        }
        XCTAssertEqual(stringBody, expectedBodyAsString)
    }

    private func varifyContentTypeJSONHeader(in request: URLRequest) {
        let failureMessage = "Request header should contain 'Content-Type' header with 'application/json'"
        guard let value = request.value(forHTTPHeaderField: CommonHeaderFields.contentType.rawValue) else {
            XCTFail(failureMessage)
            return
        }
        XCTAssertEqual(value, ContentType.json.rawValue)
    }
}

//
//  ResultTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 18/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class ResultTests: XCTestCase {
    func testResultSuccessEquality() {
        let someStringResult = Result.success("Some String")
        let anotherStringResultWithSameString = Result.success("Some String")
        XCTAssertEqual(someStringResult, anotherStringResultWithSameString)
        let anotherStringResultWithDiffrentString = Result.success("Some another String")
        XCTAssertNotEqual(anotherStringResultWithDiffrentString, someStringResult)
    }

    func testResultFailureEquality() {

        let noDataError: Result<String> = Result.failed(NotesAPIError.noData)
        let invalidResponseError: Result<String> = Result.failed(NotesAPIError.invalidResponse)
        XCTAssertNotEqual(noDataError, invalidResponseError)
    }
}

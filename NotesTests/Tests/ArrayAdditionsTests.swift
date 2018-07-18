//
//  ArrayAdditionsTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 18/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class ArrayAdditionsTests: XCTestCase {

    func testArrayRemoveExistingElement() {
        var testIntArray = [1, 2, 3, 4]
        let initialCount = testIntArray.count
        let index = testIntArray.remove(element: 1)
        XCTAssertNotNil(index)
        XCTAssertEqual(index, 0)
        XCTAssertEqual(testIntArray.count, initialCount - 1)
    }

    func testArrayRemoveNonExistingElement() {
        var testIntArray = [1, 2, 3, 4]
        let initialCount = testIntArray.count
        let index = testIntArray.remove(element: 10)
        XCTAssertNil(index)
        XCTAssertEqual(testIntArray.count, initialCount)
    }
}

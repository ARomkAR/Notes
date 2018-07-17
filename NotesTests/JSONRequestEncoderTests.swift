//
//  JSONRequestEncoderTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 17/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

class JSONRequestEncoderTests: XCTestCase {
    
    func testJSONRequestEncoder() {
        let jsonRequestEncoder = JSONRequestEncoder()
        XCTAssertNotNil(try? jsonRequestEncoder.encode([:]))
        XCTAssertNotNil(try? jsonRequestEncoder.encode(["test key": 1]))
        XCTAssertNotNil(try? jsonRequestEncoder.encode(["test key": "1"]))
        XCTAssertNotNil(try? jsonRequestEncoder.encode(["test key": [1, 2, 3]]))
    }
}

//
//  EndpointTests.swift
//  NotesTests
//
//  Created by Omkar khedekar on 17/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import XCTest
@testable import Notes

enum DummyEndpoint: Endpoint {

    case avengersMansion

    static var base: String {
        return "marvelUnivarse"
    }

    var path: String {
        switch self {
        case .avengersMansion:
            return "avengersMansion"
        }
    }

    var method: HTTPMethod {
        return .get
    }

    var parameterEncoding: ParameterEncoding? {
        return nil
    }


}

class EndpointTests: XCTestCase {
    func testEndpoint() {
        let endPoint = DummyEndpoint.avengersMansion
        XCTAssertEqual(DummyEndpoint.base, "marvelUnivarse")
        XCTAssertEqual(endPoint.path, "avengersMansion")
        XCTAssertEqual(endPoint.method, .get)
        XCTAssertNil(endPoint.headers)
        XCTAssertNil(endPoint.parameters)
        XCTAssertNil(endPoint.parameterEncoding)
    }
}

//
//  Result.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

/**
Used to represent state of an operation or process.
 - success: The operation is successful and has provided associated value.
 - failed: The operation has failed and has resulted in error.
*/
import Foundation

enum Result<T> {
    case success(T)
    case failed(Error)
}

extension Result: Equatable where T: Equatable {
    static func == (lhs: Result<T>, rhs: Result<T>) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsValue), .success(let rhsValue)):
            return lhsValue == rhsValue

        case (.failed(let lhsError), .failed(let rhsError)):
            return ((lhsError as NSError).isEqual((rhsError as NSError)))

        default:
            return false
        }

    }
}

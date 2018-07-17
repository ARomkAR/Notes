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
enum Result<T> {
    case success(T)
    case failed(Error)
}

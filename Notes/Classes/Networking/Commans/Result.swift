//
//  Result.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

enum Result<T> {
    case success(T)
    case failed(Error)
}

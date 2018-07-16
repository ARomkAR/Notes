//
//  AssociatedObject.swift
//  Notes
//
//  Created by Omkar khedekar on 16/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

func objc_getAssociatedObject<T>(_ object: Any!, _ key: UnsafeRawPointer!, defaultValue: T) -> T {
    guard let value = objc_getAssociatedObject(object, key) as? T else {
        return defaultValue
    }
    return value
}

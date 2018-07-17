//
//  AssociatedObject.swift
//  Notes
//
//  Created by Omkar khedekar on 16/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/**
Generic wrapper for `objc_getAssociatedObject` which returns the value associated with a given object for a given key in provided type

 - Parameters:
   - object: The source object for the association.
   - key: The key for the association.
   - defaultValue: The default value if stored value is not present or not of provided type.
 - Returns: The value associated with the `key` for `object` of provided type.
 */
func objc_getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer!, defaultValue: T) -> T {
    guard let value = objc_getAssociatedObject(object, key) as? T else {
        return defaultValue
    }
    return value
}

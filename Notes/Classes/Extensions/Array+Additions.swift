//
//  Array+Additions.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    /// Removes provided element from array if present.
    ///
    /// - Parameter element: element to be removed.
    /// - Returns: Index of removed object.
    @discardableResult mutating func remove(element: Element) -> Int? {
        if let indexToRemove = self.index(of: element) {
            self.remove(at: indexToRemove)
            return indexToRemove
        }
        return nil
    }
}

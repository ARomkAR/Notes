//
//  Array+Additions.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    @discardableResult mutating func remove(element: Element) -> Element? {
        if let indexToRemove = self.index(of: element) {
            return self.remove(at: indexToRemove)
        }
        return nil
    }
}

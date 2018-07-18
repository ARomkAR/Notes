//
//  ReusableView.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var defaultReuseIdentifier: String { get }
}

extension Reusable where Self: UIViewController {

    /// Provides default reuase identifier for view controller instance
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

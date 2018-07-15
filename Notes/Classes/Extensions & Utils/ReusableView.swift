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

extension Reusable where Self: UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension Reusable where Self: UIViewController {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

protocol NibLoadable: class {
    static var nibFile: UINib { get }
}

extension NibLoadable where Self: UITableViewCell {

    static var nibFile: UINib {
        let nibName = String(describing: self.classForCoder())
        return UINib(nibName: nibName, bundle: nil)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
        self.register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func register<T: UITableViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
        self.register(T.nibFile, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
}

//
//  Observable.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

struct Change<T> {
    let oldValue: T
    let newValue: T
}

final class Observable<T> {
    typealias Observer = (Change<T>) -> Void

    var observer: Observer?

    func bind(_ observer: Observer?) {
        self.observer = observer
    }

    func bindAndFire(_ observer: Observer?) {
        self.observer = observer
        self.observer?(Change(oldValue: self.value, newValue: self.value))
    }

    var value: T {
        didSet {
            self.observer?(Change(oldValue: oldValue, newValue: self.value))
        }
    }

    init(_ v: T, observer: Observer? = nil) {
        self.value = v
        self.observer = observer
    }
}

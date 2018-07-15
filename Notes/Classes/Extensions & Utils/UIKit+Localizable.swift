//
//  UIKit+Localised.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

extension UIViewController {
    @IBInspectable var localisedTitle: String? {
        set {
            self.title = newValue?.localised
        }
        get {
            return self.title
        }
    }
}

extension UIBarItem {
    @IBInspectable var localisedTitle: String? {
        set {
            self.title = newValue?.localised
        }
        get {
            return self.title
        }
    }
}

extension UILabel {
    @IBInspectable var localisedText: String? {
        set {
            self.text = newValue?.localised
        }
        get {
            return self.text
        }
    }
}

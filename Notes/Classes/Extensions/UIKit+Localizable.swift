//
//  UIKit+Localised.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

extension UIViewController {
    static private var associatedKey = "UIViewController.localisedTitle"

    @IBInspectable var localisedTitle: String? {
        get {
            return objc_getAssociatedObject(self, &type(of: self).associatedKey) as? String
        }
        set {
            objc_setAssociatedObject(self,
                                     &type(of: self).associatedKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            self.title = newValue?.localised
        }
    }
}

extension UIBarItem {
    static private var associatedKey = "UIBarItem.localisedTitle"
    @IBInspectable var localisedTitle: String? {
        get {
            return objc_getAssociatedObject(self, &type(of: self).associatedKey) as? String
        }
        set {
            objc_setAssociatedObject(self,
                                     &type(of: self).associatedKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            self.title = newValue?.localised
        }
    }
}

extension UILabel {
    static private var associatedKey = "UILabel.localisedText"

    @IBInspectable var localisedText: String? {
        get {
            return objc_getAssociatedObject(self, &type(of: self).associatedKey) as? String
        }
        set {
            objc_setAssociatedObject(self,
                                     &type(of: self).associatedKey,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            self.text = newValue?.localised
        }
    }
}

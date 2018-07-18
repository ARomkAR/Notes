//
//  UIViewControler+Activity.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

extension UIViewController {

    func showActivity(withTitle title: String?, andMessage message: String?) {
        ActivityIndicatorProvider.shared.showActivity(onView: self.view, withTitle: title, andMessage: message)
    }

    func hideActivity() {
        ActivityIndicatorProvider.shared.hideActivity()
    }
}

//
//  UIViewControler+Alert.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

extension UIViewController {

    static private let defaultErrorTitle = "DEFAULT_ERROR_TITLE"
    static private let okButtonTitle = "OK"

    func showError(_ error: Error) {

        let title: String
        let message: String

        let selfType = type(of: self)
        
        if let error = error as? CustomLocalizableError {
            title = error.localisedTitle
            message = error.localisedMessage
        } else {
            title = selfType.defaultErrorTitle.localised
            message = error.localizedDescription
        }

        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)

        alertViewController.addAction(UIAlertAction(title: selfType.okButtonTitle.localised,
                                                    style: .cancel,
                                                    handler: nil))
        self.present(alertViewController, animated: true, completion: nil)
    }
}

//
//  UIViewControler+Alert.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

extension UIViewController {

    func showError(_ error: CustomLocalizableError) {

        let alertViewController = UIAlertController(title: error.localisedTitle,
                                                    message: error.localisedMessage,
                                                    preferredStyle: .alert)
        self.present(alertViewController, animated: true, completion: nil)
    }
}

//
//  ActivityIndicatorProvider.swift
//  Notes
//
//  Created by Omkar khedekar on 15/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit
import MBProgressHUD

final class ActivityIndicatorProvider {

    static let shared = ActivityIndicatorProvider()
    
    private weak var activeHud: MBProgressHUD?
    
    private init () {}
    
    func showActivity(onView view: UIView,
                      withTitle title: String?,
                      andMessage message: String?) {
        performOnMain {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.label.text = title
            hud.detailsLabel.text = message
            view.bringSubview(toFront: hud)
            self.activeHud = hud
        }
    }
    
    func hideActivity() {
        performOnMain {
            self.activeHud?.hide(animated: true)
        }
    }
}

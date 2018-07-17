//
//  AppDelegate.swift
//  Notes
//
//  Created by Omkar khedekar on 13/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private static let titleTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.title as Any]

    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.customeiseAppearance()
        return true
    }

    private func customeiseAppearance() {
        let selfType = type(of: self)
        UINavigationBar.appearance().largeTitleTextAttributes = selfType.titleTextAttributes
        UINavigationBar.appearance().titleTextAttributes = selfType.titleTextAttributes
        UINavigationBar.appearance().tintColor = UIColor.title
        UIBarButtonItem.appearance().tintColor = UIColor.title
    }
}

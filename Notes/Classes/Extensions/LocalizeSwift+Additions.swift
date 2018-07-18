//
//  LocalizeSwift+Additions.swift
//  Notes
//
//  Created by Omkar khedekar on 18/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Localize_Swift

extension Localize {

    /**
     Get the default language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    class func defaultLanguageDisplayName(for language: String) -> String {
        let locale: NSLocale = NSLocale(localeIdentifier: self.defaultLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.identifier, value: language) {
            return displayName
        }
        return String()
    }
    
}

//
//  LocalisedUITextView.swift
//  Notes
//
//  Created by Omkar khedekar on 18/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit
import Localize_Swift

class LocalisedUITextView: UITextView {

    override var textInputMode: UITextInputMode? {
        let activeLanguage = Localize.currentLanguage()
        for inputMode in UITextInputMode.activeInputModes {
            if let language = inputMode.primaryLanguage {
                let localForPrimaryLanguage = Locale(identifier: language)
                if localForPrimaryLanguage.languageCode == activeLanguage {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
}

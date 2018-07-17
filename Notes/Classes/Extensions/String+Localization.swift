//
//  String+Localization.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation
import Localize_Swift

/**
    Decoupled convenience for getting localised version of string.
    As we are using Localise Swift here for dynamic localization this uses its provided localization method over NSLocalised. 
*/
extension String {
    var localised: String {
        return self.localized()
    }
}


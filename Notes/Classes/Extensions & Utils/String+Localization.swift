//
//  String+Localization.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

extension String {
    var localised: String {
        let comment: String
        #if debug
        comment = "**\(comment)**"
        #else
        comment = self
        #endif
        return NSLocalizedString(self, comment: comment)
    }
}


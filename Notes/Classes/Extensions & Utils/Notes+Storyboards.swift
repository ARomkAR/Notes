//
//  Notes+Storyboards.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"

    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue , bundle: nil)
    }
}

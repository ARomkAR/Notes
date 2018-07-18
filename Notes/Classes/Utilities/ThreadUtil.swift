//
//  ThreadUtil.swift
//  
//
//  Created by Omkar khedekar on 25/06/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import Foundation

/// Executes provided closure on main thred
///
/// - Parameter workItem: Work item closure to be executed
func performOnMain(_ workItem: () -> Void) {
    if Thread.isMainThread {
        workItem()
    } else {
        DispatchQueue.main.sync {
            workItem()
        }
    }
}

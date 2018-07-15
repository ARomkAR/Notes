//
//  NotesTableViewCell.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell, Reusable, NibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!

    func update(with viewModel: NoteViewModel) {
        self.titleLabel.text = viewModel.title.value
    }
}

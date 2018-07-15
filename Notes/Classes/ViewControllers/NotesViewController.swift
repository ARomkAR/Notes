//
//  NotesViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 13/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    private static let estimatedRowHeight: CGFloat = 50
    private var notes: [NoteViewModel]?

    @IBOutlet private weak var notesTableView: UITableView! {
        didSet {
            self.notesTableView.estimatedRowHeight = type(of: self).estimatedRowHeight
            self.notesTableView.rowHeight = UITableViewAutomaticDimension
            self.notesTableView.register(NotesTableViewCell.self)
            self.notesTableView.dataSource = self
            self.notesTableView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        NotesAPIClient.getNotes(using: NotesNetworkManager.self, then: {[weak self] res in
            switch res {
            case .success(let notes):
                self?.notes = notes.map({ NoteViewModel.init($0) })
                self?.notesTableView.reloadData()
            default:
                return
            }
        })
    }

    @IBAction private func addNewNote(_ sender: Any) {
        self.showDetails(for: nil)
    }

    private func showDetails(for viewModel: NoteViewModel?) {
        guard let detailsViewController = NoteDetailsViewController.instance(with: viewModel) else { return }
        let navigationController = UINavigationController(rootViewController: detailsViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension NotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.defaultReuseIdentifier,
                                            for: indexPath)

        if let notesCell = cell as? NotesTableViewCell,
            let note = self.notes?[indexPath.row] {
            notesCell.update(with: note)
        }
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        self.showDetails(for: self.notes?[indexPath.row])
    }
}

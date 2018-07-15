//
//  NotesViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 13/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    private static let fetchNotesActivityMessage = "FETCH_NOTES_ACTIVITY_MESSAGE"
    private static let estimatedRowHeight: CGFloat = 50
    private var notes: [NoteViewModel] = []
    private var needsRefresh = true

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchNotes()
    }

    @IBAction private func addNewNote(_ sender: Any) {
        self.showDetails(for: nil)
    }

    private func showDetails(for viewModel: NoteViewModel?) {
        guard let detailsViewController = NoteDetailsViewController.instance(with: viewModel) else { return }
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    private func fetchNotes() {
        guard self.needsRefresh else { return }

        self.showActivity(withTitle: nil, andMessage: type(of: self).fetchNotesActivityMessage.localised)

        NotesAPIClient.getNotes(using: NotesNetworkManager.self, then: { [weak self] res in
            self?.needsRefresh = false
            switch res {
            case .success(let notes):
                self?.notes = notes.map({ NoteViewModel.init($0) })
                self?.notesTableView.reloadData()
            case .failed(let error):
                self?.showError(error as CustomLocalizableError)
            }
            self?.hideActivity()
        })
    }
}

extension NotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.defaultReuseIdentifier,
                                            for: indexPath)

        if let notesCell = cell as? NotesTableViewCell {
            notesCell.update(with: self.notes[indexPath.row])
        }
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
        self.showDetails(for: self.notes[indexPath.row])
    }
}

extension NotesViewController: NoteDetailsViewControllerEventsDelegate {
    func didPerformed(event: NoteDetailsViewControllerEvent) {
        switch event {
        case .addedNewNote(let noteModel):
            self.notes.append(noteModel)
        case .deletedNote(let noteModel):
            if let index = self.notes.index(where: { $0.note.id == noteModel.note.id }) {
                self.notes.remove(at: index)
            }
        case .updatedNote( let noteModel):
            if let index = self.notes.index(where: { $0.note.id == noteModel.note.id }) {
                self.notes.insert(noteModel, at: index)
            }
            return
        }
        self.notesTableView.reloadData()
    }
}

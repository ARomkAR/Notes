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
    private static let deleteNoteActivityMessage = "DELETE_NOTE_ACTIVITY_MESSAGE"
    private static let deleteActionTitle = "Delete"

    private static let estimatedRowHeight: CGFloat = 50

    private var notes: [Note] = []
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
        if self.needsRefresh {
            self.fetchNotes()
        } else {
            self.notesTableView.reloadData()
        }
    }

    @IBAction private func addNewNote(_ sender: Any) {
        self.showDetails(for: nil)
    }

    private func showDetails(for viewModel: NoteViewModel?) {
        guard let detailsViewController = NoteDetailsViewController.instance(with: viewModel) else { return }
        detailsViewController.eventsDelegate = self
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    private func fetchNotes() {

        self.showActivity(withTitle: nil, andMessage: type(of: self).fetchNotesActivityMessage.localised)
        NotesAPIClient.getNotes(using: NotesNetworkManager.self,
                                then: { [weak self] result in
            self?.needsRefresh = false
            switch result {
            case .success(let notes):
                self?.notes = notes
                self?.notesTableView.reloadData()
            case .failed(let error):
                self?.showError(error)
            }
            self?.hideActivity()
        })
    }

    private func delete(note: Note) {
        self.showActivity(withTitle: nil, andMessage: type(of: self).deleteNoteActivityMessage.localised)
        NotesAPIClient.deleteNote(note: note,
                                  using: NotesNetworkManager.self,
                                  then: { [weak self] result in
            self?.needsRefresh = false
            if case .failed(let error) = result {
                self?.showError(error)
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
            let viewModel = NoteViewModel(self.notes[indexPath.row])
            notesCell.update(with: viewModel)
        }
        return cell
    }
}

extension NotesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = NoteViewModel(self.notes[indexPath.row])
        self.showDetails(for: viewModel)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: type(of: self).deleteActionTitle) { (action, indexPath) in
            let noteToDelete = self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delete(note: noteToDelete)
        }
        return [delete]
    }
}

extension NotesViewController: NoteDetailsViewControllerEventsDelegate {
    func didPerformed(event: NoteDetailsViewControllerEvent) {
        switch event {
        case .addedNewNote(let note):
            self.notes.append(note)
        case .updatedNote(let note):
            if let index = self.notes.index(where: { $0.id == note.id }) {
                self.notes[index] = note
            }
        case .deletedNote(let removedNote):
            if let index = self.notes.index(of: removedNote) {
                self.notes.remove(at: index)
            }
        }
    }
}

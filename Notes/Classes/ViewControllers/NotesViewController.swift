//
//  NotesViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 13/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit
import Localize_Swift

class NotesViewController: UIViewController {
    // MARK:- Constants
    private static let fetchNotesActivityMessage = "FETCH_NOTES_ACTIVITY_MESSAGE"
    private static let deleteNoteActivityMessage = "DELETE_NOTE_ACTIVITY_MESSAGE"
    private static let deleteActionTitle = "DELETE"
    private static let changeLanguageTitle = "CHANGE_LANGUAGE_TITLE"
    private static let changeLanguageCancelButtonTitle = "CANCEL"
    private static let refreshControlTitle = "PULL_DOWN_REFRESH_TITLE"
    private static let estimatedRowHeight: CGFloat = 50

    // MARK:- Private Properties
    private var notes: [Note] = []
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: type(of: self).refreshControlTitle.localised)
        control.addTarget(self,
                          action: #selector(self.refresh),
                          for: .valueChanged)
        return control
    }()
    private var dataState = DataState.notAvailable

    private lazy var changeLanguageBarButton: UIBarButtonItem = {
        let activeLanguage = Localize.currentLanguage()
        let barButton = UIBarButtonItem(title: activeLanguage,
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.changeLanguageTapped(_:)))
        return barButton
    }()

    // MARK:- Outlets
    @IBOutlet private weak var addNewNote: UIBarButtonItem!

    @IBOutlet private weak var notesTableView: UITableView! {
        didSet {
            self.notesTableView.estimatedRowHeight = type(of: self).estimatedRowHeight
            self.notesTableView.rowHeight = UITableViewAutomaticDimension
            self.notesTableView.register(NotesTableViewCell.self)
            self.notesTableView.refreshControl = self.refreshControl
            self.notesTableView.dataSource = self
            self.notesTableView.delegate = self
        }
    }

    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.upadateLocalisedText),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)

    }

    // MARK:- IBActions
    @IBAction private func addNewNote(_ sender: Any) {
        self.showDetails(for: nil)
    }

    // MARK:- Private functions
    private func configure() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = self.changeLanguageBarButton
    }

    private func showDetails(for viewModel: NoteViewModel?) {
        guard let detailsViewController = NoteDetailsViewController.instance(with: viewModel) else { return }
        detailsViewController.eventsDelegate = self
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    private func fetchNotes() {

        self.showActivity(withTitle: nil, andMessage: type(of: self).fetchNotesActivityMessage.localised)
        self.dataState = .fetching
        NotesAPIClient.getNotes(using: NotesNetworkManager.self,
                                then: { [weak self] result in
                                    switch result {
                                    case .success(let notes):
                                        self?.dataState = .fetched
                                        self?.notes = notes
                                        self?.notesTableView.reloadData()
                                    case .failed(let error):
                                        self?.dataState = .notAvailable
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
                                    self?.dataState = .reload
                                    if case .failed(let error) = result {
                                        self?.showError(error)
                                    }
                                    self?.hideActivity()
        })
    }

    private func refreshData() {
        switch self.dataState {
        case .fetched:
            self.notesTableView.reloadData()
        case.notAvailable, .reload:
            self.fetchNotes()
        case .fetching: break
        }
    }

    @objc private func refresh() {
        guard self.dataState != .fetching else { return }
        self.dataState = .reload
        self.refreshData()
        self.refreshControl.endRefreshing()
    }

    @objc private func changeLanguageTapped(_ sender: UIBarButtonItem) {
        let selfType = type(of: self)
        let actionSheet = UIAlertController(title: nil,
                                            message: selfType.changeLanguageTitle.localised,
                                            preferredStyle: .actionSheet)

        for language in Localize.availableLanguages(true) {
            let displayName = Localize.displayNameForLanguage(language)
            let handler = { (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            }
            let languageAction = UIAlertAction(title: displayName,
                                               style: .default,
                                               handler: handler)

            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: selfType.changeLanguageCancelButtonTitle.localised,
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc private func upadateLocalisedText() {
        self.refreshControl.attributedTitle = NSAttributedString(string: type(of: self).refreshControlTitle.localised)
        self.title = self.localisedTitle?.localised
        self.changeLanguageBarButton.title = Localize.currentLanguage()
        self.addNewNote.title = self.addNewNote.localisedTitle?.localised
    }
}

// MARK:- TableView Data Source
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

// MARK:- TableView Delegate
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

// MARK:- Note details view controller event delegate
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
            self.notes.remove(element: removedNote)
        }
    }
}

private extension NotesViewController {
    enum DataState {
        case fetched
        case fetching
        case notAvailable
        case reload
    }
}

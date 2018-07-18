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
    
    // MARK: - Constants
    private static let fetchNotesActivityMessage = "FETCH_NOTES_ACTIVITY_MESSAGE"
    private static let deleteNoteActivityMessage = "DELETE_NOTE_ACTIVITY_MESSAGE"
    private static let deleteActionTitle = "DELETE"
    private static let changeLanguageTitle = "CHANGE_LANGUAGE_TITLE"
    private static let changeLanguageCancelButtonTitle = "CANCEL"
    private static let refreshControlTitle = "PULL_DOWN_REFRESH_TITLE"
    private static let notesTableViewCellIdentifier = "notesTableViewCellIdentifier"
    static private let changeLanguageConfermationMessage = "CHANGE_LANGUAGE_CONFERMATION_MESSAGE"
    static private let changeLanguageConfermation = "CHANGE_LANGUAGE_CONFERMATION"
    static private let placeholder = "####"
    static private let okButtonTitle = "OK"
    private static let estimatedRowHeight: CGFloat = 50

    // MARK: - Private Properties
    private var notes: [Note] = []
    private let logicController = NotesLogicController()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: type(of: self).refreshControlTitle.localised)
        control.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return control
    }()

    private lazy var changeLanguageBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: .settings,
                                        style: UIBarButtonItemStyle.plain,
                                        target: self,
                                        action: #selector(self.changeLanguageTapped(_:)))
        return barButton
    }()

    // MARK: - Outlets
    @IBOutlet private weak var notesTableView: UITableView! {
        didSet {
            self.configureTableView()
        }
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.fetchNotes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.notesTableView.reloadData()
    }

    // MARK: - IBActions
    @IBAction private func addNewNote(_ sender: Any) {
        self.showDetails(for: nil)
    }

    // MARK: - Private functions
    private func configure() {
        self.navigationItem.rightBarButtonItem = self.changeLanguageBarButton
        self.notesTableView.backgroundColor = UIColor.background
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.upadateLocalisedText),
                                               name: NSNotification.Name(LCLLanguageChangeNotification),
                                               object: nil)
    }

    private func configureTableView() {
        let selfType = type(of: self)
        self.notesTableView.backgroundColor = UIColor.background
        self.notesTableView.estimatedRowHeight = selfType.estimatedRowHeight
        self.notesTableView.rowHeight = UITableViewAutomaticDimension
        self.notesTableView.register(UITableViewCell.self,
                                     forCellReuseIdentifier: selfType.notesTableViewCellIdentifier)
        self.notesTableView.refreshControl = self.refreshControl
        self.notesTableView.dataSource = self
        self.notesTableView.delegate = self
    }
}

// MARK: - Actions
private extension NotesViewController {

    private func showDetails(for note: Note?) {
        guard let detailsViewController = NoteDetailsViewController.instance(with: note) else { return }
        detailsViewController.eventsDelegate = self
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    private func fetchNotes() {
        self.render(.loading(type(of: self).fetchNotesActivityMessage))
        self.logicController.fetch { [weak self] state in
            self?.render(state)
        }
    }

    private func delete(note: Note) {
        self.render(.loading(type(of: self).deleteNoteActivityMessage))
        self.logicController.delete(note) { [weak self] state in
            self?.render(state)
        }
    }

    private func showLanguageChangePrompt() {
        let selfType = type(of: self)

        let actionSheet = UIAlertController(title: nil,
                                            message: selfType.changeLanguageTitle.localised,
                                            preferredStyle: .actionSheet)
        let currentLanguage = Localize.currentLanguage()

        Localize.availableLanguages(true).forEach { language in

            let defaultName = Localize.defaultLanguageDisplayName(for: language)
            let translatedName = NSLocale(localeIdentifier: language).displayName(forKey: .identifier, value: language) ?? ""
            let displayName = "\(translatedName) (\(defaultName))"
            let confirmHandle: ((UIAlertAction) -> Void)?
            if language != currentLanguage {
                confirmHandle = { _ in
                    self.showConfirmLanguagePrompt(for: language, with: displayName)
                }
            } else {
                confirmHandle = nil
            }
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: confirmHandle)

            actionSheet.addAction(languageAction)
        }

        let cancelAction = UIAlertAction(title: selfType.changeLanguageCancelButtonTitle.localised,
                                         style: .cancel,
                                         handler: nil)

        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true, completion: nil)
    }

    private func showConfirmLanguagePrompt(for language: String, with displayName: String) {
        let selfType = type(of: self)
        var message = selfType.changeLanguageConfermationMessage.localised
        message = message.replacingOccurrences(of: selfType.placeholder, with: displayName)

        let alertViewController = UIAlertController(title: nil,
                                                    message: message,
                                                    preferredStyle: .alert)

        var confirmButtonText = selfType.changeLanguageConfermation.localised
        confirmButtonText = confirmButtonText.replacingOccurrences(of: selfType.placeholder, with: displayName)

        let confirmHandler: (UIAlertAction) -> Void = { _ in
            Localize.setCurrentLanguage(language)
        }

        let confirmAction = UIAlertAction(title: confirmButtonText, style: .default, handler: confirmHandler)
        alertViewController.addAction(confirmAction)

        let cancelAction = UIAlertAction(title: selfType.changeLanguageCancelButtonTitle.localised,
                                         style: .cancel,
                                         handler: nil)
        alertViewController.addAction(cancelAction)
        self.present(alertViewController, animated: true, completion: nil)
    }

    @objc private func refresh() {
        self.refreshControl.endRefreshing()
        self.fetchNotes()
    }

    @objc private func changeLanguageTapped(_ sender: UIBarButtonItem) {
        self.showLanguageChangePrompt()
    }

    @objc private func upadateLocalisedText() {
        self.refreshControl.attributedTitle = NSAttributedString(string: type(of: self).refreshControlTitle.localised)
        self.title = self.localisedTitle?.localised
        self.changeLanguageBarButton.title = Localize.currentLanguage()
    }
}

// MARK: - State rendering
private extension NotesViewController {

    func render(_ state: NotesLogicController.State) {

        switch state {
        case .loading(let message):
            self.showActivity(withTitle: nil, andMessage: message.localised)

        case .available(let notes):
            self.hideActivity()
            self.notes = notes
            self.notesTableView.reloadData()

        case .deleted:
            self.hideActivity()

        case .failed(let error):
            self.hideActivity()
            self.showError(error)
        case .created, .details, .updated:
            break
        }
    }
}

// MARK: - TableView Data Source
extension NotesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).notesTableViewCellIdentifier,
                                                 for: indexPath)

        self.configure(cell, with: self.notes[indexPath.row])
        return cell
    }

    private func configure(_ cell: UITableViewCell, with note: Note) {
        cell.backgroundColor = .clear
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.lineBreakMode = .byTruncatingTail
        cell.textLabel?.textColor = UIColor.normalText
        cell.contentView.backgroundColor = UIColor.background
        cell.textLabel?.text = note.title
    }
}

// MARK: - TableView Delegate
extension NotesViewController: UITableViewDelegate {
    // Fix to hide header and footer space added by group table view style
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.showDetails(for: self.notes[indexPath.row])
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let actionHandler: (UITableViewRowAction, IndexPath) -> Void = { (action, indexPath) in
            let noteToDelete = self.notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.delete(note: noteToDelete)
        }

        let delete = UITableViewRowAction(style: .destructive,
                                          title: type(of: self).deleteActionTitle.localised,
                                          handler: actionHandler)
        return [delete]
    }
}

// MARK: - Note details view controller event delegate
extension NotesViewController: NoteDetailsViewControllerEventsDelegate {

    func didPerformed(event: NoteDetailsViewController.Event) {
        switch event {
        case .addedNewNote(let note):
            self.notes.insert(note, at: 0)
        case .updatedNote(let note):
            if let index = self.notes.index(where: { $0.id == note.id }) {
                self.notes[index] = note
            }
        case .deletedNote(let removedNote):
            self.notes.remove(element: removedNote)
        }
    }
}

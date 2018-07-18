//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

protocol NoteDetailsViewControllerEventsDelegate: class {

    /// Notifies event acured on view controller.
    ///
    /// - Parameter event: `NoteDetailsViewController.Event` object
    func didPerformed(event: NoteDetailsViewController.Event)
}

final class NoteDetailsViewController: UIViewController, Reusable {

    /// Activity events.
    ///
    /// - addedNewNote: Invoked when new note is created.
    /// - updatedNote: Invoked when note is updated.
    /// - deletedNote: Invoked when note is deleted.
    enum Event {
        case addedNewNote(Note)
        case updatedNote(Note)
        case deletedNote(Note)
    }

    // MARK: - Constants
    private static let newNoteLocalizationKey = "NEW_NOTE"
    private static let editNoteLocalizationKey = "NOTE"
    private static let doneButtonTitleLocalizationKey = "NOTE_DONE"
    private static let fetchDetailsActivityMessage = "FETCH_NOTE_DETAILS"
    private static let saveNoteActivityMessage = "SAVE_NOTE_ACTIVITY_MESSAGE"
    private static let deleteNoteActivityMessage = "DELETE_NOTE_ACTIVITY_MESSAGE"

    // MARK: - Private Properties
    private lazy var doneSaveBarbutton = UIBarButtonItem(title: type(of: self).doneButtonTitleLocalizationKey.localised,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(self.saveEditButtonTapped))

    private let logicController = NotesLogicController()
    private var note: Note?

    // MARK: - Outlets
    @IBOutlet private weak var noteTextView: LocalisedUITextView! {
        didSet {
            self.noteTextView.delegate = self
        }
    }

    @IBOutlet private weak var bottomToolBar: UIToolbar!

    /// Event delegate object
    weak var eventsDelegate: NoteDetailsViewControllerEventsDelegate?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addKeyboardObservers()
        if let note = self.note {
            self.render(.loading(type(of: self).fetchDetailsActivityMessage))
            logicController.fetchNoteDetails(withID: note.id, then: { [weak self] state in
                self?.render(state)
            })
        } else {
            self.noteTextView.becomeFirstResponder()
        }
    }
}

// MARK: - Public factory functions
extension NoteDetailsViewController {

    /// Returns instance from storyboard and with provided note.
    ///
    /// - Parameter note: `Note` object. Provide nil object to create new note.
    /// - Returns: `NoteDetailsViewController` instance
    static func instance(with note: Note?) -> NoteDetailsViewController? {
        let storyboard = Storyboard.main.instance
        guard let viewController = storyboard.instantiateViewController(withIdentifier: self.defaultReuseIdentifier) as? NoteDetailsViewController else {
            return nil

        }
        viewController.navigationItem.largeTitleDisplayMode = .never

        viewController.note = note
        return viewController
    }
}

// MARK: - Text view delegate
extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = self.doneSaveBarbutton
        }
    }
}

// MARK: - Configurations
private extension NoteDetailsViewController {

    func configureView() {
        self.noteTextView.backgroundColor = UIColor.background
        let selfType = type(of: self)
        if self.note == nil {
            self.localisedTitle = selfType.newNoteLocalizationKey
        } else {
            self.localisedTitle = selfType.editNoteLocalizationKey
            self.configureToolBar()
        }
        self.refreshView()
    }

    func refreshView() {
        self.noteTextView.text = self.note?.title
    }

    func configureToolBar() {
            let items = [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteNote)),
                         UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
            self.bottomToolBar.setItems(items, animated: true)
    }
}

// MARK: - Keyboard management
private extension NoteDetailsViewController {
    func addKeyboardObservers() {

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillHide,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.adjustForKeyboard),
                                       name: Notification.Name.UIKeyboardWillChangeFrame,
                                       object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {

        guard let keyboardScreenFrameValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardScreenFrameValue.cgRectValue
        let keyboardViewEndFrame = self.view.convert(keyboardScreenEndFrame, from: self.view.window)
        if notification.name == Notification.Name.UIKeyboardWillHide {
            self.noteTextView.contentInset = .zero
        } else {
            self.noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        self.noteTextView.scrollIndicatorInsets = self.noteTextView.contentInset
        self.noteTextView.scrollRangeToVisible(self.noteTextView.selectedRange)
    }
}

// MARK: - Actions
private extension NoteDetailsViewController {

    func create(with title: String?) {
        self.render(.loading(type(of: self).saveNoteActivityMessage))
        self.logicController.create(with: title, then: { [weak self] state in
            self?.render(state)
        })

    }

    @objc func deleteNote() {
        guard let note = self.note else { return }
        self.render(.loading(type(of: self).deleteNoteActivityMessage))
        self.logicController.delete(note, then: { [weak self] state in
            self?.render(state)
        })

    }

    @objc func saveEditButtonTapped() {
        self.noteTextView.resignFirstResponder()

        // If note is nil means we are creating new one otherwise update
        guard var note = self.note else {
            self.create(with: self.noteTextView.text)
            return
        }

        guard let newTitle = self.noteTextView.text, note.title != newTitle else { return }
        note.title = newTitle
        self.render(.loading(type(of: self).saveNoteActivityMessage))
        self.logicController.update(note, then: { [weak self] state in
            self?.render(state)
        })
    }
}

// MARK: - State rendering
private extension NoteDetailsViewController {

    func render(_ state: NotesLogicController.State) {

        switch state {
        case .loading(let message):
            self.showActivity(withTitle: nil, andMessage: message.localised)

        case .details(let note):
            self.note = note
            self.refreshView()
            self.hideActivity()
        case .created(let note):
            self.navigationItem.rightBarButtonItem = nil
            self.configureToolBar()
            self.eventsDelegate?.didPerformed(event: .addedNewNote(note))
            self.hideActivity()

        case .updated(let note):
            self.hideActivity()
            self.note = note
            self.refreshView()
            self.navigationItem.rightBarButtonItem = nil
            self.eventsDelegate?.didPerformed(event: .updatedNote(note))

        case .deleted(let note):
            self.hideActivity()
            self.eventsDelegate?.didPerformed(event: .deletedNote(note))
            self.navigationController?.popViewController(animated: true)

        case .failed(let error):
            self.hideActivity()
            self.showError(error)

        case .available:
            break
        }
    }
}

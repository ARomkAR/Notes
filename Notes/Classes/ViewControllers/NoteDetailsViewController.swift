//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

enum NoteDetailsViewControllerEvent {
    case addedNewNote(Note)
    case updatedNote(Note)
    case deletedNote(Note)
}

protocol NoteDetailsViewControllerEventsDelegate: class {

    func didPerformed(event: NoteDetailsViewControllerEvent)
}

final class NoteDetailsViewController: UIViewController, Reusable {

    private static let newNoteLocalizationKey = "NEW_NOTE"
    private static let editNoteLocalizationKey = "NOTE"
    private static let doneButtonTitleLocalizationKey = "NOTE_DONE"
    private static let saveNoteActivityMessage = "SAVE_NOTE_ACTIVITY_MESSAGE"
    private static let deleteNoteActivityMessage = "DELETE_NOTE_ACTIVITY_MESSAGE"

    weak var eventsDelegate: NoteDetailsViewControllerEventsDelegate?

    @IBOutlet private weak var noteTextView: UITextView! {
        didSet {
            self.noteTextView.delegate = self
        }
    }

    @IBOutlet weak var bottomToolBar: UIToolbar!

    private lazy var doneSaveBarbutton = UIBarButtonItem(title: type(of: self).doneButtonTitleLocalizationKey.localised,
                                                         style: .done,
                                                         target: self,
                                                         action: #selector(self.saveEditButtonTapped))
    private var note = NoteViewModel(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObservers()
        if self.note.state == .created {
            self.noteTextView.becomeFirstResponder()
        }
    }
}

extension NoteDetailsViewController {
    static func instance(with viewModel: NoteViewModel?) -> NoteDetailsViewController? {
        let storyboard = Storyboard.main.instance
        guard let viewController = storyboard.instantiateViewController(withIdentifier: self.defaultReuseIdentifier) as? NoteDetailsViewController else { return nil }
        viewController.navigationItem.largeTitleDisplayMode = .never
        if let viewModel = viewModel {
            viewController.note = viewModel
        }
        return viewController
    }
}

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.navigationItem.rightBarButtonItem == nil {
            self.navigationItem.rightBarButtonItem = self.doneSaveBarbutton
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.note.title.value = textView.text
    }
}

private extension NoteDetailsViewController {
    func configureView() {
        let selfType = type(of: self)
        self.localisedTitle = self.note.state == .created ? selfType.newNoteLocalizationKey
            : selfType.editNoteLocalizationKey

        if self.note.state != .created {
            self.configureToolBar()
        }
        self.noteTextView.text = self.note.title.value
    }

    func configureToolBar() {
            let items = [UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.deleteNote)),
                         UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
            self.bottomToolBar.setItems(items, animated: true)
    }

    @objc func saveEditButtonTapped() {
        self.noteTextView.resignFirstResponder()
        if self.note.state == .created {
            self.create()
        } else {
            self.update()
        }
    }
}

// MARK: Keyboard management
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

private extension NoteDetailsViewController {

    func create() {
        self.showActivity(withTitle: nil, andMessage: type(of: self).saveNoteActivityMessage.localised)
        self.note.create {[weak self] result in
            switch result {
            case .success(let note):
                self?.navigationItem.rightBarButtonItem = nil
                self?.configureToolBar()
                self?.eventsDelegate?.didPerformed(event: .addedNewNote(note))
            case .failed(let error):
                self?.showError(error)
            }
            self?.hideActivity()
        }
    }

    @objc func deleteNote() {
        self.showActivity(withTitle: nil, andMessage: type(of: self).deleteNoteActivityMessage.localised)

        self.note.delete { [weak self] result in
            switch result {
            case .success(let note):
                self?.eventsDelegate?.didPerformed(event: .deletedNote(note))
            case .failed(let error):
                self?.showError(error)
            }
            self?.hideActivity()
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func update() {
        self.showActivity(withTitle: nil, andMessage: type(of: self).saveNoteActivityMessage.localised)
        self.note.update {[weak self] result in
            switch result {
            case .success(let note):
                self?.navigationItem.rightBarButtonItem = nil
                self?.eventsDelegate?.didPerformed(event: .updatedNote(note))
            case .failed(let error):
                self?.showError(error)
            }
            self?.hideActivity()
        }
    }
}

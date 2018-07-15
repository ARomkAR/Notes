//
//  NoteDetailsViewController.swift
//  Notes
//
//  Created by Omkar khedekar on 14/07/18.
//  Copyright © 2018 Omkar khedekar. All rights reserved.
//

import UIKit

final class NoteDetailsViewController: UIViewController, Reusable {
    private static let newNoteLocalizationKey = "NEW_NOTE"
    private static let editNoteLocalizationKey = "NOTE"
    private static let doneButtonTitleLocalizationKey = "NOTE_DONE"
    private static let closeButtonTitleLocalizationKey = "NOTE_CLOSE"
    private static let saveButtonTitleLocalizationKey = "NOTE_SAVE"


    @IBOutlet private weak var noteTextView: UITextView! {
        didSet {
            self.noteTextView.delegate = self
        }
    }

    @IBOutlet weak var bottomToolBar: UIToolbar! {
        didSet {

        }
    }

    private let keyboardToolbar: UIToolbar = UIToolbar()
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
        if self.note.state.value == .new {
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
        let shouldDisplaySave = (self.note.state.value == .edited || self.note.state.value == .new)
        if shouldDisplaySave && !textView.text.isEmpty {
            self.navigationItem.rightBarButtonItem?.localisedTitle = type(of: self).saveButtonTitleLocalizationKey
        } else {
            // remove button otherwise
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}

private extension NoteDetailsViewController {
    func configureNavigationBar() {
        let selfType = type(of: self)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: selfType.closeButtonTitleLocalizationKey.localised,
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(self.closeEditButtonTapped))
    }

    func configureView() {
        let selfType = type(of: self)
        self.localisedTitle = self.note.state.value == .new ? selfType.newNoteLocalizationKey
                                                            : selfType.editNoteLocalizationKey

        self.noteTextView.text = self.note.title.value

        self.configureNavigationBar()
    }

    @objc func saveEditButtonTapped() {
        self.noteTextView.resignFirstResponder()
        if self.note.state.value == .new ||  self.note.state.value == .edited {
            self.update()
        }
    }

    @objc func closeEditButtonTapped() {
        self.noteTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
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
    func update() {
        self.note.update {[weak self] res in
            if case .success = res {
                self?.navigationItem.rightBarButtonItem = nil
            }
        }
    }
}

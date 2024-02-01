//
//  AlertControllerFactory.swift
//  NoteApp
//
//  Created by Alexey on 30.01.2024.
//

import UIKit

protocol AlertFactoryProtocol {
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController
}

final class AlertControllerFactory: AlertFactoryProtocol {
    let userAction: UserAction
    let noteTitle: String?
    
    init(userAction: UserAction, noteTitle: String?) {
        self.userAction = userAction
        self.noteTitle = noteTitle
    }
    
    func createAlert(completion: @escaping (String) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: userAction.title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let note = alertController.textFields?.first?.text else { return }
            guard !note.isEmpty else { return }
            completion(note)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "Note"
            textField.text = self?.noteTitle
        }
        
        return alertController
    }
}

// MARK: - UserAction
extension AlertControllerFactory {
    enum UserAction {
        case newNote
        case editNote
        
        var title: String {
            switch self {
            case .newNote:
                return "New Note"
            case .editNote:
                return "Edit Note"
            }
        }
    }
}

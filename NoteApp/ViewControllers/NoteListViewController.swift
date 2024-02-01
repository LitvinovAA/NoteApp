//
//  ViewController.swift
//  NoteApp
//
//  Created by Alexey on 30.01.2024.
//

import UIKit

final class NoteListViewController: UITableViewController {

    private let storageManager = StorageMagager.shared
    private let cellID = "note"
    private var noteList: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func addNewNote() {
//        showAlert(withTitle: "New Note", andMessage: "What do you want to do?")
        showAlert()
    }
    
    private func save(noteName: String) {
        storageManager.create(noteName) { [unowned self] note in
            noteList.append(note)
            tableView.insertRows(
                at: [IndexPath(row: self.noteList.count - 1, section: 0)],
                with: .automatic
            )
        }
    }

    private func fetchData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let noteList):
                self.noteList = noteList
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Setup UI
private extension NoteListViewController {
    func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Note List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [unowned self] _ in
                addNewNote()
            }
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noteList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let note = noteList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = note.title
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NoteListViewController {
    // Edit note
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = noteList[indexPath.row]
        showAlert(note: note) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Delete note
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(note)
        }
    }
}

// MARK: - Alert Controller
extension NoteListViewController {
    private func showAlert(note: Note? = nil, completion: (() -> Void)? = nil) {
        let alertFactory = AlertControllerFactory(
            userAction: note != nil ? .editNote : .newNote,
            noteTitle: note?.title
        )
        let alert = alertFactory.createAlert { [weak self] noteName in
            if let note, let completion {
                self?.storageManager.update(note, newName: noteName)
                completion()
                return
            }
            self?.save(noteName: noteName)
        }
        present(alert, animated: true)
    }
}


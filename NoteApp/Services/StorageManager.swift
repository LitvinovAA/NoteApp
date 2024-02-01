//
//  StorageManager.swift
//  NoteApp
//
//  Created by Alexey on 30.01.2024.
//

import CoreData

final class StorageMagager {
    
    static let shared = StorageMagager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ noteName: String, completion: (Note) -> Void) {
        let note = Note(context: viewContext)
        note.title = noteName
        completion(note)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }

    func update(_ note: Note, newName: String) {
        note.title = newName
        saveContext()
    }
    
    func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }
        
    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}




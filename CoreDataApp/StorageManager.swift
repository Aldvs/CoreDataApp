//
//  StorageManager.swift
//  CoreDataApp
//
//  Created by admin on 04.02.2022.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataApp")
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
    
    //MARK: - Public Properties
    func fetchData(complition: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            complition(.success(tasks))
        } catch let error {
            complition(.failure(error))
        }
    }

    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)
        task.name = taskName
        completion(task)
        saveContext()
    }
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
    func delete(_ task: Task) {
        viewContext.delete(task)
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

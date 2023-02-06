//
//  ListOfArtist.swift
//  M20
//
//  Created by Даниил Попов on 22.01.2023.
//

import UIKit
import CoreData

class ListOfArtist: UITableViewController {
    
    var ascending = UserDefaults.standard.bool(forKey: "ascending")

    private let persistentContainer = NSPersistentContainer(name: "Model")
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Artist> = {
        var fetchRequest = Artist.fetchRequest()
        var sortDescription = NSSortDescriptor(key: "name", ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescription]
        var fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        persistentContainer.loadPersistentStores { ( persistentStoreDescription, error) in
        if let error = error {
            print("Unable to Load Persistent Store")
            print("\(error), \(error.localizedDescription)")
        } else {
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print(error)
            }
        }
    }
}
    // MARK: Func View
    
    
    @IBAction func sort() {
        
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .actionSheet)

        func sortDown(alert: UIAlertAction!) {
            ascending = true
            let fetchRequest = Artist.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try? fetchedResultsController.performFetch()
            UserDefaults.standard.set(ascending, forKey: "ascending")
            tableView.reloadData()
        }
        
        func sortUp(alert: UIAlertAction!) {
            ascending = false
            let fetchRequest = Artist.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            try? fetchedResultsController.performFetch()
            UserDefaults.standard.set(ascending, forKey: "ascending")
            tableView.reloadData()
        }
        
        let sortDownButton = UIAlertAction(title: "A-Z", style: .default, handler: sortDown)
        let sortUpButton = UIAlertAction(title: "Z-A", style: .default, handler: sortUp)
        alert.addAction(sortDownButton)
        alert.addAction(sortUpButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func buttonAddAndEdit(_ sender: Any) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAndEdit") as? AddAndEdit {
            vc.artist = Artist.init(entity: NSEntityDescription.entity(forEntityName: "Artist", in: persistentContainer.viewContext)!, insertInto: persistentContainer.viewContext)
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }

    // MARK: View cell
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = recipe.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artist = fetchedResultsController.object(at: indexPath)
            persistentContainer.viewContext.delete(artist)
            try? persistentContainer.viewContext.save()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAndEdit") as? AddAndEdit {
            vc.artist = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: Extension

extension ListOfArtist: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let artist = fetchedResultsController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = artist.name
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

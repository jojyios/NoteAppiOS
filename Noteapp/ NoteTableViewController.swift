//
//  NoteTableViewController.swift
//  Noteapp
//
//  Created by Apple on 24/04/19.
//  Copyright © 2019 JP.LLC. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController {

    var managedOblectContext: NSManagedObjectContext!
    var entries: [NSManagedObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedOblectContext = appDelegate.managedObjectContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchEntries()
    }
    
    func fetchEntries(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        do{
            let entryObjects = try managedOblectContext.fetch(fetchRequest)
            self.entries = entryObjects as? [NSManagedObject]
        }catch let error as NSError{
            print("could not fetch entries \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    @IBAction func toAddNote(_ sender: Any) {
        self.performSegue(withIdentifier: "showAddNote", sender: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        // Configure the cell...
        let entry = entries[indexPath.row]
        cell.textLabel?.text = entry.value(forKey: "bodyText") as? String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let entry = self.entries[indexPath.row]
            self.managedOblectContext.delete(entry)
            self.entries.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            do{
                try self.managedOblectContext.save()
            }catch let error as NSError {
                print("cannot delete object:\(error), \(error.localizedDescription)")

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let eentry = self.entries[indexPath.row]
        self.performSegue(withIdentifier: "showAddNote", sender: eentry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddNote"{
            let noteViewController = segue.destination as! NoteAddViewController
            noteViewController.entry = sender as? NSManagedObject
        }
    }
    
}
 

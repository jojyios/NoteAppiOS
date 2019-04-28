//
//  NoteAddViewController.swift
//  Noteapp
//
//  Created by Apple on 24/04/19.
//  Copyright © 2019 JP.LLC. All rights reserved.
//

import UIKit
import CoreData

class NoteAddViewController: UIViewController {

    var managedObjectContext : NSManagedObjectContext!
    var entry: NSManagedObject!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Note"
        self.textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
        
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        if entry != nil{
            self.textView.text = entry.value(forKey: "bodyText") as? String
        }else{
            self.textView.text = ""
        }
    }
    @IBAction func doneClick(_ sender: UIBarButtonItem) {
        if entry != nil{
            self.updateEntry()
        }else{
            if textView.text != ""{
                self.createNewEntry()
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    func createNewEntry(){
       let entryEntity = NSEntityDescription.entity(forEntityName: "Entity", in:self.managedObjectContext)!
       let entryObject = NSManagedObject(entity: entryEntity, insertInto: self.managedObjectContext)
       
        entryObject.setValue(self.textView.text, forKey: "bodyText")
        entryObject.setValue(NSDate(), forKey: "createdAt")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save the new entry \(error.description)")
        }
    }
    func updateEntry(){
        entry.setValue(self.textView.text, forKey: "bodyText")
        entry.setValue(NSDate(), forKey: "createAt")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print("could not save\(error)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//  TableViewController.swift
//  ToDo
//
//  Created by Ulises Martinez on 10/29/18.
//  Copyright © 2018 Ulises Martinez. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TableViewController: UITableViewController {
 
    //var tasks: [String] =  ["task #1","task #2","task #3"]
    var tasks: [NSManagedObject] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "List", in: context)
        /*let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        //newUser.setValue("Ulises", forKey: "att")
        
        do {
            try context.save()
            //items.append(newUser)
        } catch {
            print("Failed saving")
        }*/
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "List")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "att") as! String)
            }
        } catch {
            print("Failed")
        }
        
        print(tasks.count)*/
    }
    
    /***
        RETRIEVE DATA OBJECT FROM CORE DATA
    ***/
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //print(tasks)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NEWLIST")
        
        do{
            tasks = try managedContext.fetch(fetchRequest)
        }catch let err as NSError{
            print("Failed to Fetch items", err)
        }
        //viewDidLoad()
    }
    
    /***
        HOW MANY ROW TO BE DISPLAYED
     ***/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    /***
        POPULATING CELL WITH OBJECT DATA
     ***/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCells")!
        let item = tasks[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "at") as? String
        
        return cell
    }
    
    /***
        TRANSITION TO TASK DESCRIPTION (EXTRA WORK)
     ***/
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tasks[indexPath.row])
        performSegue(withIdentifier: "taskTransition", sender: self)
    }
    
    /***
        ADDING A TASK TO THE LIST
     ***/
    @IBAction func AddingTaskToTheList(_ sender: UIBarButtonItem) {
        
        
        
        
        let alert = UIAlertController(title: "Enter", message: "Task name", preferredStyle: .alert)
        
        alert.addTextField{ (textField) in textField.text = "" }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            print("Text field: \(String(describing: textField))")

            //ADD function
            //print("add function")
            self.save((textField?.text)!)
            self.tableView.reloadData()
            
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: .default)
        
        self.present(alert, animated: true, completion: nil)
        alert.addAction(cancelAction)
    }
    
    /***
        EDIT/DELETE ACTIONS BY SWIPPING LEFT
     ***/
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let task = tasks[indexPath.row]
        let taskName = (task.value(forKey: "at"))!

        /*****
            EDIT ACTION
        *****/
        let editButton = UITableViewRowAction(style: .normal, title: "edit") { (rowAction, indexpath) in
            //print("edit clicked")
            let alert = UIAlertController(title: "Enter",
                                          message: "Task Name",
                                          preferredStyle: .alert)
            
            alert.addTextField{
                (textField) in
                textField.text = "\(taskName)"
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0]
                print("Text field: \(String(describing: textField))")
                //self.tasks.append((textField?.text)!)
                //self.tasks.remove(at: indexPath.row)
                print("Editing")
                self.save((textField?.text)!)
                self.remove(task)
                self.tableView.reloadData()
                //self.remove((textField?.text)!)
                self.tableView.reloadData()
            }))
            
            let cancelAction = UIAlertAction(title: "Cancel" , style: .default)
            
            self.present(alert, animated: true, completion: nil)
            alert.addAction(cancelAction)
        }
        
        
        /****
            DELETE ACTION
        *****/
        let deleteButton = UITableViewRowAction(style: .normal , title: "delete") { (rowAction, indexpath) in
            let alert = UIAlertController(title: "Delete",
                                          message: "Would you like to delete task?",
                                          preferredStyle: .alert)

            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
               
                self.remove(task)
                self.tableView.reloadData()
            }))
            
            let cancelAction = UIAlertAction(title: "Cancel" , style: .default)
            
            self.present(alert, animated: true, completion: nil)
            alert.addAction(cancelAction)
        }
        
        deleteButton.backgroundColor = .red
        editButton.backgroundColor = .blue
        return [editButton, deleteButton]
    }
    
    /***
        SAVING ITEM TO THE OBJECT
     ***/
    func save(_ name: String){
        let bool = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NEWLIST", in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        item.setValue(name, forKey: "at")
        item.setValue(bool, forKey: "ch")
        
        do{
            try context.save()
            tasks.append(item)
        }catch let err as NSError{
            print("Failed to save an item", err)
        }
    }
    
    /***
        REMOVING ITEM FROM OBJECT
     ***/
    func remove(_ name: NSManagedObject){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NEWLIST")
        request.returnsObjectsAsFaults = false

        if let result = try? context.fetch(request) {
                context.delete(name)
        }
        
        do {
            try context.save()
            self.viewWillAppear(true)
        } catch {
            print("Failed")
        }
    }
    
    /***
     SAVING ITEM TO THE OBJECT
     ***/
    func modifyCompleted(_ name: NSManagedObject, _ Boolean: Bool){
        let bool = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NEWLIST", in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        //print("Modifiyinh parameters")
        //print(name)
        //print(Boolean)
        let nam = name.value(forKey: "at")
        
        item.setValue(nam, forKey: "at")
        item.setValue(bool, forKey: "ch")
        
        self.remove(name)
        
        do{
            try context.save()
            //tasks.append(item)
        }catch let err as NSError{
            print("Failed to save an item", err)
        }
    }
    
    func modifyUncompleted(_ name: NSManagedObject, _ Boolean: Bool){
        let bool = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "NEWLIST", in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        //print("Modifiyinh parameters")
        //print(name)
        //print(Boolean)
        let nam = name.value(forKey: "at")
        
        item.setValue(nam, forKey: "at")
        item.setValue(bool, forKey: "ch")
        
        self.remove(name)
        
        do{
            try context.save()
            //tasks.append(item)
        }catch let err as NSError{
            print("Failed to save an item", err)
        }
    }
    
    
    // COMPLETED AND UNCOMPLETED SWIPPING ACTION
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = tasks[indexPath.row]
        let taskName = (task.value(forKey: "at"))!
        let checkTrue = true
        let checkFalse = false
        
        let CompletedTaskAction = UIContextualAction(style: .destructive, title: "Completed task") { (action,
            view, handler) in
            
            //print("Send task to Completed View Controller")
            //print("Edit")
            //print(task)
            //print(indexPath.row)
            
            let alert = UIAlertController(title: "Completed Task", message: "Would you like to add this task to completed tasks?", preferredStyle: .alert)
            
            //alert.addTextField{ (textField) in textField.text = "" }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //let textField = alert?.textFields![0]
                //print("Text field: \(String(describing: textField))")
                
                
                //ADD function
                //print("add function")
                //self.save((textField?.text)!)
                //self.tableView.reloadData()
                print("Just pressed okay")
                
                self.modifyCompleted(task, checkTrue)
                
                self.tableView.reloadData()
                
            }))
            
            let cancelAction = UIAlertAction(title: "Cancel" , style: .default)
            
            self.present(alert, animated: true, completion: nil)
            alert.addAction(cancelAction)

        }
        
        /*
          UNCOMPLETED TASK BUTTON
            */
        let UncompletedTaskAction = UIContextualAction(style: .destructive, title: "Uncompleted task") { (action, view, handler) in
            //print("Send task to Completed View Controller")
            //print("Edit")
            //print(task)
            //print(indexPath.row)
            
            let alert = UIAlertController(title: "Uncompleted Task", message: "Would you like to add this task to Uncompleted tasks?", preferredStyle: .alert)
            
            //alert.addTextField{ (textField) in textField.text = "" }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                //let textField = alert?.textFields![0]
                //print("Text field: \(String(describing: textField))")
                
                //ADD function
                //print("add function")
                //self.save((textField?.text)!)
                //self.tableView.reloadData()
                self.modifyUncompleted(task, checkFalse)
                
                self.tableView.reloadData()
                
            }))
            
            let cancelAction = UIAlertAction(title: "Cancel" , style: .default)
            
            self.present(alert, animated: true, completion: nil)
            alert.addAction(cancelAction)
            
        }
        
        CompletedTaskAction.backgroundColor = .green
        UncompletedTaskAction.backgroundColor = .purple
        let configuration = UISwipeActionsConfiguration(actions: [CompletedTaskAction,UncompletedTaskAction])
        return configuration
    }
}

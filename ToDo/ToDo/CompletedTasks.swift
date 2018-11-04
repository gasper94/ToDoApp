//
//  CompletedTasks.swift
//  ToDo
//
//  Created by Ulises Martinez on 10/31/18.
//  Copyright © 2018 Ulises Martinez. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class CompletedTasks: UITableViewController{
    
    var tasks: [NSManagedObject] = []
    
    var CompletedTasks: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        print(tasks)
        
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
        print("hey")
        let Stringss = ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCompleted")!
        let item = tasks[indexPath.row]
        
        
        let val = item.value(forKey: "ch") as? Bool
        
        if val == true{
        cell.textLabel?.text = item.value(forKey: "at") as? String
        }else{
        cell.textLabel?.sizeThatFits(CGSize(width: 0, height: 0))
        }
        print(cell)
        return cell
    }
    
}

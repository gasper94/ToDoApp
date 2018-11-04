//
//  SaveTask.swift
//  ToDo
//
//  Created by Ulises Martinez on 11/3/18.
//  Copyright © 2018 Ulises Martinez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SaveValue {
    
    var tasks: [NSManagedObject] = []
    
    
    
    
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
}

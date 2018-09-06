//
//  Coredata.swift
//  ContacsUIApplication
//
//  Created by Jagan Mohan on 05/09/18.
//  Copyright © 2018 Jagan Mohan. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSObject {
    
    //MARK :- Fetching Data From  CoreData
    static func fetchDetailsFormDb(entityName:String)->[NSManagedObject] {
        var  contacts = [NSManagedObject]()
        let coreData = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = coreData.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        return contacts
}
    //MARK :- saving Data To  CoreData
    static  func savingContryCodes(entityName: String,countryCode:String,countryName:String) {
        let coreData = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = coreData.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:entityName, in: managedObjectContext)
        let contact = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        contact.setValue(countryName, forKey: "countryName")
        contact.setValue(countryCode, forKey: "countryCode")
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
}

//
//  AuthorsFabric.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class AuthorsFabric
{
    class func insertAuthor
        (
        order : Int16 = 0 ,
        id : String = "" ,
        name : String = "" ,
        context : NSManagedObjectContext
        ) -> Author
    {
        let fetchRequest = NSFetchRequest(entityName: "Author")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Author]
        
        if ( fetchResults?.count == 1 )
        {
            let anAuthor = (fetchResults?[0])!
            
            anAuthor.order = order
            anAuthor.name = name
            
            return anAuthor
        }
        else
        {
            let anAuthor = NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: context) as! Author
            
            anAuthor.id = id
            anAuthor.order = order
            anAuthor.name = name
            
            return anAuthor
        }
    }
}

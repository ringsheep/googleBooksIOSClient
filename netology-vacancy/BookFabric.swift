//
//  BookFabric.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class BookFabric
{
    class func insertBook
        (
        order : Int16 = 0 ,
        id : String = "" ,
        title : String = "" ,
        descriptionText : String = "" ,
        language : String = "" ,
        canonicalVolumeLink : String = "" ,
        thumbnail : String = "" ,
        publishedDate : NSDate?,
        epubDownloadLink : String = "" ,
        pdfDownloadLink : String = "" ,
        authors : NSSet = NSSet() ,
        context : NSManagedObjectContext
        ) -> Book
    {
        let fetchRequest = NSFetchRequest(entityName: "Book")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [Book]
        
        if ( fetchResults?.count == 1 )
        {
            let aBook = (fetchResults?[0])!
            
            aBook.order = order
            aBook.title = title
            aBook.descriptionText = descriptionText
            aBook.language = language
            aBook.canonicalVolumeLink = canonicalVolumeLink
            aBook.thumbnail = thumbnail
            if ( publishedDate != nil )
            {
                aBook.publishedDate = publishedDate!
            }
            aBook.epubDownloadLink = epubDownloadLink
            aBook.pdfDownloadLink = pdfDownloadLink
            aBook.authors = authors
            
            return aBook
            
            
        }
        else
        {
            let aBook = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: context) as! Book
            
            aBook.id = id
            aBook.order = order
            aBook.title = title
            aBook.descriptionText = descriptionText
            aBook.language = language
            aBook.canonicalVolumeLink = canonicalVolumeLink
            aBook.thumbnail = thumbnail
            if ( publishedDate != nil )
            {
                aBook.publishedDate = publishedDate!
            }
            aBook.epubDownloadLink = epubDownloadLink
            aBook.pdfDownloadLink = pdfDownloadLink
            aBook.authors = authors
            
            return aBook
            
            
        }
    }
}

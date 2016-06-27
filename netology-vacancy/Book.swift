//
//  Book.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class Book: NSManagedObject
{
    @NSManaged var id : String
    @NSManaged var order : Int16
    @NSManaged var title : String
    @NSManaged var descriptionText : String
    @NSManaged var language : String
    @NSManaged var canonicalVolumeLink : String
    @NSManaged var thumbnail : String
    @NSManaged var publishedDate : NSDate
    @NSManaged var epubDownloadLink : String
    @NSManaged var pdfDownloadLink : String
    @NSManaged var authors : NSSet

}

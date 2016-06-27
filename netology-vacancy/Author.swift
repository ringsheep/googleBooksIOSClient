//
//  Author.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class Author: NSManagedObject
{
    @NSManaged var order : Int16
    @NSManaged var id : String
    @NSManaged var name : String
}

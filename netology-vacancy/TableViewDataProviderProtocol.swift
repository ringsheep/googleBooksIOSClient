//
//  TableViewDataProviderProtocol.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc public protocol TableViewDataProviderProtocol: UITableViewDataSource {
    var managedObjectContext: NSManagedObjectContext { get set }
    weak var tableView: UITableView! { get set }
    optional var substringDataFilter : String { get set }
    
    func fetch()
    func clearContext()
    optional func entityForIndexPath(indexPath : NSIndexPath) -> AnyObject?
    optional func changeSubstringTerm(term : String)
    optional func requestAsyncDataUpdate()
}

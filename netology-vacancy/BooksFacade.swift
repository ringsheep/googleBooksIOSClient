//
//  BooksFacade.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BooksFacade : EntityFacadeProtocol
{
    // контекст
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // очередь загрузки
    @objc static var downloadOperationQueue = NSOperationQueue()
    
    // настройка очереди
    @objc class func setUpQueue()
    {
        downloadOperationQueue.maxConcurrentOperationCount = 1
        downloadOperationQueue.cancelAllOperations()
    }
}

extension BooksFacade
{
    class func getEntitiesBySubstringAndOffsetCount ( term : String , offset : Int , count : Int , success : () -> Void , failure : ( code : Int ) -> Void ) -> Void
    {
        setUpQueue()
        let booksConcreteParser = BooksConcreteParser(searchTerm: term, offset: offset, count: count)
        let booksDownloadOperation = CoreDataDownloadAndInsertOperation(concreteParser: booksConcreteParser,
                                                                        context: managedObjectContext,
                                                                        success: success,
                                                                        failure: failure)
        downloadOperationQueue.addOperation(booksDownloadOperation)
        
    }
    
    class func stopDownloadingRequest()
    {
        downloadOperationQueue.cancelAllOperations()
    }
}
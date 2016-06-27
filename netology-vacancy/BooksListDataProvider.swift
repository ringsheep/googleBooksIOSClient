//
//  BooksListDataProvider.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class BooksListDataProvider: NSObject, TableViewDataProviderProtocol
{
    public var managedObjectContext: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    weak public var tableView: UITableView!
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    let entityName = "Book"
    let sortKey = "order"
    private let booksCount = 10
    private var booksOffset = 0
    var substringDataFilter = ""
    var dataIsPending = false
    var currentRowIndex = 0
}

// MARK: - методы получения данных
extension BooksListDataProvider
{
    // обновление поисковой подстроки и вызов поиска
    public func changeSubstringTerm(term : String)
    {
        substringDataFilter = term
        self.clearContext()
        self.booksOffset = 0
        if ( substringDataFilter != "" )
        {
            self.requestAsyncDataUpdate()
        }
    }
    
    // публичная процедура вызова поиска по текущему запросу
    public func requestAsyncDataUpdate()
    {
        guard substringDataFilter != "" else
        {
            self.clearContext()
            self.booksOffset = 0
            return
        }
        getEntitiesBySubstring({
            
            }) { (code) in
                
        }
    }
    
    // процедура поиска по подстроке
    private func getEntitiesBySubstring(success : () -> Void ,
                                       failure : ( code : Int ) -> Void )
    {
        self.dataIsPending = true
        BooksFacade.getEntitiesBySubstringAndOffsetCount(self.substringDataFilter,
                                                         offset: self.booksOffset,
                                                         count: self.booksCount,
                                                         success: {
                                                            
                                                            if (self.dataIsPending)
                                                            {
                                                                self.dataIsPending = false
                                                                self.fetch()
                                                            }
                                                            success()
            }) { (code) in
                
                self.dataIsPending = false
                print("error with code \(code)")
                failure(code: code)
        }
    }
}

// MARK: - вспомогательные методы
extension BooksListDataProvider
{
    internal func entityForIndexPath(indexPath: NSIndexPath) -> AnyObject?
    {
        return fetchedResultsController.objectAtIndexPath(indexPath) as? Book
    }
    
    private func checkIfOffsetGrowIsNeeded() -> Bool
    {
        if let fetchedObjectsCount = self.fetchedResultsController.fetchedObjects?.count
        {
            if ( ((currentRowIndex + 1) % fetchedObjectsCount == 0)
                && ((currentRowIndex + 1) == self.booksOffset) )
            {
                return true
            }
        }
        return false
    }
    
    public func fetch() {
        var e: NSError?
        do {
            try fetchedResultsController.performFetch()
            self.booksOffset = fetchedResultsController.fetchedObjects?.count ?? 0
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        } catch var error as NSError {
            e = error
            print("fetch error: \(e!.localizedDescription)")
        } catch {
            fatalError()
        }
    }
    
    // очистка контекста. используется при начале поиска, чтобы очистить предыдущие результаты и данные
    public func clearContext()
    {
        if ( dataIsPending )
        {
            BooksFacade.stopDownloadingRequest()
        }
        self.booksOffset = 0
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.includesPropertyValues = false
        let books = try? self.fetchedResultsController.managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        for book in books! {
            self.fetchedResultsController.managedObjectContext.deleteObject(book)
        }
        fetch()
    }
}

// MARK: - Table View Data Source
extension BooksListDataProvider: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        currentRowIndex = indexPath.row
        if checkIfOffsetGrowIsNeeded() && self.dataIsPending == false
        {
            requestAsyncDataUpdate()
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BookTableViewCell", forIndexPath: indexPath) as! BookTableViewCell
        
        if let book = entityForIndexPath(indexPath) as? Book
        {
            cell.updateFonts()
            cell.configureSelfWithData( book.thumbnail, title: book.title, authors: book.authors )
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
        }
        
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension BooksListDataProvider: NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController {
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: self.managedObjectContext)
        let sort = NSSortDescriptor(key: sortKey, ascending: true)
        let req = NSFetchRequest()
        req.entity = entity
        req.sortDescriptors = [sort]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        var e: NSError?
        do {
            try aFetchedResultsController.performFetch()
        } catch var error as NSError {
            e = error
            print("fetch error: \(e!.localizedDescription)")
        } catch {
            fatalError()
        }
        
        return aFetchedResultsController
    }
    
    /* called first
     begins update to `UITableView`
     ensures all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController)
    {
        if #available(iOS 9, *)
        {
            self.tableView.beginUpdates()
        }
    }
    
    /* called:
     - when a new model is created
     - when an existing model is updated
     - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController,
                    didChangeObject object: AnyObject,
                    atIndexPath indexPath: NSIndexPath?,
                    forChangeType type: NSFetchedResultsChangeType,
                    newIndexPath: NSIndexPath?) {
        
        let info = controller.sections![0]
        
        if #available(iOS 9, *)
        {
            
            switch type
            {
            case .Insert:
                if let newIndexPath = newIndexPath
                {
                    if ( (newIndexPath.row != indexPath?.row) )
                    {
                        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                        return
                    }
                    return
                }
                if ( indexPath == nil )
                {
                    self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                    return
                    
                }
            case .Update:
                if let indexPath = indexPath
                {
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    return
                }
                
            case .Move:
                if let newIndexPath = newIndexPath {
                    if let indexPath = indexPath {
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
                        return
                    }
                }
            case .Delete:
                if let indexPath = indexPath {
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    return
                }
            default: break
                
            }
            
            
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        else
        {
            self.tableView.reloadData()
        }
    }
    
    /* called last
     tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController)
    {
        if #available(iOS 9, *)
        {
            self.tableView.endUpdates()
        }
    }
    
}
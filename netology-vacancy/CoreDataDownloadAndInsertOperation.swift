//
//  CoreDataDownloadAndInsertOperation.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

// абстрактный класс операции парсинга и загрузки контента
class CoreDataDownloadAndInsertOperation: NSOperation
{
    // делегат конкретного парсера, разбирающего нужные поля JSON-а. назначается при инициализации
    var concreteParser : ConcreteParserProtocol
    
    var internetTask : NSURLSessionTask?
    var successBlock : (() -> Void)
    var failureBlock : ( code : Int ) -> Void
    
    // контекст объектов
    let managedObjectContext : NSManagedObjectContext
    
    init(concreteParser : ConcreteParserProtocol ,
         context : NSManagedObjectContext ,
         success : () -> Void ,
         failure : ( code : Int ) -> Void )
    {
        self.concreteParser = concreteParser
        self.managedObjectContext = context
        successBlock = success
        failureBlock = failure
        super.init()
    }
    
    override func cancel () -> Void
    {
        print("task canceled")
        internetTask?.cancel()
    }
    
    override func main() {
        
        // семафорное ожидание исполнения блока
        let semaphore = dispatch_semaphore_create(0)
        
        internetTask = concreteParser.callApiMethod({ (data) in
            
            self.parseAndInsertEntity(inContext: self.managedObjectContext,
                data: data, semaphore: semaphore)
            
            }) { (errorCode) in
                
                self.failureBlock( code : errorCode )
                dispatch_semaphore_signal(semaphore)
                
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
    }

}

// MARK: - процедура парсинга и добавления городов в контекст
extension CoreDataDownloadAndInsertOperation
{
    private func parseAndInsertEntity ( inContext context : NSManagedObjectContext ,
                                          data : NSArray? ,
                                          semaphore : dispatch_semaphore_t! )
    {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = context
        
        privateContext.performBlockAndWait({ () -> Void in
            
            // выход в случае нулевого количества пришедших данных
            if ( data!.count == 0 )
            {
                self.failureBlock(code: 0 )
                dispatch_semaphore_signal(semaphore)
                return
            }
            
            // необязательная дополнительная декорация данных
            var finalizedData = data
            if ( self.concreteParser.decorateAndUpdateData != nil )
            {
                finalizedData = self.concreteParser.decorateAndUpdateData!(data!)
            }
            
            if ( finalizedData!.count == 0 )
            {
                self.failureBlock(code: 0 )
                dispatch_semaphore_signal(semaphore)
                return
            }
            
            // проходимся по всем объектам в массиве пришедших данных, парсим
            for dictionary in finalizedData!
            {
                if ( self.cancelled )
                {
                    break
                }
                
                self.concreteParser.parseData(withDictionary: dictionary as! NSDictionary , inContext: privateContext)
                
            }
            
            // сохранение контекста со всеми добавленными и измененными сущностями
            if ( self.cancelled != true )
            {
                var e: NSError?
                do {
                    try privateContext.save()
                } catch let error as NSError {
                    e = error
                    
                } catch {
                }
            }
            else
            {
                self.failureBlock(code: 0 )
                dispatch_semaphore_signal(semaphore)
            }
            
        })
        
        self.successBlock()
        dispatch_semaphore_signal(semaphore)
    }
}
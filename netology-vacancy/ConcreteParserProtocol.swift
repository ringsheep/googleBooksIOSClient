//
//  ConcreteParserProtocol.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc public protocol ConcreteParserProtocol {
    
    // декоратор данных до парсинга
    // (например, дополнительная фильтрация по предикату или частичная подгрузка в случае сериализации неизбежно большого json-а)
    optional func decorateAndUpdateData( data : NSArray ) -> NSArray?
    
    // конкретная операция парсинга каждого из словарей
    func parseData( withDictionary dictionary : NSDictionary , inContext context : NSManagedObjectContext) -> Void
    
    // обертка вызова метода апи
    func callApiMethod( success : ( data : NSArray? ) -> Void ,
                        failure : ( errorCode : Int ) -> Void ) -> NSURLSessionTask
}
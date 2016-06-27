//
//  EntityFacadeProtocol.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc public protocol EntityFacadeProtocol {
    static var downloadOperationQueue: NSOperationQueue { get set }
    static func setUpQueue()

    optional static func getEntitiesBySubstringAndOffsetCount( term : String , offset : Int , count : Int , success : () -> Void , failure : () -> Void ) -> Void
}
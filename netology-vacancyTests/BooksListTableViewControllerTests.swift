//
//  BooksListTableViewControllerTests.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/26/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import netology_vacancy

class BooksListTableViewControllerTests: XCTestCase {

    var viewController: BooksListTableViewController!
    
    override func setUp() {
        super.setUp()
        
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("BooksListTableViewController") as! BooksListTableViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}

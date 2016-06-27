//
//  BooksListTableViewController.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit

class BooksListTableViewController: UITableViewController
{
    var searchController : UISearchController!
    public var dataProvider: TableViewDataProviderProtocol?
    public var detalisationDelegate: BookDetalisationProtocol?
}

// MARK: - View Controller life cycle
extension BooksListTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpProvider()
        setUpView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - настройка провайдера
extension BooksListTableViewController
{
    private func setUpProvider()
    {
        let dataProvider = BooksListDataProvider()
        self.dataProvider = dataProvider
        tableView.dataSource = dataProvider
        dataProvider.tableView = tableView
    }
}

// MARK: - настройка вида
extension BooksListTableViewController
{
    private func setUpView()
    {
        setUpSearchBar()
        self.title = "Google Книги"
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.registerNib(UINib (nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "BookTableViewCell")
    }
}

// MARK: - Table view delegate
extension BooksListTableViewController
{
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let detailViewController = self.detalisationDelegate as? BookDetalisationViewController {
            detailViewController.bookSelected(dataProvider?.entityForIndexPath!(indexPath) as! Book)
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
    }
}

// MARK: - методы работы с поиском
extension BooksListTableViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating
{
    private func setUpSearchBar()
    {
        self.searchController =
            UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.searchBar.tintColor = UIColor.whiteColor()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.tableHeaderView = self.searchController.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else
        {
            return
        }
        
        // если только выбрано, то не производить действий
        if ( searchTerm == "" && dataProvider?.substringDataFilter == "" )
        {
            return
        }
        // если опустошено поле, то произвести сброс
        else if ( searchTerm == "" && dataProvider?.substringDataFilter != "" )
        {
            dismissSearchResultsAndShowDefault()
            return
        }
        
        // следим, чтобы метод не вызывался лишний раз при появлении экрана с открытым поисковым контроллером
        guard ( searchTerm != dataProvider?.substringDataFilter ) else
        {
            return
        }
        
        self.dataProvider!.changeSubstringTerm!(self.searchController.searchBar.text!)
    }
    
    // а также после нажатия кнопки поиска
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        guard ( dataProvider?.substringDataFilter != "" ) else
        {
            dismissSearchResultsAndShowDefault()
            return
        }
        dataProvider?.requestAsyncDataUpdate!()
    }
    
    // возвращаемся обратно при нажатии на кнопку отмены
    func willDismissSearchController(searchController: UISearchController)
    {
        dismissSearchResultsAndShowDefault()
    }
    
    // сброс в дефолтное пустое состояние
    func dismissSearchResultsAndShowDefault()
    {
        dataProvider!.changeSubstringTerm!("")
        self.resignFirstResponder()
    }
    
}

//
//  BooksConcreteParser.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import CoreData

class BooksConcreteParser : ConcreteParserProtocol
{
    var searchTerm : String
    var offset: Int
    var count: Int
    
    init( searchTerm : String , offset : Int , count : Int)
    {
        self.searchTerm = searchTerm
        self.offset = offset
        self.count = count
    }
    
    @objc func callApiMethod( success : ( data : NSArray? ) -> Void ,
                        failure : ( errorCode : Int ) -> Void ) -> NSURLSessionTask
    {
        return APIWrapper.getBooksBySubstring(searchTerm,
                                              offset: offset,
                                              count: count,
                                              success: success,
                                              failure: failure)
    }
    
    @objc func parseData( withDictionary dictionary : NSDictionary , inContext context : NSManagedObjectContext ) -> Void
    {
        let items = dictionary.dictionariesArrayFromValue(forKey: "items")
        
        for (index, bookDictionary) in items.enumerate()
        {
            let id = bookDictionary.stringFromValue(forKey: "id")
            let order = Int16(index) + self.offset
            
            let volumeInfo = bookDictionary.dictionaryFromValue(forKey: "volumeInfo")
            let title = volumeInfo.stringFromValue(forKey: "title")
            let publishedDate = volumeInfo.stringFromValue(forKey: "publishedDate")
            let publishedNSDate = CalendarUtils.dateFromString(publishedDate)
            let descriptionText = volumeInfo.stringFromValue(forKey: "description")
            let language = volumeInfo.stringFromValue(forKey: "language")
            let canonicalVolumeLink = volumeInfo.stringFromValue(forKey: "canonicalVolumeLink")
            
            let thumbnail = volumeInfo.dictionaryFromValue(forKey: "imageLinks").stringFromValue(forKey: "thumbnail")
            
            let accessInfo = bookDictionary.dictionaryFromValue(forKey: "accessInfo")
            let epubDownloadLink = accessInfo.dictionaryFromValue(forKey: "epub").stringFromValue(forKey: "downloadLink")
            let pdfDownloadLink = accessInfo.dictionaryFromValue(forKey: "pdf").stringFromValue(forKey: "downloadLink")
            
            var authorsSet = NSMutableSet()
            let authors = volumeInfo.arrayFromValue(forKey: "authors") as! [String]
            for (index, authorName) in authors.enumerate()
            {
                let order = Int16(index)
                let authorID = id + "author\(index)"
                let newAuthor = AuthorsFabric.insertAuthor(order,
                                                           id: authorID,
                                                           name: authorName,
                                                           context: context)
                authorsSet.addObject(newAuthor)
            }
            
            let newBook = BookFabric.insertBook(order,
                                                id: id,
                                                title: title,
                                                descriptionText: descriptionText,
                                                language: language,
                                                canonicalVolumeLink: canonicalVolumeLink,
                                                thumbnail: thumbnail,
                                                publishedDate: publishedNSDate,
                                                epubDownloadLink: epubDownloadLink,
                                                pdfDownloadLink: pdfDownloadLink,
                                                authors: authorsSet,
                                                context: context)
            
        }
    }
    
}
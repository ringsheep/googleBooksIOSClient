//
//  NSDictionaryUtils.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation

extension NSDictionary
{
    func stringFromValue( forKey key : String ) -> String
    {
        return self[key] as? String ?? ""
    }
    
    func integerFromValue( forKey key : String ) -> Int
    {
        return self[key] as? Int ?? 0
    }
    
    func doubleFromValue( forKey key : String ) -> Double
    {
        return self[key] as? Double ?? 0.0
    }
    
    func dictionariesArrayFromValue( forKey key : String ) -> [NSDictionary]
    {
        return self[key] as? [NSDictionary] ?? [NSDictionary]()
    }
    
    func dictionaryFromValue( forKey key : String ) -> NSDictionary
    {
        return self[key] as? NSDictionary ?? NSDictionary()
    }
    
    func arrayFromValue( forKey key : String ) -> NSArray
    {
        return self[key] as? NSArray ?? NSArray()
    }
}
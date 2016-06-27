//
//  APIWrapper.swift
//  netology-vacancy
//
//  Created by George Zinyakov on 6/25/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import Alamofire

// класс конкретных методов взаимодействия с сервером
class APIWrapper
{
    public class func getBooksBySubstring(term : String, offset : Int, count: Int ,
                                          success : ( data : NSArray? ) -> Void ,
                                          failure : ( errorCode : Int ) -> Void) -> NSURLSessionTask
    {
        let parametersDictionary = ["q" : term,
                                    "startIndex" : "\(offset)",
                                    "maxResults" : "\(count)",
                                    "key" : Constants.apiKey]
        let request = Alamofire.request(.GET, Constants.getVolumesURL, parameters: parametersDictionary)
            .responseJSON { response in
                
                print("request \(response.request!)")  // запрос
                
                switch response.result {
                case .Success(let JSON):
                    //print("Success with JSON: \(JSON)")
                    
                    let response = [JSON]
                    success(data: response)
                    
                case .Failure(let error):
                    failure(errorCode: error.code)
                }
        }
        
        return request.task
    }
}
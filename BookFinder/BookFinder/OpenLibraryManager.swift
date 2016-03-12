//
//  OpenLibraryManager.swift
//  BookFinder
//
//  Created by Aldo Castro on 12/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import Foundation

class OpenLibraryManager {
    
    private let baseURL = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN"
    
    func getBookWithISBN(isbn: String, completionHandler: (NSString?, NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "\(baseURL):\(isbn)")!
        
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(nil, error)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = data {
                        let responseStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        completionHandler(responseStr, nil)
                    }
                })
            }
            
        }
        
        task.resume()
    }
    
}
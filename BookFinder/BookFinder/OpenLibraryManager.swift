//
//  OpenLibraryManager.swift
//  BookFinder
//
//  Created by Aldo Castro on 12/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import UIKit
import Foundation

class OpenLibraryManager {
    
    private let session = NSURLSession.sharedSession()
    private let baseURL = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN"
    
    func getBookWithISBN(isbn: String, completionHandler: (BookModel?, NSError?) -> Void) {
        let url = NSURL(string: "\(baseURL):\(isbn)")!
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(nil, error)
                })
            } else {
                if let data = data {
                    let bookModel: BookModel?
                    var error: NSError? = nil
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String:AnyObject]
                        if json.count > 0 {
                            bookModel = BookModelFactory.createBookModelFromDictionary(json)
                        } else {
                            bookModel = nil
                            error = NSError(domain:"bookfinder", code:404, userInfo:[NSLocalizedDescriptionKey:"No Results Found."])
                        }
                    } catch _ {
                        bookModel = nil
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(bookModel, error)
                    })
                }
            }
        }
        task.resume()
    }
    
    func getBookImage(url: NSURL?, completionHandler: (UIImage?) -> Void) {
        if let url = url {
            let downloadTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(nil)
                    })
                } else {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                        if let _data = data, image = UIImage(data: _data) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(image)
                            })
                        }
                    })
                }
            }
            downloadTask.resume()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(nil)
            })
        }
    }
}
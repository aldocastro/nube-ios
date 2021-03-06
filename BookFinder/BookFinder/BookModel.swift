//
//  BookModel.swift
//  BookFinder
//
//  Created by Aldo Castro on 17/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import Foundation

struct BookModel {
    var isbn: String
    var title: String
    var authors: [[String: String]]
    var cover: String
    
    func authorsDescription() -> String {
        var description = String()
        
        if authors.count > 1 {
            for author in authors {
                if let name = author["name"] as String! {
                    description.appendContentsOf("\(name), ")
                }
            }
        } else {
            if let firstAuthor = authors.first as [String : String]!, author = firstAuthor["name"] as String! {
                description = author
            }
        }
        
        return description
    }
    
    func coverUrl() -> NSURL? {
        guard cover != "" else { return nil }
        
        if let scapedStr = cover.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet()),
            url = NSURL(string: scapedStr) as NSURL! {
            return url
        }
        
        return nil
    }
}

class BookModelFactory {
    
    static func createBookModelFromDictionary(jsonDictionary: [String : AnyObject]) -> BookModel {
        var isbn = ""
        var title = ""
        var authors = [[String:String]]()
        var cover = ""
        
        if let key = jsonDictionary.keys.first, bookDict = jsonDictionary[key] {
            
            if let _isbn = bookDict["isbn_13"] as? [String], firstItem = _isbn.first {
                isbn = firstItem
            }
            
            if let _title = bookDict["title"] as? String {
                title = _title
            }
            
            if let _authors = bookDict["authors"] as? [[String : String]] {
                authors = _authors
            }
            
            if let coverDict = bookDict["cover"] as? [String:String],
                largeCoverStr = coverDict["medium"] as String! {
                cover = largeCoverStr
            }
        }
        
        return BookModel(isbn: isbn, title: title, authors: authors, cover: cover)
    }
    
}
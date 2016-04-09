//
//  ManagedContextController.swift
//  BookFinder
//
//  Created by Aldo Castro on 24/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import Foundation
import CoreData

class ManagedContextController {
    
    var managedContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.managedContext = context
    }
    
    func fetchBooks() -> [BookModel]? {
        let bookEntity = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedContext)
        let bookFetch = NSFetchRequest()
        bookFetch.entity = bookEntity
        
        do {
            if let result = try self.managedContext.executeRequest(bookFetch) as? NSAsynchronousFetchResult {
                if let books = result.finalResult as? [Book] where books.count > 0 {
                    return self.booksModelFromBooks(books)
                }
            }
        } catch {
            print("could not fetch: \(error)")
        }
        
        return nil
        
    }
    
    func fetchBooksWithIsbn(isbn: String) -> BookModel? {
        let bookFetch = NSFetchRequest(entityName: "Book")
        bookFetch.predicate = NSPredicate(format: "isbn == %@", isbn)
        
        do {
            if let result = try self.managedContext.executeRequest(bookFetch) as? NSAsynchronousFetchResult {
                if let books = result.finalResult as? [Book], firstBook = books.first as Book! {
                    return self.bookModelFromBook(firstBook)
                }
            }
        } catch {
            print("could not fetch: \(error)")
        }
        return nil
        
    }
    
    func insertBook(bookModel: BookModel) {
        let bookEntity = NSEntityDescription.entityForName("Book", inManagedObjectContext: managedContext)
        let authorEntity = NSEntityDescription.entityForName("Author", inManagedObjectContext: managedContext)
        
        let book = Book(entity: bookEntity!, insertIntoManagedObjectContext: managedContext)
        book.isbn = bookModel.isbn
        book.title = bookModel.title
        book.cover = bookModel.cover
        
        var authors: NSMutableSet?
        
        for authorModel in bookModel.authors {
            let author = Author(entity: authorEntity!, insertIntoManagedObjectContext: managedContext)
            if let _name = authorModel["name"] as String! {
                author.name = _name
            }
            if let _url = authorModel["url"] as String! {
                author.url = _url
            }
            
            authors = book.authors?.mutableCopy() as? NSMutableSet
            authors?.addObject(author)
            
        }
        
        if let _authors = authors?.copy() as? NSSet {
            book.authors = _authors
        }
        
        do {
            try managedContext.save()
        } catch {
            print("could not save: \(error)")
        }
        
    }
    
    
    private func bookModelFromBook(book: Book) -> BookModel {
        var isbn = "", title = "", cover = ""
        var authors = [[String: String]]()
        
        if let _isbn = book.isbn as String! {
            isbn = _isbn
        }
        if let _title = book.title as String! {
            title = _title
        }
        if let _cover = book.cover as String! {
            cover = _cover
        }
        if let _authors = book.authors {
            var mAuthors = [[String: String]]()
            for author in _authors {
                if let currentAuthor = author as? Author, name = currentAuthor.name as String!, url = currentAuthor.url as String! {
                    mAuthors.append(["name" : name, "url" : url])
                }
            }
            authors = mAuthors
        }
        
        return BookModel(isbn: isbn, title: title, authors: authors, cover: cover)
    }
    
    private func booksModelFromBooks(books: [Book]) -> [BookModel] {
        var booksModel = [BookModel]()
        
        for book in books {
            if let bookModel = bookModelFromBook(book) as BookModel! {
                booksModel.append(bookModel)
            }
        }
        
        return booksModel
    }
    
}
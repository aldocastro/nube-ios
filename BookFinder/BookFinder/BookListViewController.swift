//
//  BookListViewController.swift
//  BookFinder
//
//  Created by Aldo Castro on 23/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import UIKit
import CoreData

class BookListViewController : UITableViewController {
    
    private let manager = OpenLibraryManager()
    private var books = [BookModel]()
    var managedContextController: ManagedContextController!
    
    private func searchBookWithISBN(isbn: String?) {
        guard let isbn = isbn where !isbn.isEmpty else {
            showErrorAlertMessage("Please enter a ISBN, this field still empty."); return
        }
        
        if let book = self.managedContextController.fetchBooksWithIsbn(isbn) {
            self.books.append(book)
            self.tableView.reloadData()
        } else {
            manager.getBookWithISBN(isbn) { (response, error) -> Void in
                if let error = error as NSError! {
                    self.showErrorAlertMessage("\(error.localizedDescription)")
                } else {
                    if let response = response as BookModel! {
                        self.books.append(response)
                        self.managedContextController.insertBook(response)
                        
                        self.tableView.reloadData()
                        self.showDetailViewControllerWithBook(response)
                    }
                }
            }
        }
    }
    
    private func showDetailViewControllerWithBook(book: BookModel) {
        if let storyboard = UIStoryboard(name: "Main", bundle: nil) as UIStoryboard!,
            detailViewController = storyboard.instantiateViewControllerWithIdentifier("detailBookVC") as? ViewController {
            detailViewController.setBook(book)
            self.showViewController(detailViewController, sender: nil)
        }
    }
    
    private func showErrorAlertMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Search Book", message: "Please insert a ISBN", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let saveAction = UIAlertAction(title: "Search", style: .Default) { (action) in
            if let textFields = alert.textFields, alertTextField = textFields[0] as UITextField!, text = alertTextField.text {
                self.searchBookWithISBN(text)
            }
        }
        
        alert.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "ISBN here"
            textfield.clearButtonMode = .Always
            textfield.returnKeyType = .Search
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.view.setNeedsLayout()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let books = self.managedContextController.fetchBooks() {
            self.books = books
            self.tableView.reloadData()
        }
    }
    
    //  MARK: UITableViewDelegate methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as UITableViewCell!
        let book = books[indexPath.row] as BookModel!
        cell.textLabel?.text = book.title
        return cell
    }
    
    // MARK: UIViewController Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "showBookDetailSegue" else { return }
        
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow,
            bookDetailVC = segue.destinationViewController as? ViewController {
            let book = self.books[selectedIndexPath.row] as BookModel
            bookDetailVC.setBook(book)
        }
    }
}
//
//  ViewController.swift
//  BookFinder
//
//  Created by Aldo Castro on 12/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
    private let manager = OpenLibraryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        clearFields()
        self.textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func searchBookWithISBN(isbn: String?) {
        guard let isbn = self.textField.text as String! where !isbn.isEmpty else {
            showErrorAlertMessage("Please enter a ISBN, this field still empty."); return
        }

        manager.getBookWithISBN(isbn) { (response, error) -> Void in
            if let error = error as NSError! {
                self.showErrorAlertMessage("\(error.localizedDescription)")
            } else {
                if let response = response as BookModel! {
                    self.updateViewElements(response)
                }
            }
        }
    }
    
    private func clearFields() {
        textField.text = ""
        bookTitle.text = ""
        bookAuthors.text = ""
        cover.image = nil
    }
    
    private func showErrorAlertMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        clearFields()
    }
    
    private func updateViewElements(book: BookModel) {
        bookTitle.text = book.title
        bookAuthors.text = book.authorsDescription()
        
        manager.getBookImage(book.coverUrl()) { (image) -> Void in
            self.cover.image = image
        }
    }
    
    @IBAction func didPressSearchButton(sender: AnyObject) {
        self.searchBookWithISBN(self.textField.text)
    }
    
    //  MARK: UITextFieldDelegate

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.searchBookWithISBN(self.textField.text)
        self.textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        clearFields()
        return true
    }
}


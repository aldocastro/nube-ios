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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var searchButton: UIButton!
    
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
                if let response = response as String! {
                    self.showText(response)
                }
            }
        }
    }
    
    private func clearFields() {
        textField.text = ""
        textView.text = ""
    }
    
    private func showErrorAlertMessage(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        clearFields()
    }
    
    private func showText(text: String) {
        textView.text = text
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


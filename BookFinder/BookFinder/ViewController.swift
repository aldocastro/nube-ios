//
//  ViewController.swift
//  BookFinder
//
//  Created by Aldo Castro on 12/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    
    private var book: BookModel?
    private let manager = OpenLibraryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadViewElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadViewElements() {
        guard let book = self.book else {return}
        
        bookTitle.text = book.title
        bookAuthors.text = book.authorsDescription()
        manager.getBookImage(book.coverUrl()) { (image) -> Void in
            self.cover.image = image
        }
    }
    
    func setBook(book: BookModel) {
        self.book = book
    }
    
    
}


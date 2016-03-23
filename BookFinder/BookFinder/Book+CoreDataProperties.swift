//
//  Book+CoreDataProperties.swift
//  BookFinder
//
//  Created by Aldo Castro on 23/03/16.
//  Copyright © 2016 Aldo Castro. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Book {

    @NSManaged var title: String?
    @NSManaged var cover: String?
    @NSManaged var authors: NSSet?

}

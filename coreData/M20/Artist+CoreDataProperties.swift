//
//  Artist+CoreDataProperties.swift
//  M20
//
//  Created by Даниил Попов on 22.01.2023.
//
//

import Foundation
import CoreData
import UIKit


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var birthday: String?
    @NSManaged public var country: String?

}

extension Artist : Identifiable {

}



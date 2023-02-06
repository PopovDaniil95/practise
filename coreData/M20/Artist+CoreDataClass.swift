//
//  Artist+CoreDataClass.swift
//  M20
//
//  Created by Даниил Попов on 22.01.2023.
//
//

import Foundation
import CoreData
import UIKit

@objc(Artist)
public class Artist: NSManagedObject, NSCoding {
        public func encode(with coder: NSCoder) {
            coder.encode(name, forKey: "name")
            coder.encode(surname, forKey: "surname")
            coder.encode(birthday, forKey: "birthday")
            coder.encode(country, forKey: "country")

        }
    
        required public init?(coder: NSCoder) {
            name = coder.decodeObject(forKey: "name") as? String ?? ""
            surname = coder.decodeObject(forKey: "surname") as? String ?? ""
            birthday = coder.decodeObject(forKey: "birthday") as? String ?? ""
            country = coder.decodeObject(forKey: "country") as? String ?? ""

        }
}

//
//  JSON.swift
//  M19
//
//  Created by Даниил Попов on 17.01.2023.
//
//


import Foundation

public class JSON {
    public var birth : String?
    public var occupation : String?
    public var name : String?
    public var lastName : String?
    public var country : String?


    init(birth: String, occupation: String, name: String, lastName: String, country: String) {
        self.birth = birth
        self.occupation = occupation
        self.name = name
        self.lastName = lastName
        self.country = country
    }

    public class func modelsFromDictionaryArray(array:NSArray) -> [JSON]
    {
        var models:[JSON] = []
        for item in array
        {
            models.append(JSON(dictionary: item as! NSDictionary)!)
        }
        return models
    }

    required public init?(dictionary: NSDictionary) {

        birth = dictionary["birth"] as? String
        occupation = dictionary["occupation"] as? String
        name = dictionary["name"] as? String
        lastName = dictionary["lastName"] as? String
        country = dictionary["country"] as? String
        
    }

        

    public func dictionaryRepresentation() -> NSDictionary {

        let dictionary = NSMutableDictionary()

        dictionary.setValue(self.birth, forKey: "birth")
        dictionary.setValue(self.occupation, forKey: "occupation")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.lastName, forKey: "lastName")
        dictionary.setValue(self.country, forKey: "country")

        return dictionary
    }

}

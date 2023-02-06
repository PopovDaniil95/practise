//
//  File.swift
//  M20
//
//  Created by Даниил Попов on 29.01.2023.
//

import UIKit

final class UserSettings {
    
    private enum SettingsKeys: String {
        case userName
    }
    
    static var userName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userName.rawValue
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
}

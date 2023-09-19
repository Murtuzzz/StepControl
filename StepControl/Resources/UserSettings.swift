//
//  UserSettings.swift
//  StepControl
//
//  Created by Мурат Кудухов on 06.09.2023.
//

import Foundation

final class UserSettings {
    
    private enum SettingsKeys: String {
        case target
        case isNotificationsOn
        case themeIndex
    }
    
    static var target: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.target.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.target.rawValue
            if let target = newValue {
                print("value: \(target) was added to key \(key)")
                defaults.set(target, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var notifications: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.isNotificationsOn.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.isNotificationsOn.rawValue
            if let notifications = newValue {
                print("value: \(notifications) was added to key \(key)")
                defaults.set(notifications, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var themeIndex: Int! {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.themeIndex.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.themeIndex.rawValue
            if let theme = newValue {
                print("value: \(theme) was added to key \(key)")
                defaults.set(theme, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    
}

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
        case weekStepsArray
        case weekCellIndex
        case achOne
        case achTwo
        case achThree
        case achFour
        case achFive
        case achSix
        case achSeven
        case achEight
        case achNine
        case achTen
        
    }
    
    static var weekSteps: [Double]! {
        get {
            return UserDefaults.standard.array(forKey: SettingsKeys.weekStepsArray.rawValue) as? [Double]
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.weekStepsArray.rawValue
            if let steps = newValue {
                print("value: \(steps) was added to key \(key)")
                defaults.set(steps, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
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
    
    static var weekCellIndex: Int! {
        get {
            return UserDefaults.standard.integer(forKey: SettingsKeys.weekCellIndex.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.weekCellIndex.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achOne: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achOne.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achOne.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achTwo: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achTwo.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achTwo.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achThree: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achThree.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achThree.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achFour: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achFour.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achFour.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achFive: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achFive.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achFive.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achSix: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achSix.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achSix.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achSeven: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achSeven.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achSeven.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achEight: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achEight.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achEight.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achNine: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achNine.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achNine.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
    
    static var achTen: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: SettingsKeys.achTen.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.achTen.rawValue
            if let index = newValue {
                print("value: \(index) was added to key \(key)")
                defaults.set(index, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}

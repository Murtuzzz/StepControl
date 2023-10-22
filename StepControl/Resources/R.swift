//
//  R.swift
//  StepControl
//
//  Created by Мурат Кудухов on 31.08.2023.
//

import UIKit

enum R {
    enum Colors {
        
        static var background = UIColor(hexString: "#e2eaf2")
        static var gray = UIColor(hexString: "#6a6f70")
        //static var darkBlue = UIColor(hexString: "#3B3395")
        //static var blue = UIColor(hexString: "#8781f4")
        static var inactive = UIColor.white
        static let orange = UIColor(hexString: "#FF9C41")
        static let darkGray = UIColor(hexString: "#2d3250")
        static let darkBlue = UIColor(hexString: "#424769")
        static let orangeTwo = UIColor(hexString: "#fdb17a")
        static let orangeThree = UIColor(hexString: "#E25825")
        
    }
    
    enum Fonts {
        static func Italic(with size: CGFloat) -> UIFont {
            UIFont(name: "GillSans-SemiBoldItalic", size: size) ?? UIFont()
            
        }
        static func nonItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "ArialMT", size: size) ?? UIFont()
        }
        
        static func avenir(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-Bold", size: size) ?? UIFont()
        }
        
        static func Bold(with size: CGFloat) -> UIFont {
            UIFont(name: "HelveticaNeue-CondensedBold", size: size) ?? UIFont()
        }
        
        static func avenirItalic(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-MediumItalic", size: size) ?? UIFont()
        }
        
        static func avenirBook(with size: CGFloat) -> UIFont {
            UIFont(name: "Avenir-Book", size: size) ?? UIFont()
        }
        
        static func avenirLight(with size: CGFloat) -> UIFont {
            UIFont(name: "AvenirNext-UltraLight", size: size) ?? UIFont()
        }
    }
}


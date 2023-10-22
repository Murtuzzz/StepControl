//
//  UIImageExt.swift
//  StepControl
//
//  Created by Мурат Кудухов on 15.10.2023.
//

import UIKit
import ImageIO


public extension UIImage {

    @nonobjc class var stairs: UIImage? {
        if let asset = NSDataAsset(name: "stairs") {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
    
    @nonobjc class var person: UIImage? {
        if let asset = NSDataAsset(name: "person") {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }
    
    @nonobjc class var helmet: UIImage? {
        if let asset = NSDataAsset(name: "helmetGif") {
            return UIImage.gif(data: asset.data)
        }
        return nil
    }

    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }

        var images = [CGImage]()

        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
        }
        
        return UIImage.animatedImage(with: images.map { UIImage(cgImage: $0) }, duration: 3.0)
    }
    
    
}


//
//  StepsCounterView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 31.08.2023.
//


import UIKit

final class ProgressView: UIView {
    
    func drawProgress(with percent: CGFloat) {
        layer.sublayers?.removeAll()
        //backgroundColor = .cyan
        //let circleFrame = UIScreen.main.bounds.width - (15 + 40) * 2
        let circleFrame = UIScreen.main.bounds.height
        let radius: CGFloat?
        
        if UIScreen.main.bounds.height == 667 {
            radius = circleFrame / 5.3
        } else {
            radius = circleFrame / 5.9
        }
        
        print("Radius - \(radius!)")
        print(UIScreen.main.bounds.height)
        let center: CGPoint!
        
        if UIScreen.main.bounds.height == 667 {
            center = CGPoint(x: radius! + 10, y: radius! + 8)
        } else {
            center = CGPoint(x: radius!, y: radius!)
        }
        
        let startAngle = -CGFloat.pi * 3/6
        let endAngle = CGFloat.pi * 2
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius!,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        
        //дизайн начальной точки
        let startDotLayer = CAShapeLayer()
        startDotLayer.path = circlePath.cgPath
        startDotLayer.strokeColor = R.Colors.orangeTwo.cgColor
        if UIScreen.main.bounds.height == 667 {
            startDotLayer.lineWidth = 19
        } else {
            startDotLayer.lineWidth = 22
        }
        startDotLayer.strokeEnd = 0.001
        startDotLayer.fillColor = UIColor.clear.cgColor
        startDotLayer.lineCap = .round
        
        // дизайн полосы
        let defaultCircleLayer = CAShapeLayer()
        defaultCircleLayer.path = circlePath.cgPath
        defaultCircleLayer.strokeColor = R.Colors.darkBlue.cgColor
//        defaultCircleLayer.lineWidth = 36
        if UIScreen.main.bounds.height == 667 {
            defaultCircleLayer.lineWidth = 32
        } else {
            defaultCircleLayer.lineWidth = 36
        }
        defaultCircleLayer.strokeEnd = 1
        defaultCircleLayer.fillColor = UIColor.clear.cgColor
        defaultCircleLayer.lineCap = .round
        
        
        // дизайн полосы
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = R.Colors.orangeTwo.cgColor
        if UIScreen.main.bounds.height == 667 {
            circleLayer.lineWidth = 19
        } else {
            circleLayer.lineWidth = 22
        }
        
        circleLayer.strokeEnd = percent
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        
       
        layer.addSublayer(defaultCircleLayer)
        layer.addSublayer(circleLayer)
        layer.addSublayer(startDotLayer)
        
    }
}

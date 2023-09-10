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

        //нанесение полосы
        let circleFrame = UIScreen.main.bounds.width - (15 + 40) * 2
        let radius = circleFrame / 2
        let center = CGPoint(x: radius, y: radius)
        let startAngle = -CGFloat.pi * 3/6
        let endAngle = CGFloat.pi * 2
        
        let circlePath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        
        //дизайн начальной точки
        let startDotLayer = CAShapeLayer()
        startDotLayer.path = circlePath.cgPath
        startDotLayer.strokeColor = R.Colors.blue.cgColor
        startDotLayer.lineWidth = 22
        startDotLayer.strokeEnd = 0.001
        startDotLayer.fillColor = UIColor.clear.cgColor
        startDotLayer.lineCap = .round
        
        // дизайн полосы
        let defaultCircleLayer = CAShapeLayer()
        defaultCircleLayer.path = circlePath.cgPath
        defaultCircleLayer.strokeColor = R.Colors.darkBlue.cgColor
        defaultCircleLayer.lineWidth = 36
        defaultCircleLayer.strokeEnd = 1
        defaultCircleLayer.fillColor = UIColor.clear.cgColor
        defaultCircleLayer.lineCap = .round
        
        
        // дизайн полосы
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = R.Colors.blue.cgColor
        circleLayer.lineWidth = 22
        circleLayer.strokeEnd = percent
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        
       
        layer.addSublayer(defaultCircleLayer)
        layer.addSublayer(circleLayer)
        layer.addSublayer(startDotLayer)
        
    }
}

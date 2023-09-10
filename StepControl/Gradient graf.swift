//
//  Gradient graf.swift
//  StepControl
//
//  Created by Мурат Кудухов on 02.09.2023.
//

import UIKit

class GraphGradientView: UIView {
    
    
    var cornerRadius: CGFloat = 12
    
    var color1: UIColor = R.Colors.blue
    var color2: UIColor = R.Colors.darkBlue
    
    var topMargin: CGFloat = 19
    var bottomMargin: CGFloat = 31
    var leftMargin: CGFloat = 32
    var rightMargin: CGFloat = 34
    
    var dotRadius: CGFloat = 2
    
    
    var values: [CGFloat] = [2000,3000,4000,5000,6000,3000,6900,8765]
    
    let shadowView = UIView()
    
    
    override func draw(_ rect: CGRect) {
        guard values.count > 1 else { return }
        
        addGradient(color1: color1, color2: color2)
        drawLines()
        drawDots()
        drawGraph()
        setCornerRadius()
        setupShadow()
    }
    
    
    private func addGradient(color1: UIColor, color2: UIColor) {
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [color1.cgColor, color2.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0, 1]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint(x: 0, y: 1.25 * bounds.height)
        let endPoint = CGPoint(x: bounds.width, y: -0.25 * (bounds.height))
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
    }
    
    private func drawLines() {
        
        let lineLength = bounds.width - leftMargin - rightMargin
        let lineWidth: CGFloat = 1
        let masCentersOfLines = getCentersOfLines()
        
        for lineCenter in masCentersOfLines {
            drawOneLine(width: lineWidth, length: lineLength, center: lineCenter)
        }
    }
    
    private func getCentersOfLines() -> [CGPoint] {
        
        let centerX = bounds.width * 0.5
        let center0Y = topMargin
        let center2Y = bounds.height - bottomMargin
        let center1Y = (center0Y + center2Y) * 0.5
        
        let masCentersOfLines = [CGPoint(x: centerX, y: center0Y),
                                 CGPoint(x: centerX, y: center1Y),
                                 CGPoint(x: centerX, y: center2Y)]
        return masCentersOfLines
    }
    
    private func drawOneLine(width: CGFloat, length: CGFloat, center: CGPoint) {
        
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: center.x - length / 2,
                                  y: center.y))
        linePath.addLine(to: CGPoint(x: center.x + length / 2,
                                     y: center.y))
        linePath.close()
        
        linePath.lineWidth = 1
        UIColor(white: 1, alpha: 0.5).setStroke()
        linePath.stroke()
    }
    
    private func drawDots() {
        
        let centersOfDots = getCentersOfDots()
        for center in centersOfDots {
            drawDot(at: center)
        }
    }
    
    private func getCentersOfDots() -> [CGPoint] {
        
        var centers: [CGPoint] = []
        
        let verticalMultiplier = (bounds.height - topMargin - bottomMargin) / values.max()!
        let horizontalInset = (bounds.width - leftMargin - rightMargin) / CGFloat(values.count - 1)
        
        for i in 0..<values.count {
            
            let bottomInsetOfCenter = bottomMargin + values[i] * verticalMultiplier
            
            let center = CGPoint(x: leftMargin + CGFloat(i) * horizontalInset,
                                 y: bounds.height - bottomInsetOfCenter)
            centers.append(center)
        }
        print(centers)
        return centers
    }
    
    private func drawDot(at center: CGPoint) {
        
        let dotRect = CGRect(x: center.x - dotRadius,
                             y: center.y - dotRadius,
                             width: dotRadius * 2,
                             height: dotRadius * 2)
        
        let dotPath = UIBezierPath(ovalIn: dotRect)
        UIColor.white.setFill()
        dotPath.fill()
        
    }
    
    private func drawGraph() {
        
        let context = UIGraphicsGetCurrentContext()
        
        let shadow = UIColor.black
        let shadowOffset = CGSize(width: 10, height: 11)
        let shadowBlurRadius: CGFloat = 8
        
        let centersOfDots = getCentersOfDots()
        
        let graphPath = UIBezierPath()
        
        for i in 1..<values.count {
            graphPath.move(to: centersOfDots[i-1])
            graphPath.addCurve(to: centersOfDots[i],
                               controlPoint1: CGPoint(x: abs(centersOfDots[i].x + centersOfDots[i-1].x)/2,
                                                      y: centersOfDots[i-1].y),
                               controlPoint2: CGPoint(x: abs(centersOfDots[i].x + centersOfDots[i-1].x)/2,
                                                      y: centersOfDots[i].y))
        }
        
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        
        graphPath.lineWidth = 1
        UIColor.white.setStroke()
        graphPath.stroke()
        
        context?.restoreGState()
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func setupShadow() {
        shadowView.frame = frame
        shadowView.layer.cornerRadius = cornerRadius
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 2
        shadowView.backgroundColor = color1
        superview!.insertSubview(shadowView, at: 0)
    }
    

}

//
//  ChartView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 14.09.2023.
//

import UIKit

final class ChartView: UIView {
    
    private let ySeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let xSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(xSeparator)
        addSubview(ySeparator)
        
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    func configure(with data: [ChartsView.Data], topChartOffset: Int) {
        
        layoutIfNeeded()
        drawDashLines()
        drawChart(with: data, topChartOffset: topChartOffset)
        //addDashLines(with: 9)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            ySeparator.topAnchor.constraint(equalTo: topAnchor),
            ySeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            ySeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            ySeparator.widthAnchor.constraint(equalToConstant: 1),
            
            xSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
            xSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
            xSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
            xSeparator.heightAnchor.constraint(equalToConstant: 1),
            
        ])
    }
    
    //    func themeChange() {
    //        if traitCollection.userInterfaceStyle == .light {
    //            barView.backgroundColor = R.Colors.darkBlue
    //            titleLabel.textColor = R.Colors.darkBlue
    //            valueLabel.textColor = R.Colors.darkBlue
    //        } else {
    //
    //        }
    //    }
}

private extension ChartView {
    func drawDashLines(with counts: Int? = 9) {
        
        (0..<(counts ?? 9)).map { CGFloat($0) }.forEach {
            drawDashLine(at: bounds.height / CGFloat(counts ?? 9) * $0)
        }
    }
    func drawDashLine(at yPosition: CGFloat) {
        let startPoint = CGPoint(x: 0, y: yPosition)
        let endPoint = CGPoint(x: bounds.width, y: yPosition)
        
        let dashPath = CGMutablePath()
        dashPath.addLines(between: [startPoint,endPoint])
        
        let dashLayer = CAShapeLayer()
        dashLayer.path = dashPath
        dashLayer.strokeColor = R.Colors.orangeTwo.withAlphaComponent(0.5).cgColor
        dashLayer.lineWidth = 1
        dashLayer.lineDashPattern = [6, 3]
        
        layer.addSublayer(dashLayer)
    }
    
    func drawChart(with data: [ChartsView.Data], topChartOffset: Int) {
        guard let maxValue = data.sorted(by: {$0.value > $1.value }).first?.value else { return }
        let valuePoints = data.enumerated().map { CGPoint(x: CGFloat($0), y: CGFloat($1.value)) }
        let chartHeight = bounds.height / CGFloat(maxValue + topChartOffset)
        
        let points = valuePoints.map {
            let x = bounds.width / CGFloat(valuePoints.count - 1) * $0.x
            var y = bounds.height - $0.y - chartHeight
            
            if $0.y == 0.0 {
                y = bounds.height
            }
            return CGPoint(x: x, y: y)
        }
        
        let chartPath = UIBezierPath()
        chartPath.move(to: points[0])
        drawChartDot(at: points[0])
        
        points.forEach {
            chartPath.addLine(to: $0)
            drawChartDot(at: $0)
            drawLittleChartDot(at: $0)
        }
        
        let chartLayer = CAShapeLayer()
        chartLayer.path = chartPath.cgPath
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.strokeColor = R.Colors.orangeTwo.cgColor
        chartLayer.lineWidth = 3
        chartLayer.strokeEnd = 1
        chartLayer.lineJoin = .round
        chartLayer.zPosition = -1
//        chartLayer.shadowOffset = CGSize(width: 0, height: 5)
//        chartLayer.shadowOpacity = 0.5
//        chartLayer.shadowColor = UIColor.black.cgColor
//        chartLayer.shadowRadius = 2
        
        layer.addSublayer(chartLayer)
    }
    
    func drawChartDot(at point: CGPoint) {
        let dotPath = UIBezierPath()
        dotPath.move(to: point)
        dotPath.addLine(to: point)
        
        let dotLayer = CAShapeLayer()
        dotLayer.path = dotPath.cgPath
        dotLayer.strokeColor = R.Colors.orangeTwo.cgColor
        dotLayer.lineCap = .round
        dotLayer.lineWidth = 8
//        dotLayer.shadowOffset = CGSize(width: 0, height: 5)
//        dotLayer.shadowOpacity = 0.5
//        dotLayer.shadowColor = UIColor.black.cgColor
//        dotLayer.shadowRadius = 2
        
        layer.addSublayer(dotLayer)
    }
    
    func drawLittleChartDot(at point: CGPoint) {
        let dotPath = UIBezierPath()
        dotPath.move(to: point)
        dotPath.addLine(to: point)
        
        let dotLayer = CAShapeLayer()
        dotLayer.path = dotPath.cgPath
        dotLayer.strokeColor = R.Colors.darkBlue.cgColor
        dotLayer.lineCap = .round
        dotLayer.lineWidth = 4
        
        layer.addSublayer(dotLayer)
    }
}


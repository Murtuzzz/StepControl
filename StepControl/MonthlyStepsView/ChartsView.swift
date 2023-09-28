//
//  ChartsView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 14.09.2023.
//

import UIKit

extension ChartsView {
    struct Data {
        let value: Int
        let title: String
    }
}

final class ChartsView: UIView {
    
    private let yAxisView = YAxisView()
    private let xAxisView = XAxisView()
    
    private let chartView = ChartView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        chartView.backgroundColor = R.Colors.blue
        
        backgroundColor = .clear
        addSubview(xAxisView)
        addSubview(yAxisView)
        addSubview(chartView)
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(with data: [ChartsView.Data], topChartOffset: Int = 10) {
        yAxisView.configure(with: data, chartsOffsetView: topChartOffset-1)
        xAxisView.configure(with: data)
        chartView.configure(with: data, topChartOffset: topChartOffset)
    }
    
    func constraints() {
        
        yAxisView.translatesAutoresizingMaskIntoConstraints = false
        xAxisView.translatesAutoresizingMaskIntoConstraints = false
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            yAxisView.leadingAnchor.constraint(equalTo: leadingAnchor),
            yAxisView.topAnchor.constraint(equalTo: topAnchor),
            yAxisView.bottomAnchor.constraint(equalTo: xAxisView.topAnchor, constant: -12),
            yAxisView.widthAnchor.constraint(equalToConstant: 20),
            yAxisView.heightAnchor.constraint(equalToConstant: 20),
            
            xAxisView.leadingAnchor.constraint(equalTo: yAxisView.trailingAnchor, constant: 8),
            xAxisView.bottomAnchor.constraint(equalTo: bottomAnchor),
            xAxisView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 4),
            xAxisView.widthAnchor.constraint(equalToConstant: 100),
            xAxisView.heightAnchor.constraint(equalToConstant: 20),
            
            chartView.bottomAnchor.constraint(equalTo: xAxisView.topAnchor, constant: -16),
            chartView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            chartView.leadingAnchor.constraint(equalTo: yAxisView.trailingAnchor, constant: 16),
            chartView.widthAnchor.constraint(equalToConstant: 100),
            chartView.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
}

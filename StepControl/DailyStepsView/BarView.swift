//
//  BarView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 02.09.2023.
//

import UIKit

extension BarView {
    struct Data {
        let value: String
        let heightMultiplier: Double
        let title: String
    }
}

final class BarView: UIView {
    
    private var heightMultiplier: Double
    
    var color1: UIColor = R.Colors.darkBlue
    var color2: UIColor = R.Colors.blue
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 13)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let barView: UIView = {
        let view = UIView()
        view.backgroundColor = R.Colors.blue
        view.layer.cornerRadius = 2.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Fonts.avenirBook(with: 11)
        label.textColor = R.Colors.inactive
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(data: Data) {
        self.heightMultiplier = 0.0
        super.init(frame: .zero)
        
        self.heightMultiplier = heightConstraints(data: data)
        backgroundColor = .clear
        
        addSubview(valueLabel)
        addSubview(barView)
        addSubview(titleLabel)
        
       
        
        titleLabel.text = data.title
        //valueLabel.text = data.value
        
        if data.heightMultiplier <= 0.1 {
            valueLabel.text = "<1k"
        } else {
            valueLabel.text = data.value
        }
        
        constraints()
        //themeChange()
    }
    
    func heightConstraints(data: Data) -> Double {
        var height = 0.0
        if data.heightMultiplier >= 1 {
            height = 1
        } else if data.heightMultiplier <= 0.25 {
            height = 0.25
        } else {
            height = data.heightMultiplier
        }
        return height
    }
    
    required init?(coder: NSCoder) {
        self.heightMultiplier = 0
        super.init(frame: .zero)
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            
            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            barView.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 5),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            barView.widthAnchor.constraint(equalToConstant: 17),
            barView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier, constant: -35),
            
            titleLabel.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
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

//
//  HourlyStepsCell.swift
//  StepControl
//
//  Created by Мурат Кудухов on 19.09.2023.
//

import UIKit

final class HourlyStepsCell: UICollectionViewCell {
    
    static let id = "HourlyStepsCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(stackView)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurate(with data: BarData) {
        
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let barView = HourlyStepBar(data: data)
        
        stackView.addArrangedSubview(barView)
        
    }
    
    
    func constraints() {
        
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}

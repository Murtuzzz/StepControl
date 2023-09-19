//
//  YAxisView.swift
//  StepControl
//
//  Created by Мурат Кудухов on 14.09.2023.
//

import UIKit

final class YAxisView: UIView {
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.backgroundColor = .clear
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(stackView)
        backgroundColor = .clear

        constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
    }
    
    func configure(with data: [ChartsView.Data], chartsOffsetView: Int = 9) {
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        (0...chartsOffsetView).reversed().forEach { i in
            let label = UILabel()
            label.font  = R.Fonts.avenirBook(with: 9)
            label.textColor = .white
            label.textAlignment = .right
            label.text = "\(50 * i)k"
            
            stackView.addArrangedSubview(label)
        }
    }
    
    func constraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        
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
